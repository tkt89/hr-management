CREATE DATABASE employees;
use employees;

--@block
CREATE TABLE employees(
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(255),
    date_of_birth DATE,
    gender ENUM("male","female"),
    phone_number VARCHAR(20),
    email_address VARCHAR(255),
    home_address VARCHAR(255),
    department_id INT,
    date_joined DATE,
    role VARCHAR(50),
    location VARCHAR(255)
);

CREATE TABLE departments(
    department_id INT AUTO_INCREMENT PRIMARY KEY,
    department_name VARCHAR(50),
    number_of_members INT,
    department_manager_emp_id INT,
    department_manager_name VARCHAR(50),
    location VARCHAR(255),
    FOREIGN KEY(department_manager_emp_id) REFERENCES employees(employee_id)
);

CREATE TABLE salaries(
    salary_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    current_salary INT,
    previous_salary INT,
    commission INT,
    advance BOOLEAN DEFAULT FALSE,
    reason_for_advance TEXT,
    paid BOOLEAN,
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE attendance(
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    clock_in TIMESTAMP,
    clock_out TIMESTAMP,
    date DATE,
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE employment_history(
    emp_history_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id INT,
    company_name VARCHAR(255),
    role VARCHAR(50),
    date_joined DATE,
    date_left DATE,
    reason_for_exit TEXT,
    FOREIGN KEY(employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE recruits(
    recruit_id INT AUTO_INCREMENT PRIMARY KEY,
    recruit_name VARCHAR(255),
    date_of_birth DATE,
    gender ENUM("male","female"),
    phone_number VARCHAR(20),
    email_address VARCHAR(255),
    home_address VARCHAR(255),
    emp_history_id INT,
    recruiter_emp_id INT,
    application_date DATE,
    recruitment_status ENUM("pending", "hired","rejected","waitlisted"),
    FOREIGN KEY (emp_history_id) REFERENCES employment_history(emp_history_id),
    FOREIGN KEY (recruiter_emp_id) REFERENCES employees(employee_id)
);

--@block
ALTER TABLE employees
ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);

--@block
ALTER TABLE employees
DROP FOREIGN KEY employees_ibfk_1,
DROP FOREIGN KEY employees_ibfk_2;  

--@block
USE employees;

INSERT INTO departments (department_name, number_of_members, department_manager_emp_id, department_manager_name, location) VALUES
('Human Resources', 2, NULL, 'Alice Smith', 'Headquarters - 4th Floor'),
('Engineering', 3, NULL, 'Bob Jones', 'Tech Hub - 2nd Floor'),
('Sales', 2, NULL, 'Charlie Brown', 'Sales Office - 1st Floor');

INSERT INTO employees (employee_name, date_of_birth, gender, phone_number, email_address, home_address, department_id, date_joined, role, location) VALUES
('Alice Smith', '1985-04-12', 'female', '+1-555-0101', 'alice.smith@company.com', '123 Maple St, Springfield', 1, '2020-01-15', 'HR Director', 'Headquarters'),
('David Miller', '1992-08-23', 'male', '+1-555-0104', 'david.miller@company.com', '789 Pine Rd, Springfield', 1, '2022-06-01', 'Recruiter', 'Headquarters'),
('Bob Jones', '1988-11-03', 'male', '+1-555-0102', 'bob.jones@company.com', '456 Oak Ave, Metropolis', 2, '2019-03-10', 'Engineering Manager', 'Tech Hub'),
('Eva Green', '1995-01-19', 'female', '+1-555-0105', 'eva.green@company.com', '321 Birch Blvd, Metropolis', 2, '2023-02-15', 'Senior Frontend Engineer', 'Tech Hub'),
('Frank Wright', '1990-07-30', 'male', '+1-555-0106', 'frank.wright@company.com', '654 Cedar Ln, Metropolis', 2, '2021-11-01', 'Backend Engineer', 'Remote'),
('Charlie Brown', '1982-05-20', 'male', '+1-555-0103', 'charlie.brown@company.com', '789 Elm St, Gotham', 3, '2018-07-22', 'Sales VP', 'Sales Office'),
('Grace Team', '1994-12-05', 'female', '+1-555-0107', 'grace.team@company.com', '147 Walnut St, Gotham', 3, '2024-01-10', 'Sales Executive', 'Sales Office');

UPDATE departments SET department_manager_emp_id = 1 WHERE department_id = 1;
UPDATE departments SET department_manager_emp_id = 3 WHERE department_id = 2;
UPDATE departments SET department_manager_emp_id = 6 WHERE department_id = 3;

INSERT INTO salaries (employee_id, current_salary, previous_salary, commission, advance, reason_for_advance, paid) VALUES
(1, 95000, 90000, 0, FALSE, NULL, TRUE),
(2, 60000, 55000, 0, TRUE, 'Medical expense emergency', TRUE),
(3, 120000, 110000, 0, FALSE, NULL, TRUE),
(4, 85000, 80000, 0, FALSE, NULL, TRUE),
(5, 80000, 75000, 0, FALSE, NULL, FALSE),
(6, 100000, 95000, 15000, FALSE, NULL, TRUE),
(7, 55000, 50000, 8000, FALSE, NULL, TRUE);

INSERT INTO attendance (employee_id, clock_in, clock_out, date) VALUES
(1, '2026-06-01 08:55:00', '2026-06-01 17:05:00', '2026-06-01'),
(2, '2026-06-01 09:00:00', '2026-06-01 17:00:00', '2026-06-01'),
(3, '2026-06-01 08:30:00', '2026-06-01 16:30:00', '2026-06-01'),
(4, '2026-06-01 09:15:00', '2026-06-01 18:00:00', '2026-06-01'),
(5, '2026-06-01 08:45:00', '2026-06-01 17:15:00', '2026-06-01'),
(1, '2026-06-02 08:50:00', '2026-06-02 17:00:00', '2026-06-02'),
(2, '2026-06-02 09:05:00', '2026-06-02 17:00:00', '2026-06-02'),
(3, '2026-06-02 08:25:00', '2026-06-02 16:45:00', '2026-06-02'),
(4, '2026-06-02 08:55:00', '2026-06-02 17:05:00', '2026-06-02'),
(5, '2026-06-02 09:00:00', '2026-06-02 17:00:00', '2026-06-02');

INSERT INTO employment_history (employee_id, company_name, role, date_joined, date_left, reason_for_exit) VALUES
(3, 'Old Tech Corp', 'Senior Dev', '2015-01-10', '2019-02-28', 'Career growth'),
(4, 'Startup Inc', 'Junior Frontend', '2021-03-01', '2023-01-31', 'Company downsized'),
(NULL, 'Global Sales LLC', 'Sales Agent', '2022-01-15', '2025-12-20', 'Relocation');

INSERT INTO recruits (recruit_name, date_of_birth, gender, phone_number, email_address, home_address, emp_history_id, recruiter_emp_id, application_date, recruitment_status) VALUES
('Ian Wright', '1997-03-14', 'male', '+1-555-0999', 'ian.wright@external.com', '777 Blvd of Dreams, Metropolis', 3, 2, '2026-05-10', 'hired'),
('Julia Roberts', '1993-10-25', 'female', '+1-555-0888', 'julia.r@external.com', '888 Broadway, Gotham', NULL, 2, '2026-05-28', 'pending');


--@block
SELECT 
    e.employee_id,
    e.employee_name,
    e.role,
    d.department_name,
    m.employee_name AS manager_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN employees m ON d.department_manager_emp_id = m.employee_id;

SELECT 
    e.employee_name,
    d.department_name,
    s.current_salary,
    s.commission,
    (s.current_salary + IFNULL(s.commission, 0)) AS total_compensation,
    s.advance AS has_taken_advance,
    s.reason_for_advance
FROM employees e
JOIN salaries s ON e.employee_id = s.employee_id
JOIN departments d ON e.department_id = d.department_id;

SELECT 
    e.employee_name,
    a.date,
    a.clock_in,
    a.clock_out,
    ROUND(TIMESTAMPDIFF(MINUTE, a.clock_in, a.clock_out) / 60, 2) AS hours_worked
FROM attendance a
JOIN employees e ON a.employee_id = e.employee_id
ORDER BY a.date DESC, hours_worked DESC;

SELECT 
    r.recruit_name,
    r.application_date,
    r.recruitment_status,
    e.employee_name AS assigned_recruiter,
    eh.company_name AS applicant_previous_company
FROM recruits r
JOIN employees e ON r.recruiter_emp_id = e.employee_id
LEFT JOIN employment_history eh ON r.emp_history_id = eh.emp_history_id;

SELECT 
    d.department_name,
    COUNT(e.employee_id) AS active_employee_count,
    SUM(s.current_salary) AS total_department_base_budget,
    ROUND(AVG(s.current_salary), 2) AS average_salary,
    MAX(s.current_salary) AS maximum_salary
FROM departments d
LEFT JOIN employees e ON d.department_id = d.department_id
LEFT JOIN salaries s ON e.employee_id = s.employee_id
GROUP BY d.department_id, d.department_name;