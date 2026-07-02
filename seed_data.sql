USE hospital_db;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE insurance_claim;
TRUNCATE TABLE billing;
TRUNCATE TABLE admissions;
TRUNCATE TABLE beds;
TRUNCATE TABLE wards;
TRUNCATE TABLE prescriptions;
TRUNCATE TABLE medical_history;
TRUNCATE TABLE appointments;
TRUNCATE TABLE patients;
TRUNCATE TABLE staff;
TRUNCATE TABLE insurance_providers;
TRUNCATE TABLE departments;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO departments (department_name, building) VALUES
('General Medicine', 'Building A'), ('Cardiology', 'Building B'), 
('Pediatrics', 'Building A'), ('Orthopedics', 'Building C'), ('Neurology', 'Building B');

INSERT INTO insurance_providers (provider_name, contact_number) VALUES
('HealthCare Insurance Plc.', '02-111-2222'), ('Siam Medical Protect', '02-333-4444'), ('Inter Life Assurance', '02-555-6666');

INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone_number)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 150)
SELECT CONCAT('Patient_', n), CONCAT('Test_', n), DATE_SUB(CURDATE(), INTERVAL (20 + (n % 60)) YEAR), IF(n % 2 = 0, 'Male', 'Female'), CONCAT('081-111-', LPAD(n, 4, '0')) FROM seq;

INSERT INTO staff (first_name, last_name, role, department_id, salary)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 20)
SELECT CONCAT('Doctor_', n), CONCAT('Smith_', n), IF(n % 4 = 0, 'Surgeon', 'Physician'), (1 + (n % 5)), (50000 + (n * 2000)) FROM seq;

INSERT INTO appointments (patient_id, staff_id, appointment_date, status)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 150)
SELECT (1 + (n % 150)), (1 + (n % 20)), DATE_ADD(CURDATE(), INTERVAL (n - 75) DAY), CASE WHEN n % 7 = 0 THEN 'Cancelled' WHEN n % 3 = 0 THEN 'Completed' ELSE 'Scheduled' END FROM seq;
