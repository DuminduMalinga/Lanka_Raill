// Deletes the signed-in user's account and their profile photo.
//
// Called by the app (Profile > Delete account) with the user's own session
// token. The function works out who the caller is from that token, so a user
// can only ever delete themselves. Everything else tied to the account
// (profile, favourites) is removed by the database when the user row goes;
// feedback they sent is kept but detached from them.
import { createClient } from "npm:@supabase/supabase-js@2";

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { "Content-Type": "application/json" },
  });

Deno.serve(async (req: Request) => {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);

  const url = Deno.env.get("SUPABASE_URL");
  const serviceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");
  if (!url || !serviceKey) {
    console.error("delete-account: missing SUPABASE_URL or service role key");
    return json({ error: "server_misconfigured" }, 500);
  }

  const token = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "");
  if (!token) return json({ error: "unauthorized" }, 401);

  const admin = createClient(url, serviceKey, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

  // Who is calling? (The public anon key is also a valid JWT, but it has no
  // user, so it is rejected here.)
  const { data, error } = await admin.auth.getUser(token);
  const user = data?.user;
  if (error || !user) return json({ error: "unauthorized" }, 401);

  // 1. Remove the profile photo(s). Done first, and if it fails the account is
  //    kept so the user can simply try again, instead of leaving public files
  //    behind with no owner.
  try {
    const bucket = admin.storage.from("avatars");
    const { data: files, error: listError } = await bucket.list(user.id, { limit: 1000 });
    if (listError) throw listError;
    if (files && files.length > 0) {
      const { error: removeError } = await bucket.remove(files.map((f) => `${user.id}/${f.name}`));
      if (removeError) throw removeError;
    }
  } catch (e) {
    console.error("delete-account: could not remove photos", user.id, e);
    return json({ error: "delete_failed" }, 500);
  }

  // 2. Delete the user. Foreign keys cascade to profiles and favourites.
  const { error: deleteError } = await admin.auth.admin.deleteUser(user.id);
  if (deleteError) {
    console.error("delete-account: could not delete user", user.id, deleteError);
    return json({ error: "delete_failed" }, 500);
  }

  return json({ ok: true });
});
