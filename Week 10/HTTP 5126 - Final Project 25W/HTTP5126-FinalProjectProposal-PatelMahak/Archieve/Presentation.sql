-- Test 1: Trigger activation (should show alert on 3rd absence)
INSERT INTO attendance (student_id, class_id, date, status)
VALUES (1, 1, '2023-10-04', 'Absent'); -- 3rd absence

-- Test 2: View verification
SELECT * FROM vw_student_progress;

-- Test 3: Data consistency checks
-- Attendance summary
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student,
    COUNT(CASE WHEN a.status = 'Absent' THEN 1 END) AS absences
FROM student s
LEFT JOIN attendance a ON s.student_id = a.student_id
GROUP BY s.student_id;

-- Grade summary
SELECT 
    student_id,
    class_id,
    COUNT(*) AS grade_count,
    ROUND(AVG(score), 2) AS avg_score
FROM grade
GROUP BY student_id, class_id;


--Reset Test

-- 1. Delete ONLY the test attendance records for student_id=1 in class_id=1
DELETE FROM attendance 
WHERE student_id = 1 
AND class_id = 1 
AND date >= '2023-10-04'; -- This removes any previously inserted test records