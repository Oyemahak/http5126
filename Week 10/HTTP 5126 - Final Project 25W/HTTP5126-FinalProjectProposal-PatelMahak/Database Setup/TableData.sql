-- Insert students (Indian-Canadian names)
INSERT INTO student (first_name, last_name, grade_level, email) VALUES
('Aarav', 'Patel', '10', 'aarav.patel@canstem.ca'),
('Priya', 'Sharma', '11', 'priya.sharma@canstem.ca'),
('Ethan', 'Wilson', '12', 'ethan.wilson@canstem.ca'),
('Diya', 'Kumar', '9', 'diya.kumar@canstem.ca'),
('Liam', 'Johnson', '10', 'liam.johnson@canstem.ca');

-- Insert teachers
INSERT INTO teacher (first_name, last_name, email, hire_date) VALUES
('Rajesh', 'Iyer', 'riyer@canstem.ca', '2018-09-01'),
('Jennifer', 'MacDonald', 'jmacdonald@canstem.ca', '2020-01-15'),
('Sanjay', 'Verma', 'sverma@canstem.ca', '2019-03-10');

-- Insert courses (Ontario curriculum)
INSERT INTO course VALUES
('MHF4U', 'Advanced Functions', 'Mathematics', 1),
('ENG4U', 'English', 'Languages', 1),
('ICS4U', 'Computer Science', 'Technology', 1),
('SPH4U', 'Physics', 'Sciences', 1);

-- Insert classes
INSERT INTO class (course_id, teacher_id, term, room_number, max_students) VALUES
('MHF4U', 1, 'Fall', 'MATH-201', 30),
('ENG4U', 2, 'Fall', 'ENG-104', 25),
('ICS4U', 3, 'Fall', 'COMP-305', 20);

-- Insert enrollments
INSERT INTO enrollment (student_id, class_id, date) VALUES
(1, 1, '2023-09-05'), (1, 2, '2023-09-05'),
(2, 1, '2023-09-05'), (2, 3, '2023-09-05'),
(3, 2, '2023-09-05'), (4, 3, '2023-09-05');

-- Insert assignments
INSERT INTO assignment (class_id, type, weightage, due_date, total_marks) VALUES
(1, 'Test', 20, '2023-10-15', 100),
(1, 'Project', 30, '2023-11-20', 100),
(2, 'Essay', 25, '2023-10-30', 50);

-- Insert attendance
INSERT INTO attendance (student_id, class_id, date, status) VALUES
(1, 1, '2023-10-02', 'Present'),
(1, 1, '2023-10-04', 'Absent'),
(2, 1, '2023-10-02', 'Present');

-- Insert grades
INSERT INTO grade (assignment_id, student_id, score, submission_date) VALUES
(1, 1, 85.5, '2023-10-16'),
(1, 2, 92.0, '2023-10-16'),
(3, 1, 39.25, '2023-10-31');