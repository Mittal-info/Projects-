-- =====================================================
--  COLLEGE MANAGEMENT SYSTEM  (MySQL Command Line)
--  Run: mysql -u root -p  ->  source college_management.sql;
-- =====================================================

-- ---------- 1. DATABASE ----------
CREATE DATABASE IF NOT EXISTS college_db;
USE college_db;

-- ---------- 2. TABLES ----------
CREATE TABLE departments (
    dept_id   INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE faculty (
    faculty_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(60) NOT NULL,
    email      VARCHAR(80) UNIQUE,
    phone      VARCHAR(15),
    dept_id    INT,
    salary     DECIMAL(10,2),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE courses (
    course_id   INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(60) NOT NULL,
    credits     INT NOT NULL,
    dept_id     INT,
    faculty_id  INT,
    FOREIGN KEY (dept_id)    REFERENCES departments(dept_id),
    FOREIGN KEY (faculty_id) REFERENCES faculty(faculty_id)
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    name       VARCHAR(60) NOT NULL,
    email      VARCHAR(80) UNIQUE,
    phone      VARCHAR(15),
    gender     ENUM('Male','Female','Other'),
    dob        DATE,
    city       VARCHAR(40),
    dept_id    INT,
    admit_date DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE enrollments (
    enroll_id  INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id  INT NOT NULL,
    marks      INT,
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);

CREATE TABLE fees (
    fee_id     INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    amount     DECIMAL(10,2) NOT NULL,
    paid_on    DATE,
    status     ENUM('Paid','Pending') DEFAULT 'Pending',
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

-- ---------- 3. INSERT DATA ----------
INSERT INTO departments (dept_name) VALUES
    ('Computer Science'), ('Information Technology'), ('Commerce'), ('Mathematics');

INSERT INTO faculty (name, email, phone, dept_id, salary) VALUES
    ('Dr. Meera Shah',  'meera@college.edu',  '9876500001', 1, 65000),
    ('Prof. Amit Patel','amit@college.edu',   '9876500002', 1, 55000),
    ('Prof. Neha Joshi','neha@college.edu',   '9876500003', 2, 52000),
    ('Dr. Rakesh Mehta','rakesh@college.edu', '9876500004', 3, 60000),
    ('Prof. Kiran Desai','kiran@college.edu', '9876500005', 4, 50000);

INSERT INTO courses (course_name, credits, dept_id, faculty_id) VALUES
    ('Database Management', 4, 1, 1),
    ('C Programming',       3, 1, 2),
    ('Web Technologies',    4, 2, 3),
    ('Accounting',          3, 3, 4),
    ('Discrete Maths',      3, 4, 5);

INSERT INTO students (name, email, phone, gender, dob, city, dept_id, admit_date) VALUES
    ('Riya Sharma',  'riya@mail.com',   '9000000001', 'Female', '2004-03-12', 'Ahmedabad', 1, '2024-06-20'),
    ('Mittal Rabari','mittal@mail.com', '9000000002', 'Female', '2004-07-25', 'Ahmedabad', 1, '2024-06-20'),
    ('Jay Patel',    'jay@mail.com',    '9000000003', 'Male',   '2003-11-02', 'Surat',     2, '2024-06-21'),
    ('Kavya Mehta',  'kavya@mail.com',  '9000000004', 'Female', '2004-01-15', 'Vadodara',  3, '2024-06-22'),
    ('Dhruv Shah',   'dhruv@mail.com',  '9000000005', 'Male',   '2004-09-30', 'Rajkot',    4, '2024-06-22'),
    ('Pooja Desai',  'pooja@mail.com',  '9000000006', 'Female', '2003-12-05', 'Surat',     2, '2024-06-23');

INSERT INTO enrollments (student_id, course_id, marks) VALUES
    (1, 1, 82), (1, 2, 75),
    (2, 1, 91), (2, 2, 88),
    (3, 3, 68), (3, 2, 54),
    (4, 4, 79),
    (5, 5, 85),
    (6, 3, 72), (6, 1, 45);

INSERT INTO fees (student_id, amount, paid_on, status) VALUES
    (1, 25000, '2024-07-01', 'Paid'),
    (2, 25000, '2024-07-02', 'Paid'),
    (3, 25000, NULL,         'Pending'),
    (4, 22000, '2024-07-05', 'Paid'),
    (5, 20000, NULL,         'Pending'),
    (6, 25000, '2024-07-10', 'Paid');

-- ---------- 4. BASIC SELECT ----------
SELECT * FROM students;
SELECT name, city FROM students WHERE city = 'Surat';
SELECT * FROM students ORDER BY name;
SELECT * FROM students WHERE name LIKE 'R%';

-- ---------- 5. JOINS ----------
-- Each student with their department
SELECT s.student_id, s.name, d.dept_name
FROM students s
JOIN departments d ON s.dept_id = d.dept_id;

-- Each course with its faculty name
SELECT c.course_name, f.name AS faculty
FROM courses c
JOIN faculty f ON c.faculty_id = f.faculty_id;

-- Which student is enrolled in which course, with marks
SELECT s.name AS student, c.course_name, e.marks
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c  ON e.course_id  = c.course_id
ORDER BY s.name;

-- ---------- 6. GROUP BY / AGGREGATE ----------
-- Number of students per department
SELECT d.dept_name, COUNT(s.student_id) AS total_students
FROM departments d
LEFT JOIN students s ON d.dept_id = s.dept_id
GROUP BY d.dept_name;

-- Average marks per student
SELECT s.name, ROUND(AVG(e.marks),2) AS avg_marks
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
GROUP BY s.name
ORDER BY avg_marks DESC;

-- Topper (highest average marks)
SELECT s.name, ROUND(AVG(e.marks),2) AS avg_marks
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
GROUP BY s.name
ORDER BY avg_marks DESC
LIMIT 1;

-- Highest marks per course
SELECT c.course_name, MAX(e.marks) AS highest
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_name;

-- Average faculty salary per department
SELECT d.dept_name, AVG(f.salary) AS avg_salary
FROM faculty f
JOIN departments d ON f.dept_id = d.dept_id
GROUP BY d.dept_name;

-- ---------- 7. FEES ----------
-- Students with pending fees
SELECT s.name, f.amount
FROM fees f
JOIN students s ON f.student_id = s.student_id
WHERE f.status = 'Pending';

-- Total fees collected
SELECT SUM(amount) AS total_collected FROM fees WHERE status = 'Paid';

-- ---------- 8. SUBQUERY ----------
-- Students scoring above the overall average
SELECT s.name, e.marks
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
WHERE e.marks > (SELECT AVG(marks) FROM enrollments);

-- Students not enrolled in any course
SELECT name FROM students
WHERE student_id NOT IN (SELECT student_id FROM enrollments);

-- ---------- 9. UPDATE ----------
UPDATE students SET city = 'Gandhinagar' WHERE student_id = 5;
UPDATE fees SET status = 'Paid', paid_on = CURRENT_DATE WHERE student_id = 3;
UPDATE faculty SET salary = salary + 5000 WHERE dept_id = 1;
UPDATE enrollments SET marks = 50 WHERE student_id = 6 AND course_id = 1;

-- ---------- 10. DELETE ----------
-- Delete from child tables first, then the parent table (because of foreign keys)
-- DELETE FROM enrollments WHERE student_id = 6;
-- DELETE FROM fees WHERE student_id = 6;
-- DELETE FROM students WHERE student_id = 6;

-- ---------- 11. VIEW ----------
CREATE VIEW student_report AS
SELECT s.student_id, s.name, d.dept_name,
       ROUND(AVG(e.marks),2) AS avg_marks
FROM students s
JOIN departments d ON s.dept_id = d.dept_id
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.name, d.dept_name;

SELECT * FROM student_report;