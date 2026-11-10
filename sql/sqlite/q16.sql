-- Q16: Foglalások nehézségi szintenként
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT d.description AS nehezsegi_szint, COUNT(b.booking_id) AS foglalasok_szama FROM DIFFICULTY_LEVELS d JOIN EXPERIENCES e ON d.code=e.difficulty_level LEFT JOIN BOOKINGS b ON b.experience_id=e.experience_id GROUP BY d.code, d.description ORDER BY foglalasok_szama DESC, d.description;
