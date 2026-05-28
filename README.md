# SQL Query Implementation & Verification - Part 2

## Overview
SQL queries for a Student Course Submission Database demonstrating basic retrieval, joins, aggregation, and subqueries.

## Repository Structure

| File | Purpose |
|------|---------|
| `queries.sql` | All 20 SQL queries with comments |
| `query_outputs.md` | Sample outputs and validation notes |
| `sql_reasoning.md` | SQL concept explanations |
| `README.md` | This file |

## Database Schema
students (student_id, name, email, batch, admission_date, status)
problems (problem_id, title, difficulty, topic)
submissions (submission_id, student_id, problem_id, language, status, score, submitted_at)
courses (course_id, course_name, instructor)
enrollments (enrollment_id, student_id, course_id, enrolled_at)
test_cases (test_case_id, submission_id, test_case_number, expected_output, actual_output, status)


## Query Categories

| Category | Queries |
|----------|---------|
| Basic Retrieval & Filtering | 1-5 |
| Joins | 6-10 |
| Aggregation & HAVING | 11-15 |
| Subqueries & Set Logic | 16-20 |

## How to Run

```bash
# MySQL
mysql -u username -p database_name < queries.sql

# PostgreSQL
psql -U username -d database_name -f queries.sql

# SQLite
sqlite3 database.db < queries.sql
```

## Validation Approach

Each query includes:
1. Purpose comment
2. SQL query
3. Sample output summary
4. Validation note

## Marks Breakdown

| Component | Marks | Location |
|-----------|-------|----------|
| Correct SQL queries | 8 | `queries.sql` |
| Joins, aggregation, subquery correctness | 5 | Queries 6-20 |
| Output documentation & validation | 3 | `query_outputs.md` |
| SQL reasoning explanations | 3 | `sql_reasoning.md` |
| Code organization & readability | 1 | Consistent formatting |

## Author
AAKANSHA TOMAR 
May 2026
