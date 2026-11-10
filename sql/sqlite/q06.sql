-- Q06: Foglalások száma vendégenként
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, COUNT(b.booking_id) AS foglalasok_szama FROM GUESTS g LEFT JOIN BOOKINGS b ON b.guest_id = g.guest_id GROUP BY g.guest_id, g.first_name, g.last_name ORDER BY foglalasok_szama DESC, g.guest_id;
