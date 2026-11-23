-- JyldyzEles / Supabase products table
create extension if not exists pgcrypto;

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price numeric not null,
  description text,
  image_url text,
  created_at timestamptz default now()
);

alter table public.products add column if not exists brand text;
alter table public.products add column if not exists category text default 'parfum';
alter table public.products add column if not exists old_price numeric;
alter table public.products add column if not exists images jsonb default '[]'::jsonb;
alter table public.products add column if not exists icon text default 'fa-box';
alter table public.products add column if not exists is_new boolean default false;
alter table public.products add column if not exists is_sale boolean default false;
alter table public.products add column if not exists is_hot boolean default false;
alter table public.products add column if not exists featured boolean default false;
alter table public.products add column if not exists stock integer default 0;

alter table public.products enable row level security;

drop policy if exists "public read products" on public.products;
create policy "public read products"
on public.products for select to anon, authenticated using (true);

drop policy if exists "public insert products" on public.products;
create policy "public insert products"
on public.products for insert to anon, authenticated with check (true);

drop policy if exists "public update products" on public.products;
create policy "public update products"
on public.products for update to anon, authenticated using (true) with check (true);

drop policy if exists "public delete products" on public.products;
create policy "public delete products"
on public.products for delete to anon, authenticated using (true);

-- ==========================================
-- JyldyzEles: Product image storage
-- ==========================================

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = true;

drop policy if exists "public read product images" on storage.objects;
create policy "public read product images"
on storage.objects for select
to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "public upload product images" on storage.objects;
create policy "public upload product images"
on storage.objects for insert
to anon, authenticated
with check (bucket_id = 'product-images');

drop policy if exists "public update product images" on storage.objects;
create policy "public update product images"
on storage.objects for update
to anon, authenticated
using (bucket_id = 'product-images')
with check (bucket_id = 'product-images');

drop policy if exists "public delete product images" on storage.objects;
create policy "public delete product images"
on storage.objects for delete
to anon, authenticated
using (bucket_id = 'product-images');
