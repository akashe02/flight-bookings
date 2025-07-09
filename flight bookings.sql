--- create database flights 
CREATE DATABASE FLIGHTS;
USE FLIGHTS;
CREATE TABLE Flights (
  flight_id INT PRIMARY KEY AUTO_INCREMENT,
  flight_number VARCHAR(10) UNIQUE,
  origin VARCHAR(50),
  destination VARCHAR(50),
  departure_time DATETIME,
  arrival_time DATETIME,
  total_seats INT
);
CREATE TABLE Customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(15)
);
CREATE TABLE Bookings (
  booking_id INT PRIMARY KEY AUTO_INCREMENT,
  customer_id INT,
  flight_id INT,
  seat_number VARCHAR(5),
  booking_date DATE,
  status ENUM('Confirmed', 'Cancelled') DEFAULT 'Confirmed',
  FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
CREATE TABLE Seats (
  seat_id INT PRIMARY KEY AUTO_INCREMENT,
  flight_id INT,
  seat_number VARCHAR(5),
  is_booked BOOLEAN DEFAULT FALSE,
  FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);
--- INSERT DATA INTO flights table
INSERT INTO Flights (flight_number, origin, destination, departure_time, arrival_time, total_seats) VALUES
('AI101', 'Delhi', 'Mumbai', '2025-07-05 10:00:00', '2025-07-05 12:00:00', 180),
('AI102', 'Mumbai', 'Chennai', '2025-07-06 14:00:00', '2025-07-06 16:00:00', 150),
('AI103', 'Bangalore', 'Hyderabad', '2025-07-07 09:00:00', '2025-07-07 10:15:00', 200),
('AI104', 'Kolkata', 'Delhi', '2025-07-08 07:30:00', '2025-07-08 09:45:00', 170),
('AI105', 'Delhi', 'Chennai', '2025-07-09 13:00:00', '2025-07-09 15:30:00', 160),
('AI106', 'Mumbai', 'Bangalore', '2025-07-10 06:00:00', '2025-07-10 08:00:00', 180),
('AI107', 'Hyderabad', 'Mumbai', '2025-07-11 19:00:00', '2025-07-11 21:00:00', 190),
('AI108', 'Chennai', 'Kolkata', '2025-07-12 15:00:00', '2025-07-12 17:30:00', 170),
('AI109', 'Delhi', 'Hyderabad', '2025-07-13 11:00:00', '2025-07-13 13:00:00', 150),
('AI110', 'Mumbai', 'Delhi', '2025-07-14 16:30:00', '2025-07-14 18:45:00', 200);
---- INSERT DATA INTO customer table
INSERT INTO Customers (name, email, phone) VALUES
('Rahul Verma', 'rahul@example.com', '9876543210'),
('Asha Singh', 'asha@example.com', '9123456780'),
('Kiran Rao', 'kiran@example.com', '9988776655'),
('Vikram Das', 'vikram@example.com', '9665544332'),
('Meena Kumari', 'meena@example.com', '9012345678'),
('Sanjay Patel', 'sanjay@example.com', '9090909090'),
('Anjali Mehta', 'anjali@example.com', '9777766666'),
('Rohit Sharma', 'rohit@example.com', '9888877777'),
('Sneha Joshi', 'sneha@example.com', '9654321987'),
('Ajay Kumar', 'ajay@example.com', '9345678123');
---- INSERT DATA INTO bookings table
INSERT INTO Bookings (customer_id, flight_id, seat_number, booking_date, status) VALUES
(1, 1, '12A', '2025-07-01', 'Confirmed'),
(2, 2, '15B', '2025-07-01', 'Confirmed'),
(3, 3, '10C', '2025-07-01', 'Confirmed'),
(4, 4, '1A', '2025-07-02', 'Cancelled'),
(5, 5, '22F', '2025-07-02', 'Confirmed'),
(6, 6, '5B', '2025-07-02', 'Confirmed'),
(7, 7, '3A', '2025-07-03', 'Confirmed'),
(8, 8, '14D', '2025-07-03', 'Cancelled'),
(9, 9, '17C', '2025-07-03', 'Confirmed'),
(10, 10, '20A', '2025-07-03', 'Confirmed');
---- INSERT DATA INTO seats table
INSERT INTO Seats (flight_id, seat_number, is_booked) VALUES
(1, '12A', TRUE),
(2, '15B', TRUE),
(3, '10C', TRUE),
(4, '1A', FALSE),
(5, '22F', TRUE),
(6, '5B', TRUE),
(7, '3A', TRUE),
(8, '14D', FALSE),
(9, '17C', TRUE),
(10, '20A', TRUE);
--- Find available seats for a flight
SELECT total_seats - COUNT(*) AS available_seats
FROM Flights f
JOIN Bookings b ON f.flight_id = b.flight_id
WHERE f.flight_id = 1 AND b.status = 'Confirmed';
---- Search flights from chennai to delhi
SELECT * FROM Flights
WHERE origin = 'Chennai' AND destination = 'kolkata';
---- List all bookings for a customer
SELECT b.*, f.flight_number, f.origin, f.destination
FROM Bookings b
JOIN Flights f ON b.flight_id = f.flight_id
WHERE b.customer_id = 1;
---- Trigger to update seat as booked after booking
CREATE TRIGGER after_booking_insert
AFTER INSERT ON Bookings
FOR EACH ROW
UPDATE Seats
SET is_booked = TRUE
WHERE flight_id = NEW.flight_id AND seat_number = NEW.seat_number;
---- Trigger to release seat on cancellation
DELIMITER $$

CREATE TRIGGER after_booking_cancel
AFTER UPDATE ON Bookings
FOR EACH ROW
BEGIN
  IF NEW.status = 'Cancelled' THEN
    UPDATE Seats
    SET is_booked = FALSE
    WHERE flight_id = NEW.flight_id AND seat_number = NEW.seat_number;
  END IF;
END$$

DELIMITER ;
-- - Total bookings per flight
SELECT f.flight_number, COUNT(b.booking_id) AS total_bookings
FROM Flights f
LEFT JOIN Bookings b ON f.flight_id = b.flight_id
GROUP BY f.flight_number;
--- Booking status breakdown
SELECT status, COUNT(*) AS count
FROM Bookings
GROUP BY status;
--- view 
CREATE VIEW BookingSummary AS
SELECT b.booking_id, c.name, f.flight_number, f.origin, f.destination, b.status
FROM Bookings b
JOIN Customers c ON b.customer_id = c.customer_id
JOIN Flights f ON b.flight_id = f.flight_id;









