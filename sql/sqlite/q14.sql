-- Q14: Vendég, élmény, nehézségi szint
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, e.experience_name, d.description AS nehezsegi_szint FROM BOOKINGS b JOIN GUESTS g ON b.guest_id=g.guest_id JOIN EXPERIENCES e ON e.experience_id=b.experience_id JOIN DIFFICULTY_LEVELS d ON d.code=e.difficulty_level ORDER BY g.last_name, g.first_name;
