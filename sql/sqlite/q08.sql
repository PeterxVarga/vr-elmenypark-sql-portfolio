-- Q08: Szobák befogadóképessége
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT r.room_name, r.capacity AS max_befogadokepesseg FROM ROOMS r WHERE EXISTS(SELECT 1 FROM EXPERIENCES e WHERE e.room_id = r.room_id) ORDER BY r.capacity DESC, r.room_name;
