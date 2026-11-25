# Sessie 25-11-2026: fase 2 en Apple Agenda

Samenvatting van de chat met Claude over de RSR Planner.

## Besluiten

Geen AI-account met vooraf betaald tegoed. De AI draait op Cloudflare Workers AI op het gratis plan: dagelijks gratis verbruik, geen creditcard. Is het op, dan geeft de app de melding ai-limiet en plan je handmatig verder.

Jumbo-rooster (R&R Job) en Avans-rooster komen via Apple Agenda binnen. De planner koppelt daardoor alleen met iCloud.

## Wat is gebouwd

Cloudflare-account aangemaakt. Worker live op https://hello-world-muddy-heart-7f0c.rishwansarwesh.workers.dev met binding AI en de secrets APPLE_ID en APPLE_APP_PW. Endpoints: GET /health, POST /parse (AI-voorstel), /cal/events, /cal/put en /cal/delete (iCloud CalDAV). Alle POST-aanroepen vereisen inloggen via Supabase.

App versie 5 (sw rsr-v5): AI-invoer in gewone taal op Vandaag. De AI geeft een voorstel, jij vinkt aan, pas dan wordt opgeslagen. Flexibele taken zonder tijd gaan naar het eerste vrije blok. Deadlines worden herkend maar nog niet opgeknipt. AI-verbruik per dag staat bij Instellingen.

Apple Agenda: de Worker leest de iCloud-agenda's (Bijschrijvingen, Afschrijvingen, Privé Rishwan, Werk). Afspraken met tijden verschijnen als vaste afspraken; hele-dag-items worden overgeslagen. Planner-afspraken gaan naar de agenda RSR Planner. Wijzigingen in Apple Agenda worden overgenomen. Synchroniseren bij openen, bij Vernieuwen, elke 5 minuten en met de knop bij Instellingen.

## Open punten

Jumbo- en Avans-rooster staan nog niet in iCloud, dus nu 0 afspraken met tijden. Actie Rishwan: iCal-link of screenshot uit R&R Job en het Avans-rooster.

Daarna: deadlines opknippen in werkblokken, kiezen bij een conflict (nu wint Apple Agenda), pushmeldingen voor vertrek en avondplanning. Fase 4: live reistijd.

De Worker-code (worker.js) staat nog niet in deze repo; die moet nog worden geüpload naar de map worker.
