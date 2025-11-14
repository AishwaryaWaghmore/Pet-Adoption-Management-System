-- ============================================================
--   PET ADOPTION MANAGEMENT DATABASE
--   Full SQL File (DDL + DML + TRIGGERS + FUNCTIONS + PROCEDURES)
--   Author: Aishwarya & Deepika
--   Course: UE23CS351A - DBMS
-- ============================================================

-- ------------------------------------------------------------
-- 1️⃣ CREATE DATABASE
-- ------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS petadoptiondb;
USE petadoptiondb;

-- ------------------------------------------------------------
-- 2️⃣ TABLES (DDL)
-- ------------------------------------------------------------

-- Shelter Table
CREATE TABLE Shelter (
    shelter_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(150),
    contact_no VARCHAR(15) UNIQUE
);

-- Employee Table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    role VARCHAR(50),
    supervisor_id INT,
    FOREIGN KEY (supervisor_id) REFERENCES Employee(emp_id)
);

-- Adopter Table
CREATE TABLE Adopter (
    adopter_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    address VARCHAR(150)
);

-- Animal Table
CREATE TABLE Animal (
    animal_id INT PRIMARY KEY,
    name VARCHAR(100),
    species VARCHAR(50) NOT NULL,
    breed VARCHAR(50),
    gender ENUM('Male','Female') NOT NULL,
    dob DATE,
    status ENUM('Available','Adopted') DEFAULT 'Available',
    shelter_id INT,
    FOREIGN KEY (shelter_id) REFERENCES Shelter(shelter_id) ON DELETE CASCADE
);

-- Adoption Table
CREATE TABLE Adoption (
    adoption_id INT PRIMARY KEY,
    adoption_date DATE NOT NULL,
    fee DECIMAL(10,2),
    adopter_id INT,
    animal_id INT,
    FOREIGN KEY (adopter_id) REFERENCES Adopter(adopter_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
);

-- Adoption Log (for Trigger)
CREATE TABLE Adoption_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    animal_id INT,
    adopter_id INT,
    adoption_date DATE,
    message VARCHAR(200)
);

-- Donation Table
CREATE TABLE Donation (
    donation_id INT PRIMARY KEY,
    donor_name VARCHAR(100),
    amount DECIMAL(10,2),
    date DATE,
    shelter_id INT,
    FOREIGN KEY (shelter_id) REFERENCES Shelter(shelter_id)
);

-- Veterinarian Table
CREATE TABLE Veterinarian (
    vet_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    specialization VARCHAR(100)
);

-- VetClinic Table
CREATE TABLE VetClinic (
    clinic_id INT PRIMARY KEY,
    name VARCHAR(100),
    address VARCHAR(150),
    phone VARCHAR(15)
);

-- VetVisit Table (M:N relationship)
CREATE TABLE VetVisit (
    visit_id INT AUTO_INCREMENT,
    date DATE,
    diagnosis VARCHAR(200),
    treatment VARCHAR(200),
    animal_id INT,
    vet_id INT,
    clinic_id INT,
    PRIMARY KEY (visit_id, animal_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id),
    FOREIGN KEY (vet_id) REFERENCES Veterinarian(vet_id),
    FOREIGN KEY (clinic_id) REFERENCES VetClinic(clinic_id)
);

-- MedicalRecord Table (Weak Entity)
CREATE TABLE MedicalRecord (
    record_id INT AUTO_INCREMENT,
    allergies VARCHAR(200),
    vaccination_status VARCHAR(100),
    animal_id INT,
    PRIMARY KEY (record_id, animal_id),
    FOREIGN KEY (animal_id) REFERENCES Animal(animal_id)
);

-- ------------------------------------------------------------
-- 3️⃣ INSERT SAMPLE DATA (DML)
-- ------------------------------------------------------------

-- Shelter Data
INSERT INTO Shelter VALUES
(1, 'Happy Paws Shelter', 'Bangalore', '9876543210'),
(2, 'Safe Haven Shelter', 'Mysore', '9123456780');

-- Employee Data
INSERT INTO Employee VALUES
(101, 'Ramesh', '9876500011', 'Manager', NULL),
(102, 'Sita', '9876500012', 'Assistant', 101),
(103, 'Kiran', '9876500013', 'Volunteer', 101),
(104, 'Meena', '9876500014', 'Care Taker', 102);

-- Adopter Data
INSERT INTO Adopter VALUES
(201, 'Aishwarya', '9998887770', 'aishu@gmail.com', 'JP Nagar, Bangalore'),
(202, 'Ravi Kumar', '8887776665', 'ravi.k@gmail.com', 'Indiranagar, Bangalore'),
(203, 'Sneha', '7776665554', 'sneha@gmail.com', 'Mysore'),
(204, 'Arun', '6665554443', 'arun@gmail.com', 'BTM Layout, Bangalore');

