-- Q13: Kategóriák sikeres befizetései
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT c.description AS kategoria, SUM(p.amount_paid) AS sikeres_befizetes_osszesen FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON c.code=e.category JOIN BOOKINGS b ON b.experience_id=e.experience_id JOIN PAYMENTS p ON p.booking_id=b.booking_id WHERE p.payment_status='C' GROUP BY c.code, c.description ORDER BY sikeres_befizetes_osszesen DESC;
