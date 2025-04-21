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

CREATE VIEW vw_student_progress AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.class_id,
    c.class_name,
    COUNT(DISTINCT a.date) AS total_classes,
    SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) AS present_count,
    ROUND(AVG(g.score), 2) AS average_score,
    ROUND(SUM(CASE WHEN a.status = 'Present' THEN 1 ELSE 0 END) / 
          COUNT(DISTINCT a.date) * 100, 2) AS attendance_percentage
FROM student s
LEFT JOIN attendance a ON s.student_id = a.student_id
LEFT JOIN class c ON a.class_id = c.class_id
LEFT JOIN grade g ON s.student_id = g.student_id AND c.class_id = g.class_id
GROUP BY s.student_id, c.class_id;