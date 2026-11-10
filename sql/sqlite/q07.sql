-- Q07: Élmények nehézségi szinttel
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT e.experience_name, d.description AS nehezsegi_szint FROM EXPERIENCES e JOIN DIFFICULTY_LEVELS d ON e.difficulty_level = d.code ORDER BY CASE d.description WHEN 'Easy' THEN 1 WHEN 'Medium' THEN 2 WHEN 'Hard' THEN 3 ELSE 4 END, e.experience_name;
