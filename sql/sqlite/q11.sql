-- Q11: Foglalások fizetési státusszal
-- Adapted from the 2026 university assignment, with corrections documented in docs/CHANGES.md.
SELECT b.booking_id, g.first_name || ' ' || g.last_name AS vendeg_neve, b.booking_date, p.amount_paid, s.description AS fizetes_statusza FROM BOOKINGS b JOIN PAYMENTS p ON p.booking_id=b.booking_id JOIN PAYMENT_STATUSES s ON s.code=p.payment_status JOIN GUESTS g ON g.guest_id=b.guest_id ORDER BY b.booking_date, b.booking_id, p.payment_id;
