-- Independently created fictitious data for a portable demo.
-- NOT the sample guest details printed in the original course PDF.
INSERT INTO BOOKING_STATUSES VALUES ('A','Aktív'),('C','Lemondott'),('F','Teljesített');
INSERT INTO DIFFICULTY_LEVELS VALUES ('E','Easy'),('M','Medium'),('H','Hard');
INSERT INTO EXPERIENCE_CATEGORIES VALUES ('A','Adventure'),('F','Family'),('H','Horror'),('S','Sci-fi');
INSERT INTO GENDERS VALUES ('F','Female'),('M','Male'),('O','Other');
INSERT INTO PAYMENT_METHODS VALUES ('B','Bankkártya'),('K','Készpénz'),('O','Online');
INSERT INTO PAYMENT_STATUSES VALUES ('C','Completed'),('F','Failed'),('P','Pending');
INSERT INTO GUESTS (guest_id,first_name,last_name,birth_date,email,phone_number,registration_date,address,gender) VALUES
(1,'Anna','Minta','1998-05-02','anna@example.test','+36000000001','2025-09-01','Fiktív utca 1','F'),
(2,'Béla','Teszt','1995-07-14','bela@example.test','+36000000002','2025-09-02','Fiktív utca 2','M'),
(3,'Csilla','Példa','2000-01-22','csilla@example.test','+36000000003','2025-09-03',NULL,'F'),
(4,'Dani','Próba','1992-11-03','dani@example.test','+36000000004','2025-09-04',NULL,'M'),
(5,'Emese','Demó','1997-03-19','emese@example.test','+36000000005','2025-09-05',NULL,'F'),
(6,'Fanni','NincsFoglalás','1999-03-19','fanni@example.test','+36000000006','2025-09-06',NULL,'F');
INSERT INTO ROOMS VALUES
(1,'Orion terem','A épület','available',6),(2,'Kísértet terem','B épület','available',4),
(3,'Óceán terem','C épület','available',5),(4,'Kaland terem','D épület','available',8),
(5,'Dínó terem','E épület','maintenance',7),(6,'Üres terem','F épület','available',3);
INSERT INTO EXPERIENCES VALUES
(1,1,7000,'Orion expedíció','S','M',45,12),
(2,2,9000,'Kísértetkastély','H','H',30,16),
(3,3,8000,'Óceán mélyén','A','E',60,12),
(4,4,6000,'Lovagi küldetés','F','M',90,12),
(5,5,8500,'Dínóösvény','A','H',120,18),
(6,4,3500,'Mini labirintus','F','E',15,6),
(7,1,5000,'Orion tréning','S','E',30,6);
INSERT INTO BOOKINGS (booking_id,guest_id,experience_id,room_id,booking_date,start_time,end_time,status) VALUES
(1,1,1,1,'2025-10-01 10:00','2025-10-03 15:00','2025-10-03 15:45','F'),
(2,2,2,2,'2025-10-02 10:00','2025-10-10 12:00','2025-10-10 12:30','A'),
(3,3,3,3,'2025-10-02 10:00','2025-10-11 12:00','2025-10-11 13:00','F'),
(4,1,4,4,'2025-10-03 10:00','2025-10-12 14:00','2025-10-12 15:30','C'),
(5,4,5,5,'2025-10-03 10:00','2025-10-13 14:00','2025-10-13 16:00','F'),
(6,5,6,4,'2025-10-05 10:00','2025-10-15 16:00','2025-10-15 16:15','A'),
(7,2,1,1,'2025-10-25 10:00','2025-11-01 14:00','2025-11-01 14:45','F'),
(8,3,6,4,'2025-10-25 10:00','2025-11-02 14:00','2025-11-02 14:15','F');
INSERT INTO BOOKING_PARTICIPANTS VALUES
(1,1,1,NULL,NULL,'1998-05-02'),(2,1,NULL,'Kata','Fiktív','1994-03-15'),
(3,2,2,NULL,NULL,'1995-07-14'),(4,3,3,NULL,NULL,'2000-01-22'),
(5,4,1,NULL,NULL,'1998-05-02'),(6,5,4,NULL,NULL,'1992-11-03'),
(7,6,5,NULL,NULL,'1997-03-19'),(8,7,2,NULL,NULL,'1995-07-14'),
(9,8,3,NULL,NULL,'2000-01-22');
INSERT INTO PAYMENTS (payment_id,booking_id,payment_method,amount_paid,payment_date,payment_status) VALUES
(1,1,'B',7000,'2025-10-03 15:00','C'),
(2,2,'K',9000,'2025-10-10 12:00','P'),
(3,3,'O',8000,'2025-10-11 12:00','C'),
(4,4,'O',6000,'2025-10-12 14:00','F'),
(5,5,'B',8500,'2025-10-13 14:00','C'),
(6,6,'K',3500,'2025-10-15 16:00','P'),
(7,7,'B',7000,'2025-11-01 14:00','C'),
(8,8,'O',3500,'2025-11-02 14:00','C'),
(9,1,'B',2000,'2025-10-03 15:30','C');
INSERT INTO REVIEWS (review_id,guest_id,experience_id,rating,text_review,review_date) VALUES
(1,1,1,5,'Szintetikus értékelés','2025-10-04'),
(2,2,2,4,'Szintetikus értékelés','2025-10-11'),
(3,3,3,5,'Szintetikus értékelés','2025-10-12'),
(4,4,5,3,'Szintetikus értékelés','2025-10-14'),
(5,5,6,4,'Szintetikus értékelés','2025-10-16');
