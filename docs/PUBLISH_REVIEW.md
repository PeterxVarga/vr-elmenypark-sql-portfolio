# Publikálás előtti szakmai ellenőrzés · 2026-11-10

## Eredet
- Eredeti két egyetemi PDF: helyben ellenőrzött SHA-256; nem része a csomagnak.
- Eredeti, 13 táblás SQL Server-terv és 17+1 kidolgozott feladat.
- ER-diagram: kivágat a beadandóból, emberi rekordadatok nélkül.
- Új SQLite és T-SQL minta: AI-támogatott, fiktív, utólagos adaptáció.

## Bizonyítékszintek
- PASS: csak offline, szintetikus SQLite E2E (13 tábla, 17 SELECT + 1
  paraméterezett megfelelő), célzott automata tesztek.
- STATIKUS: T-SQL szkriptek struktúrájának, szintaxis-mintáinak és batch-
  biztonsági szerződésének ellenőrzése.
- UNKNOWN: natív SQL Server futás, a korábbi Windows eredeti MDF/BAK mentése.

## Falszifikációs eredmények
- Az eredeti fizetési aggregációk sikertelen/függő tételeket is hozzáadtak.
  A demó külön kezeli őket, és kizárólag fiktív értékekkel szemlélteti a hatást.
- Eredeti BOOKING_STATUSES: C lemondott, de az export C defaultot is tartalmaz.
  A demó külön dokumentált A aktív alapértéket alkalmaz.
- Foglalási időátfedés és BOOKINGS/EXPERIENCES szobaegyezése nem garantált
  az eredeti DDL alapján. A demó nem állít működő foglalás-validátort.
- A T-SQL portfóliószkriptek első verziójában a DB-guard `GO` miatt
  nem védett megbízhatóan minden későbbi batch-et; egybatch-esre javítva.

## Publikálási határok
- A két eredeti PDF és a reálisnak tűnő vendégminták nem kerülnek ki.
- A dokumentációban nem állítunk élő üzemi működést vagy SQL Server natív PASS-t.
- Nincs eredeti teljes SQL Server adatbázis-export a csomagban.
- A publikus GitHub-tároló létrejötte / fájlok feltöltése külön ellenőrizendő.
