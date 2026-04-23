-- BUTTERFLY. 筋トレ記録テーブル
-- Supabase SQL Editor で一度だけ実行してください。

create table if not exists public.workouts (
  id uuid primary key default gen_random_uuid(),
  pair_id uuid not null references public.pairs(id) on delete cascade,
  person text not null check (person in ('husband','wife')),
  date date not null,
  exercise text not null,
  sets integer not null default 1 check (sets >= 1),
  reps integer not null default 1 check (reps >= 1),
  weight numeric,
  memo text,
  created_at timestamptz not null default now()
);

create index if not exists workouts_pair_date_idx on public.workouts (pair_id, date desc);

alter table public.workouts enable row level security;

-- 匿名ロールから読み書きを許可（既存 meals/daily_records と同じ運用）
drop policy if exists "workouts select anon" on public.workouts;
drop policy if exists "workouts insert anon" on public.workouts;
drop policy if exists "workouts update anon" on public.workouts;
drop policy if exists "workouts delete anon" on public.workouts;

create policy "workouts select anon" on public.workouts for select using (true);
create policy "workouts insert anon" on public.workouts for insert with check (true);
create policy "workouts update anon" on public.workouts for update using (true) with check (true);
create policy "workouts delete anon" on public.workouts for delete using (true);

-- Realtime を有効化
alter publication supabase_realtime add table public.workouts;
