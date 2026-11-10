-- Q17: Legalább egy élménnyel rendelkező szobák
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT r.room_name FROM ROOMS r WHERE r.room_id IN (SELECT e.room_id FROM EXPERIENCES e) ORDER BY r.room_name;
