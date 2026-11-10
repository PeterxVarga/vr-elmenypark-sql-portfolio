-- Q15: Szobánkénti sikeres befizetések
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT r.room_name, SUM(p.amount_paid) AS sikeres_befizetes_osszesen FROM ROOMS r JOIN BOOKINGS b ON b.room_id=r.room_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY r.room_id, r.room_name ORDER BY sikeres_befizetes_osszesen DESC, r.room_name;
