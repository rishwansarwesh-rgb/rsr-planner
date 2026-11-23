-- RSR Planner · databaseschema fase 1
-- Plakken in Supabase → SQL Editor → New query → Run

create table if not exists locaties (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  naam text not null,
  adres text not null,
  lat double precision not null,
  lon double precision not null,
  is_thuis boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists afspraken (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  titel text not null,
  categorie text not null check (categorie in ('studie','werk','prive','sport')),
  datum date not null,
  start_tijd time not null,
  eind_tijd time not null,
  locatie_id uuid references locaties on delete set null,
  vervoer text not null default 'auto' check (vervoer in ('auto','ov','fiets')),
  vast boolean not null default true,
  updated_at timestamptz not null default now(),
  check (eind_tijd > start_tijd)
);

create table if not exists reistijd_correcties (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  locatie_a uuid not null references locaties on delete cascade,
  locatie_b uuid not null references locaties on delete cascade,
  vervoer text not null check (vervoer in ('auto','ov','fiets')),
  minuten integer not null check (minuten > 0),
  primary key (user_id, locatie_a, locatie_b, vervoer)
);

create table if not exists instellingen (
  user_id uuid primary key default auth.uid() references auth.users on delete cascade,
  data jsonb not null default '{"omrij":1.3,"auto":60,"fiets":15,"ov":40,"ovWacht":10,"bAuto":10,"bOv":5,"bFiets":5,"meld":10}'
);

create table if not exists geocode_cache (
  zoekterm text primary key,
  lat double precision not null,
  lon double precision not null,
  weergave text,
  created_at timestamptz not null default now()
);

-- Alleen jij ziet en wijzigt je eigen gegevens
alter table locaties enable row level security;
alter table afspraken enable row level security;
alter table reistijd_correcties enable row level security;
alter table instellingen enable row level security;
alter table geocode_cache enable row level security; -- alleen de server (service_role) schrijft hierin

create policy "eigen locaties" on locaties for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigen afspraken" on afspraken for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigen correcties" on reistijd_correcties for all using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigen instellingen" on instellingen for all using (user_id = auth.uid()) with check (user_id = auth.uid());

create index if not exists afspraken_datum on afspraken (user_id, datum);

-- Rechten voor ingelogde gebruiker
grant select, insert, update, delete on public.locaties, public.afspraken, public.reistijd_correcties, public.instellingen to authenticated;
