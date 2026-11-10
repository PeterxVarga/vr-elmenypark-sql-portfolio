-- Portfolio demo adaptation of the original SQL Server schema.
-- Target: SQLite 3 (stdlib). NOT a verbatim copy of the original DDL.
-- Currency amounts are expressed in the original assignment's price units.
PRAGMA foreign_keys = ON;
CREATE TABLE BOOKING_STATUSES (code TEXT PRIMARY KEY, description TEXT NOT NULL);
CREATE TABLE DIFFICULTY_LEVELS (code TEXT PRIMARY KEY, description TEXT NOT NULL);
CREATE TABLE EXPERIENCE_CATEGORIES (code TEXT PRIMARY KEY, description TEXT NOT NULL);
CREATE TABLE GENDERS (code TEXT PRIMARY KEY, description TEXT NOT NULL);
CREATE TABLE PAYMENT_METHODS (code TEXT PRIMARY KEY, description TEXT NOT NULL);
CREATE TABLE PAYMENT_STATUSES (code TEXT PRIMARY KEY, description TEXT NOT NULL);

CREATE TABLE GUESTS (
 guest_id INTEGER PRIMARY KEY,
 first_name TEXT NOT NULL, last_name TEXT NOT NULL,
 birth_date TEXT NOT NULL, email TEXT NOT NULL UNIQUE,
 phone_number TEXT NOT NULL, registration_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 address TEXT, gender TEXT REFERENCES GENDERS(code),
 CHECK (instr(email, '@') > 1)
);
CREATE TABLE ROOMS (
 room_id INTEGER PRIMARY KEY, room_name TEXT NOT NULL UNIQUE,
 location TEXT NOT NULL, availability_status TEXT NOT NULL DEFAULT 'available',
 capacity INTEGER NOT NULL CHECK(capacity BETWEEN 1 AND 20),
 CHECK(availability_status IN('available','occupied','maintenance','out of order'))
);
CREATE TABLE EXPERIENCES (
 experience_id INTEGER PRIMARY KEY,
 room_id INTEGER NOT NULL REFERENCES ROOMS(room_id),
 price NUMERIC NOT NULL CHECK(price >= 0),
 experience_name TEXT NOT NULL UNIQUE,
 category TEXT NOT NULL REFERENCES EXPERIENCE_CATEGORIES(code),
 difficulty_level TEXT NOT NULL REFERENCES DIFFICULTY_LEVELS(code),
 duration_minutes INTEGER NOT NULL CHECK(duration_minutes IN (15,30,45,60,90,120)),
 age_limit INTEGER NOT NULL CHECK(age_limit IN (3,6,12,14,16,18)),
 CHECK(NOT(category = 'F' AND difficulty_level = 'H'))
);
CREATE TABLE BOOKINGS (
 booking_id INTEGER PRIMARY KEY,
 guest_id INTEGER NOT NULL REFERENCES GUESTS(guest_id),
 experience_id INTEGER NOT NULL REFERENCES EXPERIENCES(experience_id),
 room_id INTEGER NOT NULL REFERENCES ROOMS(room_id),
 booking_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 start_time TEXT NOT NULL,
 end_time TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'A' REFERENCES BOOKING_STATUSES(code),
 CHECK(start_time > booking_date), CHECK(end_time > start_time)
);
CREATE TABLE BOOKING_PARTICIPANTS (
 participant_id INTEGER PRIMARY KEY,
 booking_id INTEGER NOT NULL REFERENCES BOOKINGS(booking_id),
 guest_id INTEGER REFERENCES GUESTS(guest_id),
 first_name TEXT, last_name TEXT, birth_date TEXT NOT NULL,
 CHECK(guest_id IS NOT NULL OR (first_name IS NOT NULL AND last_name IS NOT NULL))
);
CREATE TABLE PAYMENTS (
 payment_id INTEGER PRIMARY KEY,
 booking_id INTEGER NOT NULL REFERENCES BOOKINGS(booking_id),
 payment_method TEXT NOT NULL REFERENCES PAYMENT_METHODS(code),
 amount_paid NUMERIC NOT NULL CHECK(amount_paid >= 0),
 payment_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 payment_status TEXT NOT NULL REFERENCES PAYMENT_STATUSES(code)
);
CREATE TABLE REVIEWS (
 review_id INTEGER PRIMARY KEY,
 guest_id INTEGER NOT NULL REFERENCES GUESTS(guest_id),
 experience_id INTEGER NOT NULL REFERENCES EXPERIENCES(experience_id),
 rating INTEGER NOT NULL CHECK(rating BETWEEN 1 AND 5),
 text_review TEXT, review_date TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_bookings_guest ON BOOKINGS(guest_id);
CREATE INDEX idx_bookings_experience ON BOOKINGS(experience_id);
CREATE INDEX idx_payments_booking ON PAYMENTS(booking_id);
CREATE INDEX idx_reviews_experience ON REVIEWS(experience_id);
