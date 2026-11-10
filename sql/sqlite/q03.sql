-- Q03: Élmény és kategória
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT e.experience_name, c.description AS kategoria FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON e.category = c.code ORDER BY c.description, e.experience_name;
