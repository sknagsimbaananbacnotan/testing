-- Run this once in Supabase SQL Editor
create extension if not exists pgcrypto;
create table if not exists public.wifi_announcements (
 id uuid primary key default gen_random_uuid(),
 title text not null default 'Official Announcement',
 caption text not null default '',
 image_url text,
 is_active boolean not null default true,
 updated_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
alter table public.wifi_announcements enable row level security;
drop policy if exists "Public can read active wifi announcements" on public.wifi_announcements;
create policy "Public can read active wifi announcements" on public.wifi_announcements for select using (is_active = true or auth.role() = 'authenticated');
drop policy if exists "Authenticated staff can insert wifi announcements" on public.wifi_announcements;
create policy "Authenticated staff can insert wifi announcements" on public.wifi_announcements for insert to authenticated with check (auth.uid() = updated_by);
drop policy if exists "Authenticated staff can update wifi announcements" on public.wifi_announcements;
create policy "Authenticated staff can update wifi announcements" on public.wifi_announcements for update to authenticated using (true) with check (auth.uid() = updated_by);
insert into storage.buckets (id,name,public) values ('wifi-announcements','wifi-announcements',true) on conflict (id) do update set public=true;
drop policy if exists "Public read wifi announcement images" on storage.objects;
create policy "Public read wifi announcement images" on storage.objects for select using (bucket_id='wifi-announcements');
drop policy if exists "Authenticated staff upload wifi announcement images" on storage.objects;
create policy "Authenticated staff upload wifi announcement images" on storage.objects for insert to authenticated with check (bucket_id='wifi-announcements');
