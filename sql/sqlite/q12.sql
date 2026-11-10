-- Q12: Élmények foglalásszáma
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT e.experience_name, c.description AS kategoria, COUNT(b.booking_id) AS foglalasok_szama FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON c.code=e.category LEFT JOIN BOOKINGS b ON b.experience_id=e.experience_id GROUP BY e.experience_id, e.experience_name, c.description ORDER BY foglalasok_szama DESC, e.experience_name;
