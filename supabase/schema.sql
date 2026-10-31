-- ScriptHub database setup for Supabase
-- Run the entire file in Supabase Dashboard > SQL Editor > New query.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  created_at timestamptz not null default now()
);
create table if not exists public.scripts (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 80),
  description text not null default '' check (char_length(description) <= 300),
  script_type text not null default 'Script' check (script_type in ('Script','LocalScript','ModuleScript')),
  visibility text not null default 'public' check (visibility in ('public','private')),
  code text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  script_id uuid not null references public.scripts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 500),
  created_at timestamptz not null default now()
);
create table if not exists public.script_likes (
  script_id uuid not null references public.scripts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (script_id,user_id)
);

create index if not exists scripts_owner_idx on public.scripts(owner_id);
create index if not exists scripts_visibility_created_idx on public.scripts(visibility,created_at desc);
create index if not exists comments_script_created_idx on public.comments(script_id,created_at);
create index if not exists likes_user_idx on public.script_likes(user_id);

alter table public.profiles enable row level security;
alter table public.scripts enable row level security;
alter table public.comments enable row level security;
alter table public.script_likes enable row level security;

drop policy if exists "Profiles are publicly readable" on public.profiles;
create policy "Profiles are publicly readable" on public.profiles for select using (true);
drop policy if exists "Users create own profile" on public.profiles;
create policy "Users create own profile" on public.profiles for insert with check (auth.uid() = id);
drop policy if exists "Users update own profile" on public.profiles;
create policy "Users update own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Public scripts or own scripts are readable" on public.scripts;
create policy "Public scripts or own scripts are readable" on public.scripts for select using (visibility = 'public' or auth.uid() = owner_id);
drop policy if exists "Users create own scripts" on public.scripts;
create policy "Users create own scripts" on public.scripts for insert with check (auth.uid() = owner_id);
drop policy if exists "Users update own scripts" on public.scripts;
create policy "Users update own scripts" on public.scripts for update using (auth.uid() = owner_id) with check (auth.uid() = owner_id);
drop policy if exists "Users delete own scripts" on public.scripts;
create policy "Users delete own scripts" on public.scripts for delete using (auth.uid() = owner_id);

drop policy if exists "Comments on visible scripts are readable" on public.comments;
create policy "Comments on visible scripts are readable" on public.comments for select using (exists (select 1 from public.scripts s where s.id = script_id and (s.visibility = 'public' or s.owner_id = auth.uid())));
drop policy if exists "Signed-in users comment on visible scripts" on public.comments;
create policy "Signed-in users comment on visible scripts" on public.comments for insert with check (auth.uid() = user_id and exists (select 1 from public.scripts s where s.id = script_id and s.visibility = 'public'));
drop policy if exists "Users delete own comments" on public.comments;
create policy "Users delete own comments" on public.comments for delete using (auth.uid() = user_id);

drop policy if exists "Likes are readable on public scripts" on public.script_likes;
create policy "Likes are readable on public scripts" on public.script_likes for select using (exists (select 1 from public.scripts s where s.id = script_id and (s.visibility = 'public' or s.owner_id = auth.uid())));
drop policy if exists "Users like public scripts" on public.script_likes;
create policy "Users like public scripts" on public.script_likes for insert with check (auth.uid() = user_id and exists (select 1 from public.scripts s where s.id = script_id and s.visibility = 'public'));
drop policy if exists "Users remove own likes" on public.script_likes;
create policy "Users remove own likes" on public.script_likes for delete using (auth.uid() = user_id);

-- Create a profile automatically when someone signs up.
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = '' as $$
declare base_name text;
begin
  base_name := coalesce(nullif(split_part(new.email, '@', 1), ''), 'creator') || '_' || substr(new.id::text, 1, 6);
  insert into public.profiles (id, username) values (new.id, base_name);
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();

grant usage on schema public to anon, authenticated;
grant select on public.profiles to anon, authenticated;
grant insert, update on public.profiles to authenticated;
grant select on public.scripts to anon, authenticated;
grant insert, update, delete on public.scripts to authenticated;
grant select, insert, delete on public.comments to authenticated;
grant select, insert, delete on public.script_likes to authenticated;
