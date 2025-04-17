-- ========================================
-- Create fresh database
-- ========================================
DROP DATABASE IF EXISTS canstem_school;
CREATE DATABASE canstem_school;
USE canstem_school;

-- =====================
-- Student table (exact match)
-- =====================
CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    grade_level VARCHAR(10) NOT NULL CHECK (grade_level IN ('9', '10', '11', '12')),
    email VARCHAR(100) NOT NULL UNIQUE
);

-- =====================
-- Teacher table (exact match)
-- =====================
CREATE TABLE teacher (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) NOT NULL UNIQUE,
    hire_date DATE NOT NULL
);

-- =====================
-- Course table (exact match)
-- =====================
CREATE TABLE course (
    course_id CHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50) NOT NULL,
    credits INT NOT NULL CHECK (credits BETWEEN 0 AND 4)
);

-- =====================
-- Class table (exact match)
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
-- Assignment table (exact match)
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
-- Enrollment table (exact match)
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
-- Attendance table (exact match)
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
-- Grade table (exact match)
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