-- Follow-up to feedback_rate_limit after a security review:
--  * all anonymous senders shared one pool of 30/hour, so one looping client
--    could lock every other signed-out user out: anonymous limits are now per
--    sender, with a larger overall cap as a backstop
--  * app_version had no length limit
--  * the count-then-insert check could be raced by parallel requests: a
--    per-sender advisory lock now serialises them
-- A sender is identified by Cloudflare's cf-connecting-ip header (a client
-- cannot set it; X-Forwarded-For can be spoofed). Only a one-way hash that
-- changes every day is stored, never the address.
alter table public.feedback add column sender_key text;
alter table public.feedback
  add constraint feedback_app_version_length check (char_length(app_version) <= 32);
create index feedback_sender_created_idx
  on public.feedback (sender_key, created_at) where sender_key is not null;

create or replace function public.limit_feedback_rate()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  ip text;
  recent integer;
begin
  if new.user_id is not null then
    -- signed in: 5 per hour per user
    perform pg_advisory_xact_lock(hashtextextended('feedback:user:' || new.user_id::text, 0));
    select count(*) into recent from public.feedback
    where user_id = new.user_id and created_at > now() - interval '1 hour';
    if recent >= 5 then
      raise exception 'feedback_rate_limited' using errcode = 'FB429';
    end if;
    new.sender_key := null;
    return new;
  end if;

  -- anonymous: 5 per hour per sender, and 200 per hour overall
  ip := nullif(
    coalesce(nullif(current_setting('request.headers', true), ''), '{}')::json ->> 'cf-connecting-ip',
    ''
  );
  if ip is not null then
    new.sender_key := encode(
      sha256(convert_to(ip || '|' || current_date::text || '|ceylongo-feedback', 'utf8')),
      'hex'
    );
  else
    new.sender_key := null;
  end if;

  perform pg_advisory_xact_lock(hashtextextended('feedback:anon:' || coalesce(new.sender_key, 'unknown'), 0));

  if new.sender_key is not null then
    select count(*) into recent from public.feedback
    where sender_key = new.sender_key and created_at > now() - interval '1 hour';
    if recent >= 5 then
      raise exception 'feedback_rate_limited' using errcode = 'FB429';
    end if;
  end if;

  select count(*) into recent from public.feedback
  where user_id is null and created_at > now() - interval '1 hour';
  if recent >= 200 then
    raise exception 'feedback_rate_limited' using errcode = 'FB429';
  end if;
  return new;
end;
$$;

revoke execute on function public.limit_feedback_rate() from public, anon, authenticated;
