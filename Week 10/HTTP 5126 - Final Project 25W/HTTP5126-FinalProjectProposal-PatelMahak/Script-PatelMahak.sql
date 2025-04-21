/*
* CANSTEM SCHOOL DATABASE SYSTEM
* HTTP 5126 Final Project
* Student: Mahak Patel
* Date: April 2025
* 
* Features Demonstrated:
* - Real-time attendance alerts (trigger)
* - Automated grade calculations (view)
* - Student progress tracking (view)
*/

-- ========================================
-- Create database
-- ========================================
DROP DATABASE IF EXISTS canstem_school;
CREATE DATABASE canstem_school;
USE canstem_school;

-- =====================
-- Student table
-- =====================
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    grade_level VARCHAR(10) NOT NULL CHECK (grade_level IN ('9', '10', '11', '12')),
    email VARCHAR(100) NOT NULL UNIQUE
);

-- =====================
-- Teacher table
-- =====================
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    hire_date DATE NOT NULL
);

-- =====================
-- Course table 
-- =====================
CREATE TABLE course (
    course_id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 0 AND 4)
);

-- =====================
-- Class table 
-- =====================
CREATE TABLE class (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id CHAR(20) NOT NULL,
    teacher_id INT NOT NULL,
    term VARCHAR(20) NOT NULL CHECK (term IN ('Fall', 'Winter', 'Spring', 'Summer')),
    room_number VARCHAR(10) NOT NULL,
    max_students INT NOT NULL CHECK (max_students > 0),
    FOREIGN KEY (course_id) REFERENCES course(course_id),
    FOREIGN KEY (teacher_id) REFERENCES teacher(teacher_id)
);

-- =====================
-- Assignment table 
-- =====================
CREATE TABLE assignment (
    assignment_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('Test', 'Quiz', 'Project', 'Essay', 'Lab')),
    weightage INT NOT NULL CHECK (weightage > 0),
    due_date DATE NOT NULL,
    total_marks DECIMAL(5,2) NOT NULL CHECK (total_marks > 0),
    FOREIGN KEY (class_id) REFERENCES class(class_id)
);

-- =====================
-- Enrollment table 
-- =====================
CREATE TABLE enrollment (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    UNIQUE KEY (student_id, class_id)
);

-- =====================
-- Attendance table
-- =====================
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    date DATE NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Present', 'Absent', 'Late')),
    recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (class_id) REFERENCES class(class_id),
    UNIQUE KEY (student_id, class_id, date)
);

