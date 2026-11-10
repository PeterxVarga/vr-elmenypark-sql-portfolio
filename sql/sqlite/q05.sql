-- Q05: Vendégek októberi foglalásai
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, b.booking_date AS foglalas_datuma FROM GUESTS g JOIN BOOKINGS b ON b.guest_id = g.guest_id WHERE b.booking_date >= '2025-10-01' AND b.booking_date < '2025-11-01' ORDER BY b.booking_date, b.booking_id;
