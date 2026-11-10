-- Q10: Legtöbbet befizető vendég – csak sikeres fizetések
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, SUM(p.amount_paid) AS osszes_sikeres_befizetes FROM GUESTS g JOIN BOOKINGS b ON b.guest_id=g.guest_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY g.guest_id, g.first_name, g.last_name ORDER BY osszes_sikeres_befizetes DESC, g.guest_id LIMIT 1;
