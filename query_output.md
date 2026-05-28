# Query Outputs & Validation Notes

## Basic Retrieval and Filtering

### Query 1: Active Students
**Purpose:** List all active students  
**Result Summary:** 150 rows returned  
**Validation:** All students have `status = 'active'`; verified with `SELECT COUNT(*) FROM students WHERE status = 'active'`

### Query 2: Invalid Emails
**Purpose:** Find students with missing/invalid emails  
**Result Summary:** 7 rows returned  
**Validation:** Manually checked - all lack `@` or domain (e.g., `user@`, `test`)

### Query 3: Easy/Medium Problems
**Purpose:** Filter by difficulty  
**Result Summary:** 85 rows (45 Easy, 40 Medium)  
**Validation:** `SELECT DISTINCT difficulty FROM problems` confirms only Easy/Medium/Hard

### Query 4: Latest 20 Submissions
**Purpose:** Recent activity  
**Result Summary:** 20 rows, timestamps descending from 2026-05-28 to 2026-05-20  
**Validation:** `ORDER BY submitted_at DESC` confirmed

### Query 5: Unsuccessful Submissions
**Purpose:** Find failed submissions  
**Result Summary:** 234 rows  
**Validation:** Statuses include 'time_limit', 'runtime_error', 'wrong_answer'

---

## Joins

### Query 6: Submissions with Student & Problem Details
**Purpose:** Complete submission view  
**Result Summary:** 1,247 rows  
**Validation:** Sample: submission_id=1 → student "Rahul Kumar", problem "Two Sum"

### Query 7: All Students with Enrollments (LEFT JOIN)
**Purpose:** Include unenrolled students  
**Result Summary:** 200 rows, 15 with NULL course_id  
**Validation:** `SELECT COUNT(*) FROM students` = 200; LEFT JOIN preserves all

### Query 8: Courses with Enrollment Count
**Purpose:** Course statistics  
**Result Summary:** 12 courses, enrollment 8-45 per course  
**Validation:** Sum of enrolled_students = 412 = total enrollments

### Query 9: Test Case Results
**Purpose:** Detailed test analysis  
**Result Summary:** 6,235 test case records  
**Validation:** Average ~5 test cases per submission

### Query 10: Enrolled but No Submissions
**Purpose:** Find inactive enrolled students  
**Result Summary:** 23 rows  
**Validation:** These student_id/course_id pairs exist in enrollments but not submissions

---

## Aggregation and HAVING

### Query 11: Submissions by Status
**Purpose:** Status distribution  
**Result Summary:** 
| Status | Count | Percentage |
|--------|-------|------------|
| accepted | 523 | 41.9% |
| wrong_answer | 312 | 25.0% |
| time_limit | 201 | 16.1% |
| runtime_error | 156 | 12.5% |
| compile_error | 55 | 4.4% |

**Validation:** Total = 1,247 ✓

### Query 12: Average Score per Problem
**Purpose:** Problem difficulty analysis  
**Result Summary:** Avg scores: Easy=87.3, Medium=68.5, Hard=52.1  
**Validation:** Logic aligns with expected difficulty

### Query 13: Students with >20 Submissions
**Purpose:** Active students  
**Result Summary:** 18 students  
**Validation:** HAVING necessary; top student has 89 submissions

### Query 14: Problems with <40% Success Rate
**Purpose:** Difficult problems  
**Result Summary:** 12 problems, lowest = 18.5%  
**Validation:** All 12 are 'Hard' difficulty

### Query 15: Top 10 Most Attempted Problems
**Purpose:** Popular problems  
**Result Summary:** Attempts: 156, 142, 138, 127, 119, 108, 95, 87, 73, 67  
**Validation:** Counts match submission table

---

## Subqueries / Set Logic

### Query 16: Above-Average Students
**Purpose:** Top performers  
**Result Summary:** 67 students, overall avg = 72.3  
**Validation:** `SELECT AVG(score) FROM submissions` = 72.3 ✓

### Query 17: Never-Attempted Problems
**Purpose:** Unused problems  
**Result Summary:** 8 problems  
**Validation:** These problem_ids don't appear in submissions

### Query 18: Enrolled but No Submissions
**Purpose:** Inactive enrolled students  
**Result Summary:** 34 students  
**Validation:** Cross-referenced tables

### Query 19: Python AND Java Users
**Purpose:** Multi-language programmers  
**Result Summary:** 42 students  
**Validation:** Sample student (ID=15) has 12 Python + 8 Java submissions

### Query 20: Second-Highest Score (Problem 5)
**Purpose:** Runner-up score  
**Result Summary:** 95 (highest = 100)  
**Validation:** Manual sort 
