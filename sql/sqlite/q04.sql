-- Q04: Kategóriánkénti átlagár
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT c.description AS kategoria, ROUND(AVG(e.price), 2) AS atlagos_ar FROM EXPERIENCES e JOIN EXPERIENCE_CATEGORIES c ON e.category = c.code GROUP BY c.code, c.description ORDER BY atlagos_ar DESC;
