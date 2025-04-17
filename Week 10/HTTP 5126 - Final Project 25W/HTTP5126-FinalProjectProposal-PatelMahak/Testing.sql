-- ================================
-- Test 1: Attendance Alert Trigger
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
-- Test Insert for Attendance Alert Trigger
-- ================================
INSERT INTO attendance (student_id, class_id, date, status) VALUES
(1, 1, '2023-10-06', 'Absent'),
(1, 1, '2023-10-09', 'Absent'); -- Should trigger alert on 3rd absence


-- ================================
-- Test 2: Grade Calculation View
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
-- Verify Final Grades View
-- ================================
SELECT * FROM vw_final_grades;


-- ================================
-- Extra View: Student Progress View
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
-- Verify Student Progress View
-- ================================
SELECT * FROM vw_student_progress;


-- ================================
-- Trigger: Grade Before Insert Validation
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
-- Reset Test Data: Delete Test Attendance Records
-- ================================
DELETE FROM attendance 
WHERE student_id = 1 
AND class_id = 1 
AND date >= '2023-10-04'; -- This removes any previously inserted test records