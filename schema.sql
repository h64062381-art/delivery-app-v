create extension if not exists pgcrypto;
create type public.user_role as enum ('customer','restaurant_owner','restaurant_staff','driver','support','admin');
create type public.order_status as enum ('pending','confirmed','preparing','ready','picked_up','on_the_way','delivered','cancelled');
create type public.payment_status as enum ('pending','paid','failed','refunded','partially_refunded');
create table if not exists public.profiles(id uuid primary key references auth.users(id) on delete cascade,full_name text,phone text unique,role public.user_role not null default 'customer',avatar_url text,created_at timestamptz not null default now(),updated_at timestamptz not null default now());
create table if not exists public.restaurants(id uuid primary key default gen_random_uuid(),owner_id uuid references public.profiles(id),name text not null,slug text unique not null,description text,logo_url text,cover_url text,phone text,address text,lat double precision,lng double precision,rating numeric(2,1) default 0,delivery_fee integer default 0,min_order integer default 0,is_open boolean default true,is_verified boolean default false,commission_rate numeric(5,2) default 15,created_at timestamptz not null default now(),updated_at timestamptz not null default now());
create table if not exists public.restaurant_hours(id uuid primary key default gen_random_uuid(),restaurant_id uuid not null references public.restaurants(id) on delete cascade,dow smallint not null check(dow between 0 and 6),open_time time,close_time time,is_closed boolean default false);
create table if not exists public.categories(id uuid primary key default gen_random_uuid(),name_ar text not null,slug text unique not null,sort_order int default 0);
create table if not exists public.menu_items(id uuid primary key default gen_random_uuid(),restaurant_id uuid not null references public.restaurants(id) on delete cascade,category_id uuid references public.categories(id),name_ar text not null,description_ar text,price integer not null check(price>=0),image_url text,is_available boolean default true,options jsonb default '[]'::jsonb,sort_order int default 0,created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists public.addresses(id uuid primary key default gen_random_uuid(),user_id uuid not null references public.profiles(id) on delete cascade,label text,phone text,address_line text not null,lat double precision,lng double precision,notes text,is_default boolean default false,created_at timestamptz default now());
create table if not exists public.coupons(id uuid primary key default gen_random_uuid(),code text unique not null,kind text not null check(kind in('fixed','percent','delivery')),value numeric not null,min_order integer default 0,max_discount integer,starts_at timestamptz,ends_at timestamptz,max_uses int,uses_count int default 0,is_active boolean default true);
create table if not exists public.orders(id uuid primary key default gen_random_uuid(),public_code text unique not null,customer_id uuid references public.profiles(id),restaurant_id uuid not null references public.restaurants(id),driver_id uuid references public.profiles(id),address_id uuid references public.addresses(id),status public.order_status not null default 'pending',payment_method text not null default 'cash',payment_status public.payment_status not null default 'pending',payment_reference text,customer_name text,customer_phone text,delivery_address text,lat double precision,lng double precision,notes text,subtotal integer not null default 0,delivery_fee integer not null default 0,discount integer not null default 0,total integer not null default 0,coupon_id uuid references public.coupons(id),created_at timestamptz default now(),accepted_at timestamptz,prepared_at timestamptz,picked_up_at timestamptz,delivered_at timestamptz,cancelled_at timestamptz);
create table if not exists public.order_items(id uuid primary key default gen_random_uuid(),order_id uuid not null references public.orders(id) on delete cascade,menu_item_id uuid references public.menu_items(id),product_name text not null,price integer not null,quantity integer not null check(quantity>0),options jsonb default '[]'::jsonb);
create table if not exists public.order_events(id bigint generated always as identity primary key,order_id uuid not null references public.orders(id) on delete cascade,status public.order_status,actor_id uuid references public.profiles(id),message text,created_at timestamptz default now());
create table if not exists public.driver_locations(id bigint generated always as identity primary key,driver_id uuid not null references public.profiles(id) on delete cascade,order_id uuid references public.orders(id) on delete cascade,lat double precision not null,lng double precision not null,heading double precision,speed double precision,created_at timestamptz default now());
create table if not exists public.reviews(id uuid primary key default gen_random_uuid(),order_id uuid unique not null references public.orders(id) on delete cascade,customer_id uuid not null references public.profiles(id),restaurant_id uuid not null references public.restaurants(id),driver_id uuid references public.profiles(id),restaurant_rating int check(restaurant_rating between 1 and 5),driver_rating int check(driver_rating between 1 and 5),food_rating int check(food_rating between 1 and 5),comment text,created_at timestamptz default now());
create table if not exists public.support_tickets(id uuid primary key default gen_random_uuid(),customer_id uuid references public.profiles(id),order_id uuid references public.orders(id),subject text,priority text default 'normal',status text default 'open',created_at timestamptz default now(),updated_at timestamptz default now());
create table if not exists public.support_messages(id bigint generated always as identity primary key,ticket_id uuid not null references public.support_tickets(id) on delete cascade,sender_id uuid references public.profiles(id),message text not null,created_at timestamptz default now());
create table if not exists public.wallet_transactions(id uuid primary key default gen_random_uuid(),user_id uuid references public.profiles(id),order_id uuid references public.orders(id),amount integer not null,type text not null,reference text,created_at timestamptz default now());
create index if not exists idx_orders_customer on public.orders(customer_id,created_at desc);create index if not exists idx_orders_restaurant on public.orders(restaurant_id,status,created_at desc);create index if not exists idx_locations_order on public.driver_locations(order_id,created_at desc);create index if not exists idx_menu_restaurant on public.menu_items(restaurant_id,is_available);


-- V10 security baseline: enable RLS on sensitive operational tables.
alter table public.profiles enable row level security;
alter table public.addresses enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;
alter table public.order_events enable row level security;
alter table public.driver_locations enable row level security;
alter table public.reviews enable row level security;
alter table public.support_tickets enable row level security;
alter table public.support_messages enable row level security;

-- These policies are intentionally conservative starters. Review with your production roles before launch.
drop policy if exists "profiles own read" on public.profiles;
drop policy if exists "profiles own update" on public.profiles;
drop policy if exists "addresses own access" on public.addresses;
drop policy if exists "orders customer read" on public.orders;
drop policy if exists "order items customer read" on public.order_items;
drop policy if exists "order events customer read" on public.order_events;
drop policy if exists "driver own locations" on public.driver_locations;
drop policy if exists "reviews own read" on public.reviews;
drop policy if exists "reviews own create" on public.reviews;
drop policy if exists "support own tickets" on public.support_tickets;
drop policy if exists "support own messages" on public.support_messages;
create policy "profiles own read" on public.profiles for select using (auth.uid() = id);
create policy "profiles own update" on public.profiles for update using (auth.uid() = id);
create policy "addresses own access" on public.addresses for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "orders customer read" on public.orders for select using (auth.uid() = customer_id);
create policy "order items customer read" on public.order_items for select using (exists(select 1 from public.orders o where o.id=order_id and o.customer_id=auth.uid()));
create policy "order events customer read" on public.order_events for select using (exists(select 1 from public.orders o where o.id=order_id and o.customer_id=auth.uid()));
create policy "driver own locations" on public.driver_locations for all using (auth.uid() = driver_id) with check (auth.uid() = driver_id);
create policy "reviews own read" on public.reviews for select using (auth.uid() = customer_id);
create policy "reviews own create" on public.reviews for insert with check (auth.uid() = customer_id);
create policy "support own tickets" on public.support_tickets for all using (auth.uid() = customer_id) with check (auth.uid() = customer_id);
create policy "support own messages" on public.support_messages for select using (exists(select 1 from public.support_tickets t where t.id=ticket_id and t.customer_id=auth.uid()));
