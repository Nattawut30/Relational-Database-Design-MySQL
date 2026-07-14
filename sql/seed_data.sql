-- ========================================
-- HOSPITAL MANAGEMENT SYSTEM
-- LinkedIn: www.linkedin.com/in/nattawut-bn
-- GitHub: @Nattawut30
-- Email: nattawut.boonnoon@hotmail.com

USE hospital_management;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE departments;
TRUNCATE TABLE billing;
TRUNCATE TABLE admissions;
TRUNCATE TABLE beds;
TRUNCATE TABLE wards;
TRUNCATE TABLE prescriptions;
TRUNCATE TABLE medical_history;
TRUNCATE TABLE appointments;
TRUNCATE TABLE appointment_types;
TRUNCATE TABLE patients;
TRUNCATE TABLE staff;
TRUNCATE TABLE insurance_claims;
TRUNCATE TABLE insurance_providers;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO departments (department_name, building) VALUES
('General Medicine', 'Building A'), ('Cardiology', 'Building B'),
('Pediatrics', 'Building A'), ('Orthopedics', 'Building C'), ('Neurology', 'Building B');

INSERT INTO insurance_providers (provider_name, contact_phone, coverage_type) VALUES
('HealthCare Insurance Plc.', '02-111-2222', 'PPO'),
('Siam Medical Protect', '02-333-4444', 'HMO'),
('Inter Life Assurance', '02-555-6666', 'EPO');

INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 150)
SELECT CONCAT('Patient_', n), CONCAT('Test_', n), DATE_SUB(CURDATE(), INTERVAL (20 + (n % 60)) YEAR), IF(n % 2 = 0, 'Male', 'Female'), CONCAT('081-111-', LPAD(n, 4, '0')) FROM seq;

INSERT INTO staff (first_name, last_name, role, department_id, email, phone, hire_date, salary)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 20)
SELECT
    CONCAT('Doctor_', n),
    CONCAT('Smith_', n),
    IF(n % 4 = 0, 'Nurse', 'Doctor'),
    (1 + (n % 5)),
    CONCAT('staff', n, '@hospital-demo.local'),
    CONCAT('082-222-', LPAD(n, 4, '0')),
    DATE_SUB(CURDATE(), INTERVAL (n % 10) YEAR),
    (50000 + (n * 2000))
FROM seq;

INSERT INTO appointment_types (type_name, typical_duration_minutes, base_cost) VALUES
('General Checkup', 30, 500.00),
('Follow-up Visit', 15, 300.00),
('Specialist Consultation', 45, 1200.00),
('Emergency Visit', 60, 2500.00);

INSERT INTO appointments (patient_id, staff_id, department_id, appointment_type_id, appointment_date, appointment_time, status)
WITH RECURSIVE seq AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM seq WHERE n < 150)
SELECT
    (1 + (n % 150)),
    (1 + (n % 20)),
    (1 + (n % 5)),
    (1 + (n % 4)),
    DATE_ADD(CURDATE(), INTERVAL (n - 75) DAY),
    MAKETIME(8 + (n % 9), (n % 4) * 15, 0),
    CASE WHEN n % 7 = 0 THEN 'Cancelled' WHEN n % 3 = 0 THEN 'Completed' ELSE 'Scheduled' END
FROM seq;
