-- Feedback can be sent by anyone (even signed out), so cap how much one sender,
-- or all anonymous senders together, can add. Enforced here so it holds no
-- matter how the API is called.
--   signed in: 5 messages per hour per user
--   anonymous: 30 messages per hour in total
-- A refused insert fails with SQLSTATE FB429.
create index feedback_created_idx on public.feedback (created_at);
create index feedback_user_created_idx on public.feedback (user_id, created_at);

create function public.limit_feedback_rate()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  recent integer;
begin
  if new.user_id is not null then
    select count(*) into recent from public.feedback
    where user_id = new.user_id and created_at > now() - interval '1 hour';
    if recent >= 5 then
      raise exception 'feedback_rate_limited' using errcode = 'FB429';
    end if;
  else
    select count(*) into recent from public.feedback
    where user_id is null and created_at > now() - interval '1 hour';
    if recent >= 30 then
      raise exception 'feedback_rate_limited' using errcode = 'FB429';
    end if;
  end if;
  return new;
end;
$$;

revoke execute on function public.limit_feedback_rate() from public, anon, authenticated;

create trigger feedback_rate_limit
  before insert on public.feedback
  for each row execute function public.limit_feedback_rate();
