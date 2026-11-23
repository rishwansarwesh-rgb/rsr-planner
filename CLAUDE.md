# RSR Planner – projectstatus en werkafspraken

Persoonlijke planner van Rishwan Ramsoedh (Roosendaal). Antwoord in het Nederlands,
zakelijk-vriendelijk, conclusie eerst. Volledige briefing: `docs/briefing.md`.

## Status (24-11-2026)
- **Fase 1 afgerond en getest** (live): handmatige invoer, locaties via OpenStreetMap,
  geschatte reistijd, reisblokken + "Vertrek om", terugreis, overlap/botsing/reistijd-meldingen.
  Test Breda 09:00 per auto → vertrek 08:20 (30 min + 10 buffer, 29,2 km) geslaagd.
- **Volgende: fase 2** – AI-invoer in gewone taal (JSON-voorstel, pas opslaan na bevestiging),
  automatisch inplannen flexibele taken, deadlines opknippen (laatste blok ≥ 1 dag vóór deadline),
  AI-verbruik zichtbaar, maandlimiet € 5 (melding 80%, stop 100%).
  Vereist: AI-account met vooraf betaald tegoed + serverless back-end (Cloudflare Workers)
  zodat de API-sleutel niet in de browser staat. Cloudflare-account nog niet aangemaakt.
- Fase 3: Apple Agenda via iCloud CalDAV + pushmeldingen. Fase 4: live reistijd.

## Omgeving
- Live: https://rishwansarwesh-rgb.github.io/rsr-planner/ (GitHub Pages, branch `main`, root)
- Repo: rishwansarwesh-rgb/rsr-planner (publiek)
- Database/auth: Supabase project `rsr-planner`, URL https://rhtpluvctikoiobecjlj.supabase.co
  - anon key staat in `index.html` (veilig, RLS aan). service_role nooit in de front-end.
  - Schema: `schema.sql` (tabellen locaties, afspraken, reistijd_correcties, instellingen,
    geocode_cache; RLS per user_id; GRANT aan `authenticated` is nodig, staat onderaan).
  - Auth: e-mail + wachtwoord; nieuwe aanmeldingen staan UIT (alleen Rishwan).
  - Site URL ingesteld op de GitHub Pages-URL.

## Code
- `index.html`: hele app (vanilla JS, supabase-js 2.45.4 via jsDelivr).
  Reistijd: hemelsbreed × omrijfactor (1,3), auto 60 / fiets 15 / OV 40 km/u + 10 min,
  buffers auto 10 / OV 5 / fiets 5; correctie per route gaat vóór schatting.
- `sw.js`: service worker (offline-kopie). Verhoog `C='rsr-vN'` bij elke release.
- `manifest.webmanifest`, `icon-*.png`: PWA.
- Let op: geen `await` op Supabase-calls binnen `onAuthStateChange` (deadlock) — gebruik setTimeout.

## Huisstijl RSR
Navy #1B2A41, Slate #5B6B82, Messing #A8875A (spaarzaam), Zand #E8E2D6, Crème #F7F5F0,
tekst #1E2430, grijs #5E6470. Alleen Fraunces (fallback Georgia). Rechte hoeken, haarlijnen,
geen schaduw/verloop/emoji. Tikvlakken ≥ 44 px. 24-uursklok, 4,2 km, € 1.250.

## Werkwijze
- Budget max € 5/maand, alleen gratis tiers, geen creditcard zonder harde limiet.
- App rekent deterministisch; AI alleen taal en inschatting, output JSON, gecontroleerd vóór opslaan.
- Nooit iets in de agenda wijzigen zonder bevestiging. Bij twijfel één korte vraag.
- Inloggen/wachtwoorden doet Rishwan zelf.
