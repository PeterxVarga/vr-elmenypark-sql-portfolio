-- Q09: Vendég–élmény–szoba–foglalás
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT g.first_name || ' ' || g.last_name AS vendeg_neve, e.experience_name, r.room_name, b.start_time FROM BOOKINGS b JOIN GUESTS g ON g.guest_id=b.guest_id JOIN EXPERIENCES e ON e.experience_id=b.experience_id JOIN ROOMS r ON r.room_id=b.room_id ORDER BY b.start_time DESC;
