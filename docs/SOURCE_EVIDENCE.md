# Forrás és eredet

Az eredeti, **önálló egyetemi** munkát a hallgató 2025. október 22-i
*Adatbázis-kezelés 1* (28 oldal), illetve 2026. március 19-i
*Adatbázis-kezelés 2* (38 oldal) dokumentációja támasztja alá.

| Eredeti dokumentáció | SHA-256 |
|---|---|
| Adatbázis-kezelés 1 (PDF) | `f13f1f9c39d1c5649c56743a62a3f88313da8fcaf31242fa9db19364c66be129` |
| Adatbázis-kezelés 2 (PDF) | `35a4745768804ab29044e476f7bdd59a2e91097c53188d3e6ce00d212759caef` |

A források nem kerültek bele ebbe a nyilvánosságra előkészített csomagba:
fedlapi személyes azonosítót, gépelérési utat és eredeti vendégmintákban
személyes adatnak tűnő mezőket tartalmaznak. A `docs/original_er_diagram.png`
csak az eredeti PDF 14. oldalának, ilyen adat nélküli diagramja.

## Bizonyított (dokumentumszint)
- Microsoft SQL Server Express, `VRElmenypark`, SQL Server 2022 kompatibilitás 160;
- 13 tábla: 7 fő entitás + 6 kódtábla;
- 17 kidolgozott SQL-feladat és 1 tárolt eljárás a 2. PDF-ben;
- táblákhoz tartozó kulcsok, idegen kulcsok, alapértékek, CHECK feltételek;
- az eredeti ER-ábra a PDF 14. oldalán látható.

## Nem bizonyított
- A régi Windows-gép eredeti `.mdf` / `.bak` állománya nincs meg.
- Az eredeti SQL Server-példány jelenleg nem elérhető.
- Az eredeti 17+1 kód SQL Serveren végzett friss, hibamentes futása nem igazolt.
- Az eredeti dokumentumban szereplő tervezett felületek nem bizonyítanak elkészült alkalmazást.

## Utólagos demonstráció eredete
A `sql/sqlite` és `sql/sqlserver` fájlok, a demó-adatok, a futtató és a tesztek **2026-os, AI-támogatással készített utólagos
portfólió-adaptációk**, nem a 2025–26-os beadandó változatlan fájljai.
A demonstráció SQLite-on fut, így nem állít SQL Server-validációt.
