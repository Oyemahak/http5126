-- 1. First drop the TRIGGER (depends on attendance table)
DROP TRIGGER IF EXISTS trg_attendance_alert;

-- 2.1. Then drop VIEWS (depends on tables)
DROP VIEW IF EXISTS vw_student_progress;

-- 2.2. Then drop VIEWS (depends on tables)
DROP VIEW IF EXISTS vw_final_grades;

-- 3. Finally drop TABLES (reverse creation order due to FK dependencies)
DROP TABLE IF EXISTS grade;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class;
DROP TABLE IF EXISTS student;

-- 4. Optional: Drop the database if you want a completely fresh start
DROP DATABASE IF EXISTS canstem_school;


-- Attendance Alert Trigger (Exact match to your requirements)
DELIMITER //
CREATE TRIGGER trg_attendance_alert
AFTER INSERT ON attendance
FOR EACH ROW
BEGIN
    DECLARE absence_count INT;
    
    -- Count absences within current term
    SELECT COUNT(*) INTO absence_count
    FROM attendance a
    JOIN class c ON a.class_id = c.class_id
    WHERE a.student_id = NEW.student_id
    AND a.status = 'Absent'
    AND c.term = (SELECT term FROM class WHERE class_id = NEW.class_id);
    
    IF absence_count >= 3 THEN
        INSERT INTO attendance_alerts (student_id, class_id, absence_count, alert_date)
        VALUES (NEW.student_id, NEW.class_id, absence_count, CURDATE());
        
        -- Simulate email notification
        SET @email_message = CONCAT(
            'Alert: Student ', 
            (SELECT CONCAT(first_name, ' ', last_name) FROM student WHERE student_id = NEW.student_id),
            ' has ', absence_count, ' absences in ',
            (SELECT name FROM course WHERE course_id = 
                (SELECT course_id FROM class WHERE class_id = NEW.class_id)
            ));
    END IF;
END//
DELIMITER ;


-- Enrollment Audit Trigger (As specified)
DELIMITER //
CREATE TRIGGER trg_enrollment_audit
AFTER INSERT ON enrollment
FOR EACH ROW
BEGIN
    INSERT INTO enrollment_history (
        enrollment_id, 
        student_id, 
        class_id, 
        change_date, 
        action
    ) VALUES (
        NEW.enrollment_id,
        NEW.student_id,
        NEW.class_id,
        NOW(),
        'INSERT'
    );
END//
DELIMITER ;