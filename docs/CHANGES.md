# Falszifikáció és változtatások

## Mi bizonyítható a beadandóból?
Az eredeti PDF melléklete teljes SQL Server DDL-t, példa INSERT-eket és
CHECK/FK/UNIQUE szabályokat tartalmaz. A dokumentált SQL-feladatsor 17 SELECT
lekérdezést és egy eljárást tartalmaz. A helyi demó nem az eredeti DB mentése.

## Talált problémák, amelyeket nem szabad elhallgatni
1. **SQL-dialektus:** SQL Server 2022 T-SQL; a `GETDATE()`, `DATEADD()`,
   `IDENTITY(1,1)`, `OFFSET ... FETCH`, `@paraméter`, SQL Server Express útvonal
   kizárják a MySQL-re vonatkozó, korábbi feltételezést. A futó demó külön SQLite adaptáció.
2. **Pénzügyi jelentés:** az eredeti Q10/Q13/Q15 és tárolt eljárás a
   `PAYMENTS.amount_paid` értékeket fizetési státusz szűrés nélkül összegezte.
   Az eredeti mintában sikertelen és függő tranzakciók is vannak, ezért az
   összeget nem biztonságos ténylegesen befolyt bevételnek nevezni.
   Az adaptáció csak `PAYMENTS.payment_status='C'` státuszt számol.
3. **Névösszefűzés:** az eredeti T-SQL `last_name + '' + first_name` nem tesz
   szóközt a névbe. A SQLite demó helyesen közéjük tesz egy szóközt.
4. **Dátumintervallum:** Q5 eredeti literáljaiban OCR/textwrap szóközök és
   sortörések szerepelnek; az adaptáció fél-nyílt októberi intervallumot alkalmaz
   (`>= 2025-10-01`, `< 2025-11-01`).
5. **Szobakapacitás:** az eredeti Q8 `MAX(ROOMS.capacity)` ugyanarra az
   egyedi szobára aggregál. A demó egyértékű kapacitást közöl EXISTS kapcsolattal.
6. **Ütközéskezelés:** a beadandó szöveges követelménye szerint ugyanazt a
   szobát ugyanakkor nem lehet lefoglalni, de a mellékelt SQL DDL nem mutat
   átfedő időintervallumokra adatbázisszintű kizárást. Ezt a demó sem állítja.
7. **Szoba/élmény konzisztencia:** a BOOKINGS.room_id és az EXPERIENCES.room_id
   két külön FK; önmagában nincs közös összetett FK, amely egyezésüket
   kényszerítené. A demó tesztadatai egyeznek, általános garanciát nem állítunk.
8. **Rendelkezésre állás és visszatérítés:** a `ROOMS.availability_status` és
   a `BOOKINGS.status` nem teljes üzleti tranzakciós folyamat. A completed
   fizetés szűrése sem bizonyít könyvelési bevételt/visszatérítés-kezelést.
9. **TSQL-eljárás:** az eredetiben `sp_VendegOsszesBefizetese` szerepel. A
   portfolio T-SQL-fájl egy **külön, modernizált** eljárás; SQL Server
   runtime-teszt nincs, helyette SQLite paraméteres lekérdezés van.
10. **Foglalási státusz-ellentmondás:** az eredeti SQL Server export
    `BOOKINGS.status` mezőjének alapértéke `'C'`, viszont az eredeti
    `BOOKING_STATUSES` tesztadatokban `'C' = 'Lemondott'`, nem 'Confirmed'.
    A portfólió-adaptáció az `'A' = 'Aktív'` alapértéket használja.
11. **Számítási korlátok:** az SQLite demó nem követi az eredeti
    korfüggő `GETDATE()`-alapú CHECK szabályokat és a T-SQL-specifikus
    telefonszám-ellenőrzést pontosan, mert külön platformot céloz.
    A SQL Server újraalkotott változata ezeket tartalmazza, de natív
    futtathatósága nem igazolt.
12. **Mintafelhasználók:** az eredeti PDF mellékletében szereplő
    e-mail/telefon/lakcím mezőket NEM adjuk tovább. Minden demó-szereplő
    kitalált, `.example.test` címmel.

## Elválasztott bizonyíték
- ORIGINAL: dokumentációk, ER-diagram (külön, csak a kiválasztott oldal).
- ADAPTED: SQLite séma, tesztadatok és mind a 17+1 lekérdezés.
- VERIFIED: kizárólag a helyben ténylegesen lefuttatott SQLite E2E és tesztek.
- UNKNOWN: az eredeti SQL Server adatbázis friss natív futtathatósága.

## Publikálás előtti technikai javítás (2026-11-10)
13. **SQL Server batch-biztonság:** a T-SQL portfóliószkriptek kezdeti
    `IF DB_NAME() <> ... THROW` ellenőrzését `GO` batch-határok követték.
    Bizonyos kliensprogramok a következő batch-et is végrehajthatják a korábbi
    `THROW` után. A sémából, a mintaadatokból és a lekérdezésekből a `GO`
    elválasztókat eltávolítottuk; a tárolt eljárás definícióját guardolt,
    egybatch-es dinamikus `sp_executesql` hívásba tettük. A javítás statikus
    és célzott regressziós ellenőrzést kapott; a natív SQL Server E2E
    továbbra is **NOT TESTED**.
