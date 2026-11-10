-- Q18: Vendég sikeres befizetései – a tárolt eljárás SQLite-megfelelője
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, COALESCE(SUM(CASE WHEN p.payment_status = 'C' THEN p.amount_paid ELSE 0 END), 0) AS osszes_sikeres_befizetes FROM GUESTS g LEFT JOIN BOOKINGS b ON b.guest_id=g.guest_id LEFT JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE g.guest_id=:guest_id GROUP BY g.guest_id, g.first_name, g.last_name;
