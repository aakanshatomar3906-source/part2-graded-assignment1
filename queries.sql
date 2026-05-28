-- ==========================================
-- QUERY 1: 
-- ==========================================
SELECT 
    student_id, 
    full_name, 
    email, 
    batch_id, 
    admission_date
FROM students
WHERE enrollment_status = 'active'
ORDER BY student_id ASC;

-- ==========================================
-- QUERY 2
-- ==========================================
SELECT 
    student_id, 
    roll_number, 
    full_name, 
    email, 
    enrollment_status
FROM students
WHERE email IS NULL 
   OR email = '' 
   OR email NOT LIKE '%@%.%'
ORDER BY student_id ASC;

-- ==========================================
-- QUERY 3
-- ==========================================
SELECT 
    problem_id, 
    problem_code, 
    title, 
    difficulty, 
    max_score 
FROM problems
WHERE difficulty IN ('Easy', 'Medium')
ORDER BY difficulty DESC, problem_id ASC;


-- ==========================================
-- QUERY 4: 
-- ==========================================
SELECT 
    submission_id, 
    student_id, 
    problem_id, 
    language, 
    submitted_at, 
    status, 
    score 
FROM submissions
ORDER BY submitted_at DESC
LIMIT 20;


-- ==========================================
-- QUERY 5: 
-- ==========================================
SELECT 
    submission_id, 
    student_id, 
    problem_id, 
    language, 
    status, 
    score, 
    runtime_ms 
FROM submissions
WHERE status != 'Accepted'
ORDER BY submitted_at DESC;


-- ==========================================
-- QUERY 6: 
-- ==========================================
SELECT 
    s.submission_id,
    st.full_name AS student_name,
    p.title AS problem_title,
    s.language,
    s.status,
    s.score,
    s.submitted_at
FROM submissions s
JOIN students st ON s.student_id = st.student_id
JOIN problems p ON s.problem_id = p.problem_id
ORDER BY s.submitted_at DESC;


-- ==========================================
-- QUERY 7: 
-- ==========================================
SELECT 
    s.student_id,
    s.full_name,
    s.email,
    e.enrollment_id,
    e.course_id,
    e.enrollment_status
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
ORDER BY s.student_id ASC;


-- ==========================================
-- QUERY 8: 
-- ==========================================
SELECT 
    c.course_id,
    c.course_code,
    c.course_title,
    COUNT(e.enrollment_id) AS enrolled_students_count
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_title
ORDER BY enrolled_students_count DESC;


-- ==========================================
-- QUERY 9: 
-- ==========================================
SELECT 
    tr.result_id,
    s.submission_id,
    st.full_name AS student_name,
    p.title AS problem_title,
    tr.test_case_id,
    tr.result_status,
    tr.awarded_points
FROM test_results tr
JOIN submissions s ON tr.submission_id = s.submission_id
JOIN students st ON s.student_id = st.student_id
JOIN problems p ON s.problem_id = p.problem_id
ORDER BY s.submission_id ASC, tr.test_case_id ASC;


-- ==========================================
-- QUERY 10:
-- ==========================================
SELECT DISTINCT
    st.student_id,
    st.full_name,
    c.course_id,
    c.course_title
FROM enrollments e
JOIN students st ON e.student_id = st.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM submissions sub
    JOIN problems p ON sub.problem_id = p.problem_id
    WHERE sub.student_id = e.student_id 
      AND p.course_id = e.course_id
)
ORDER BY st.student_id ASC;


-- ==========================================
-- QUERY 11:
-- ==========================================
SELECT 
    status, 
    COUNT(*) AS total_submissions
FROM submissions
GROUP BY status
ORDER BY total_submissions DESC;


-- ==========================================
-- QUERY 12: 
-- ==========================================
SELECT 
    language,
    ROUND(AVG(runtime_ms), 2) AS average_runtime_ms,
    COUNT(*) AS total_submissions
FROM submissions
GROUP BY language
ORDER BY total_submissions DESC;


-- ==========================================
-- QUERY 14: 
-- ==========================================
SELECT 
    p.problem_id,
    p.problem_code,
    p.title,
    COUNT(s.submission_id) AS total_attempts,
    SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END) AS successful_attempts,
    ROUND(
        (SUM(CASE WHEN s.status = 'Accepted' THEN 1 ELSE 0 END)::NUMERIC / 
        NULLIF(COUNT(s.submission_id), 0)) * 100, 2
    ) AS success_rate_percentage
FROM problems p
LEFT JOIN submissions s ON p.problem_id = s.problem_id
GROUP BY p.problem_id, p.problem_code, p.title
ORDER BY success_rate_percentage DESC;

-- ==========================================
-- QUERY 15:
-- ==========================================
SELECT 
    p.problem_id,
    p.problem_code,
    p.title AS problem_title,
    p.difficulty,
    COUNT(s.submission_id) AS total_submission_attempts
FROM problems p
JOIN submissions s ON p.problem_id = s.problem_id
GROUP BY p.problem_id, p.problem_code, p.title, p.difficulty
ORDER BY total_submission_attempts DESC
LIMIT 10;

-- ==========================================
-- QUERY 16: 
-- ==========================================
SELECT 
    st.student_id,
    st.full_name,
    ROUND(AVG(s.score), 2) AS student_average_score
FROM submissions s
JOIN students st ON s.student_id = st.student_id
GROUP BY st.student_id, st.full_name
HAVING AVG(s.score) > (SELECT AVG(score) FROM submissions)
ORDER BY student_average_score DESC;


-- ==========================================
-- QUERY 17: 
-- ==========================================
SELECT 
    p.problem_id,
    p.problem_code,
    p.title,
    p.difficulty
FROM problems p
LEFT JOIN submissions s ON p.problem_id = s.problem_id
WHERE s.submission_id IS NULL
ORDER BY p.problem_id ASC;


-- ==========================================
-- QUERY 18: 
-- ==========================================
SELECT DISTINCT
    st.student_id,
    st.full_name,
    st.email,
    st.enrollment_status
FROM enrollments e
JOIN students st ON e.student_id = st.student_id
LEFT JOIN submissions s ON st.student_id = s.student_id
WHERE s.submission_id IS NULL
ORDER BY st.student_id ASC;

-- ==========================================
-- QUERY 19: 
-- ==========================================
SELECT 
    st.student_id,
    st.full_name,
    st.email
FROM students st
WHERE st.student_id IN (
    SELECT student_id 
    FROM submissions 
    WHERE language = 'Python'
)
AND st.student_id IN (
    SELECT student_id 
    FROM submissions 
    WHERE language = 'Java'
)
ORDER BY st.student_id ASC;


-- ==========================================
-- QUERY 20: 
-- ==========================================
SELECT 
    MAX(score) AS second_highest_score
FROM submissions
WHERE problem_id = 'P0010'
  AND score < (
      SELECT MAX(score) 
      FROM submissions 
      WHERE problem_id = 'P0010'
  );