-- Animal Data
INSERT INTO Animal VALUES
(301, 'Bruno', 'Dog', 'Labrador', 'Male', '2020-05-12', 'Available', 1),
(302, 'Kitty', 'Cat', 'Persian', 'Female', '2021-03-08', 'Adopted', 1),
(303, 'Rocky', 'Dog', 'Beagle', 'Male', '2019-11-20', 'Available', 2),
(304, 'Milo', 'Cat', 'Siamese', 'Male', '2021-09-15', 'Available', 2),
(305, 'Lucy', 'Dog', 'Pug', 'Female', '2022-01-12', 'Adopted', 1);

-- Adoption Data
INSERT INTO Adoption VALUES
(401, '2023-08-15', 2500, 201, 302),
(402, '2024-01-20', 3000, 202, 305);

-- Donation Data
INSERT INTO Donation VALUES
(501, 'Mr. Sharma', 5000, '2024-02-10', 1),
(502, 'Green NGO', 10000, '2024-05-12', 2),
(503, 'Anita Rao', 2000, '2025-01-05', 1);

-- Veterinarian Data
INSERT INTO Veterinarian VALUES
(601, 'Dr. Meera', '7776665554', 'Small Animals'),
(602, 'Dr. Arjun', '9991112223', 'Exotic Pets'),
(603, 'Dr. Neha', '8882223334', 'Surgery');

-- VetClinic Data
INSERT INTO VetClinic VALUES
(701, 'PetCare Clinic', 'BTM Layout, Bangalore', '7022334455'),
(702, 'HappyVet Clinic', 'Hebbal, Bangalore', '7011223344');

-- VetVisit Data
INSERT INTO VetVisit (date, diagnosis, treatment, animal_id, vet_id, clinic_id) VALUES
('2024-01-10', 'Vaccination', 'Rabies Shot', 301, 601, 701),
('2024-02-20', 'General Checkup', 'Routine Exam', 303, 602, 702),
('2024-03-05', 'Skin Allergy', 'Ointment', 304, 601, 701),
('2024-04-12', 'Injury', 'Bandage & Antibiotics', 305, 603, 702);

-- MedicalRecord Data
INSERT INTO MedicalRecord (allergies, vaccination_status, animal_id) VALUES
('None', 'Completed', 301),
('Dust', 'Completed', 302),
('Pollen', 'Pending', 303),
('None', 'Completed', 304),
('Food Allergy', 'Completed', 305);

-- ------------------------------------------------------------
-- 4️⃣ TRIGGER
-- ------------------------------------------------------------

DELIMITER //
CREATE TRIGGER log_adoption
AFTER INSERT ON Adoption
FOR EACH ROW
BEGIN
    INSERT INTO Adoption_Log (animal_id, adopter_id, adoption_date, message)
    VALUES (NEW.animal_id, NEW.adopter_id, NEW.adoption_date,
            CONCAT('Animal ', NEW.animal_id, ' adopted by ', NEW.adopter_id));
END //
DELIMITER ;

-- ------------------------------------------------------------
-- 5️⃣ FUNCTION
-- ------------------------------------------------------------

DELIMITER //
CREATE FUNCTION total_donations(s_id INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT SUM(amount) INTO total FROM Donation WHERE shelter_id = s_id;
    RETURN total;
END //
DELIMITER ;

-- ------------------------------------------------------------
-- 6️⃣ STORED PROCEDURE
-- ------------------------------------------------------------

DELIMITER //
CREATE PROCEDURE adopt_pet(
    IN p_adoption_id INT,
    IN p_adopter_id INT,
    IN p_animal_id INT
)
BEGIN
    UPDATE Animal SET status='Adopted' WHERE animal_id = p_animal_id;

    INSERT INTO Adoption (adoption_id, adoption_date, adopter_id, animal_id, fee)
    VALUES (p_adoption_id, CURDATE(), p_adopter_id, p_animal_id, 2000);
END //
DELIMITER ;

-- ------------------------------------------------------------
-- 7️⃣ USEFUL QUERIES
-- ------------------------------------------------------------

-- View all animals
SELECT * FROM Animal;

-- Available animals only
SELECT * FROM Animal WHERE status='Available';

-- Animals with their shelters
SELECT Animal.name, species, Shelter.name AS ShelterName
FROM Animal
JOIN Shelter ON Animal.shelter_id = Shelter.shelter_id;

-- Adopter and adoption details
SELECT A.name AS AdopterName, An.name AS AnimalName, Ad.adoption_date
FROM Adoption Ad
JOIN Adopter A ON Ad.adopter_id = A.adopter_id
JOIN Animal An ON Ad.animal_id = An.animal_id;

-- Nested query (Animals older than avg age)
SELECT name, species FROM Animal
WHERE dob < (SELECT AVG(dob) FROM Animal);

-- Total donation for each shelter
SELECT Shelter.name, total_donations(Shelter.shelter_id) AS Total_Donation
FROM Shelter;

-- End of SQL File
-- ============================================================
