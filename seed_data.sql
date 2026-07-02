-- =================================================================
-- HOSPITAL MANAGEMENT SYSTEM - SEED DATA SCRIPT
-- =================================================================

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE insurance_claims;
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
('General Medicine', 'Building A'),
('Cardiology', 'Building B'),
('Pediatrics', 'Building A'),
('Orthopedics', 'Building C'),
('Neurology', 'Building B');

INSERT INTO insurance_providers (provider_name, contact_number) VALUES
('HealthCare Insurance Plc.', '02-111-2222'),
('Siam Medical Protect', '02-333-4444'),
('Inter Life Assurance', '02-555-6666');


INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone_number)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 150
)
SELECT 
    CONCAT('Patient_', n) AS first_name,
    CONCAT('Test_', n) AS last_name,
    DATE_SUB(CURDATE(), INTERVAL (20 + (n % 60)) YEAR) AS date_of_birth,
    IF(n % 2 = 0, 'Male', 'Female') AS gender,
    CONCAT('081-111-', LPAD(n, 4, '0')) AS phone_number
FROM seq;


INSERT INTO staff (first_name, last_name, role, department_id, salary)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 20
)
SELECT 
    CONCAT('Doctor_', n) AS first_name,
    CONCAT('Smith_', n) AS last_name,
    IF(n % 4 = 0, 'Surgeon', 'Physician') AS role,
    (1 + (n % 5)) AS department_id, -- กระจายไป 5 แผนกด้วย Modulo
    (50000 + (n * 2000)) AS salary
FROM seq;


INSERT INTO appointments (patient_id, staff_id, appointment_date, status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 300
)
SELECT 
    (1 + (n % 150)) AS patient_id, -- กระจายผู้ป่วย 150 คน
    (1 + (n % 20)) AS staff_id,    -- กระจายหมอ 20 คน
    DATE_ADD(CURDATE(), INTERVAL (n - 150) DAY) AS appointment_date, -- มีทั้งอดีตและอนาคต
    CASE 
        WHEN n % 5 = 0 THEN 'Cancelled'
        WHEN DATE_ADD(CURDATE(), INTERVAL (n - 150) DAY) < CURDATE() THEN 'Completed'
        ELSE 'Scheduled'
    END AS status
FROM seq;

INSERT INTO wards (ward_name, capacity) VALUES
('ICU', 5), ('General Ward A', 20), ('Pediatric Ward', 10);

INSERT INTO beds (ward_id, bed_number, is_occupied)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 35
)
SELECT 
    CASE WHEN n <= 5 THEN 1 WHEN n <= 25 THEN 2 ELSE 3 END AS ward_id,
    CONCAT('B-', n) AS bed_number,
    FALSE AS is_occupied
FROM seq;
