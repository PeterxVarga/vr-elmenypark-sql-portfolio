-- Rewritten 17 SQL Server queries from the original assignment themes.
-- These have NOT been executed against a native SQL Server instance.
-- Original source and correction notes: docs/SOURCE_EVIDENCE.md / docs/CHANGES.md.
IF DB_NAME() <> N'VRElmenyparkPortfolio'
    THROW 51002, 'Wrong database', 1;
-- Q01
SELECT ROUND(AVG(price), 2) AS atlagos_ar FROM EXPERIENCES;
-- Q02
SELECT SUM(duration_minutes) AS osszes_jatekido_percben FROM EXPERIENCES;
-- Q03
SELECT e.experience_name, c.description AS kategoria FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON e.category = c.code ORDER BY c.description, e.experience_name;
-- Q04
SELECT c.description AS kategoria, ROUND(AVG(e.price), 2) AS atlagos_ar FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON e.category = c.code GROUP BY c.code, c.description ORDER BY atlagos_ar DESC;
-- Q05
SELECT CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, b.booking_date AS foglalas_datuma FROM GUESTS g JOIN BOOKINGS b ON b.guest_id = g.guest_id WHERE b.booking_date >= '2025-10-01' AND b.booking_date < '2025-11-01' ORDER BY b.booking_date, b.booking_id;
-- Q06
SELECT CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, COUNT(b.booking_id) AS foglalasok_szama FROM GUESTS g LEFT JOIN BOOKINGS b ON b.guest_id = g.guest_id GROUP BY g.guest_id, g.first_name, g.last_name ORDER BY foglalasok_szama DESC, g.guest_id;
-- Q07
SELECT e.experience_name, d.description AS nehezsegi_szint FROM EXPERIENCES e JOIN DIFFICULTY_LEVELS d ON e.difficulty_level = d.code ORDER BY CASE d.description WHEN 'Easy' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Hard' THEN 3 ELSE 4 END, e.experience_name;
-- Q08
SELECT r.room_name, r.capacity AS max_befogadokepesseg FROM ROOMS r WHERE EXISTS(SELECT 1 FROM EXPERIENCES e WHERE e.room_id = r.room_id) ORDER BY r.capacity DESC, r.room_name;
-- Q09
SELECT CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, e.experience_name, r.room_name, b.start_time FROM BOOKINGS b JOIN GUESTS g ON g.guest_id=b.guest_id JOIN EXPERIENCES e ON e.experience_id=b.experience_id JOIN ROOMS r ON r.room_id=b.room_id ORDER BY b.start_time DESC;
-- Q10
SELECT TOP (1) CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, SUM(p.amount_paid) AS osszes_sikeres_befizetes FROM GUESTS g JOIN BOOKINGS b ON b.guest_id=g.guest_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY g.guest_id, g.first_name, g.last_name ORDER BY osszes_sikeres_befizetes DESC, g.guest_id;
-- Q11
SELECT b.booking_id, CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, b.booking_date, p.amount_paid, s.description AS fizetes_statusza FROM BOOKINGS b JOIN PAYMENTS p ON p.booking_id=b.booking_id JOIN PAYMENT_STATUSES s ON s.code=p.payment_status JOIN GUESTS g ON g.guest_id=b.guest_id ORDER BY b.booking_date, b.booking_id, p.payment_id;
-- Q12
SELECT e.experience_name, c.description AS kategoria, COUNT(b.booking_id) AS foglalasok_szama FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON c.code=e.category LEFT JOIN BOOKINGS b ON b.experience_id=e.experience_id GROUP BY e.experience_id, e.experience_name, c.description ORDER BY foglalasok_szama DESC, e.experience_name;
-- Q13
SELECT c.description AS kategoria, SUM(p.amount_paid) AS sikeres_befizetes_osszesen FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON c.code=e.category JOIN BOOKINGS b ON b.experience_id=e.experience_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY c.code, c.description ORDER BY sikeres_befizetes_osszesen DESC;
-- Q14
SELECT CONCAT(g.first_name, N' ', g.last_name) AS vendeg_neve, e.experience_name, d.description AS nehezsegi_szint FROM BOOKINGS b JOIN GUESTS g ON b.guest_id=g.guest_id JOIN EXPERIENCES e ON e.experience_id=b.experience_id JOIN DIFFICULTY_LEVELS d ON d.code=e.difficulty_level ORDER BY g.last_name, g.first_name;
-- Q15
SELECT r.room_name, SUM(p.amount_paid) AS sikeres_befizetes_osszesen FROM ROOMS r JOIN BOOKINGS b ON b.room_id=r.room_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY r.room_id, r.room_name ORDER BY sikeres_befizetes_osszesen DESC, r.room_name;
-- Q16
SELECT d.description AS nehezsegi_szint, COUNT(b.booking_id) AS foglalasok_szama FROM DIFFICULTY_LEVELS d JOIN EXPERIENCES e ON d.code=e.difficulty_level LEFT JOIN BOOKINGS b ON b.experience_id=e.experience_id GROUP BY d.code, d.description ORDER BY foglalasok_szama DESC, d.description;
-- Q17
SELECT r.room_name FROM ROOMS r WHERE r.room_id IN (SELECT e.room_id FROM EXPERIENCES e) ORDER BY r.room_name;