-- =====================
-- Grade table
-- =====================
CREATE TABLE grade (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    score DECIMAL(5,2) CHECK (score IS NULL OR (score >= 0 AND score <= 100)),
    submission_date DATE NOT NULL,
    FOREIGN KEY (assignment_id) REFERENCES assignment(assignment_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

-- ========================================
-- Insert students 
-- ========================================
INSERT INTO student (first_name, last_name, grade_level, email) VALUES
('Aarav', 'Patel', '10', 'aarav.patel@canstem.ca'),
('Priya', 'Sharma', '11', 'priya.sharma@canstem.ca'),
('Ethan', 'Wilson', '12', 'ethan.wilson@canstem.ca'),
('Diya', 'Kumar', '9', 'diya.kumar@canstem.ca'),
('Liam', 'Johnson', '10', 'liam.johnson@canstem.ca');

-- =====================
-- Insert teachers
-- =====================
INSERT INTO teacher (first_name, last_name, email, hire_date) VALUES
('Rajesh', 'Iyer', 'riyer@canstem.ca', '2018-09-01'),
('Jennifer', 'MacDonald', 'jmacdonald@canstem.ca', '2020-01-15'),
('Sanjay', 'Verma', 'sverma@canstem.ca', '2019-03-10');

-- ============================
-- Insert courses (As per Ontario curriculum)
-- ============================
INSERT INTO course VALUES
('MHF4U', 'Advanced Functions', 'Mathematics', 1),
('ENG4U', 'English', 'Languages', 1),
('ICS4U', 'Computer Science', 'Technology', 1),
('SPH4U', 'Physics', 'Sciences', 1);

-- =====================
-- Insert classes
-- =====================
INSERT INTO class (course_id, teacher_id, term, room_number, max_students) VALUES
('MHF4U', 1, 'Fall', 'MATH-201', 30),
('ENG4U', 2, 'Fall', 'ENG-104', 25),
('ICS4U', 3, 'Fall', 'COMP-305', 20);

-- =====================
-- Insert enrollments
-- =====================
INSERT INTO enrollment (student_id, class_id, date) VALUES
(1, 1, '2023-09-05'), (1, 2, '2023-09-05'),
(2, 1, '2023-09-05'), (2, 3, '2023-09-05'),
(3, 2, '2023-09-05'), (4, 3, '2023-09-05');

-- =====================
-- Insert assignments
-- =====================
INSERT INTO assignment (class_id, type, weightage, due_date, total_marks) VALUES
(1, 'Test', 20, '2023-10-15', 100),
(1, 'Project', 30, '2023-11-20', 100),
(2, 'Essay', 25, '2023-10-30', 50);

-- =====================
-- Insert attendance
-- =====================
INSERT INTO attendance (student_id, class_id, date, status) VALUES
(1, 1, '2023-10-02', 'Present'),
(1, 1, '2023-10-04', 'Absent'),
(2, 1, '2023-10-02', 'Present');

-- =====================
-- Insert grades
-- =====================
INSERT INTO grade (assignment_id, student_id, score, submission_date) VALUES
(1, 1, 85.5, '2023-10-16'),
(1, 2, 92.0, '2023-10-16'),
(3, 1, 39.25, '2023-10-31');

-- ================================
-- Trigger: Grade Before Insert Validation
-- TRIGGER: trg_grade_before_insert
-- Purpose: Validates that entered grades don't exceed assignment maximum
-- Fires: BEFORE INSERT on grade table
-- Action: Compares score against assignment.total_marks
-- ================================
DELIMITER //
CREATE TRIGGER trg_grade_before_insert
BEFORE INSERT ON grade
FOR EACH ROW
BEGIN
  DECLARE max_marks DECIMAL(5,2);
  SELECT total_marks INTO max_marks
    FROM assignment
    WHERE assignment_id = NEW.assignment_id;
  IF NEW.score > max_marks THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Score cannot exceed total_marks';
  END IF;
END;//
DELIMITER ;

-- ================================
-- Test 1: Attendance Alert Trigger
-- TRIGGER: trg_attendance_alert
-- Purpose: Monitors consecutive absences and raises alerts
-- Fires: AFTER INSERT on attendance table
-- ================================
DELIMITER //
CREATE TRIGGER trg_attendance_alert 
AFTER INSERT ON attendance
FOR EACH ROW
BEGIN
    DECLARE absence_count INT;
    DECLARE alert_message VARCHAR(100);
    
    SELECT COUNT(*) INTO absence_count 
    FROM attendance 
    WHERE student_id = NEW.student_id 
    AND status = 'Absent';
    
    IF absence_count >= 3 THEN
        SET alert_message = CONCAT('ALERT: Student ', NEW.student_id, ' has 3+ absences!');
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = alert_message;
    END IF;
END//
DELIMITER ;


-- ================================
-- VIEW: vw_final_grades
-- Purpose: Automates grade calculation with department standardization
-- Tables: student, grade, assignment, class, course
-- ================================
CREATE OR REPLACE VIEW vw_final_grades AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.name AS course,
    ROUND(SUM((g.score / a.total_marks) * a.weightage) / SUM(a.weightage) * 100, 2) AS final_percentage,
    CASE
        WHEN ROUND(SUM((g.score / a.total_marks) * a.weightage) / SUM(a.weightage) * 100, 2) >= 90 THEN 'A+'
        WHEN ROUND(SUM((g.score / a.total_marks) * a.weightage) / SUM(a.weightage) * 100, 2) >= 80 THEN 'A'
        WHEN ROUND(SUM((g.score / a.total_marks) * a.weightage) / SUM(a.weightage) * 100, 2) >= 70 THEN 'B'
        WHEN ROUND(SUM((g.score / a.total_marks) * a.weightage) / SUM(a.weightage) * 100, 2) >= 60 THEN 'C'
        ELSE 'D'
    END AS letter_grade
FROM student s
JOIN grade g ON s.student_id = g.student_id
JOIN assignment a ON g.assignment_id = a.assignment_id
JOIN class cl ON a.class_id = cl.class_id
JOIN course c ON cl.course_id = c.course_id
GROUP BY s.student_id, c.course_id;


-- ================================
-- VIEW: vw_student_progress
-- Purpose: Consolidated dashboard of attendance and performance
-- Tables: student, enrollment, class, course, attendance, grade
-- Business Impact: Provides single-point access for teacher reviews
-- ================================

CREATE VIEW vw_student_progress AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', COALESCE(s.last_name, '')) AS student_name,
    c.class_id,
    co.name AS course_name,
    COUNT(a.attendance_id) AS total_classes,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_count,
    ROUND(AVG(g.score), 2) AS avg_score
FROM student s
JOIN enrollment e ON s.student_id = e.student_id
JOIN class c ON e.class_id = c.class_id
JOIN course co ON c.course_id = co.course_id
LEFT JOIN attendance a ON s.student_id = a.student_id AND c.class_id = a.class_id
LEFT JOIN grade g ON s.student_id = g.student_id 
    AND g.assignment_id IN (SELECT assignment_id FROM assignment WHERE class_id = c.class_id)
GROUP BY s.student_id, c.class_id;

-- ================================
-- DEMONSTRATION QUERIES
-- ================================

-- ================================
-- Test Insert for Attendance Alert Trigger
-- (Comment out this insert to get error-free execution)
-- ===============================
INSERT INTO attendance (student_id, class_id, date, status) VALUES
(1, 1, '2023-10-06', 'Absent'),
(1, 1, '2023-10-09', 'Absent'); -- Should trigger alert on 3rd absence

-- ================================
-- To Verify Final Grades View
-- ================================
SELECT * FROM vw_final_grades;

-- ================================
-- To Verify Student Progress View
-- ================================
SELECT * FROM vw_student_progress;