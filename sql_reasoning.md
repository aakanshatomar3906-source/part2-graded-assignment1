# SQL Reasoning Explanations

## 1. LEFT JOIN vs INNER JOIN

**Query Example:** Query 7 - Display all students and their enrollments

```sql
SELECT st.student_id, st.name, c.course_id, c.course_name
FROM students st
LEFT JOIN enrollments e ON st.student_id = e.student_id
LEFT JOIN courses c ON e.course_id = c.course_id;
```

**Why LEFT JOIN is more appropriate:**

We want to see **all students**, including those who haven't enrolled in any course. With INNER JOIN, students without enrollments would be excluded entirely.

| Approach | Result |
|----------|--------|
| `INNER JOIN` | Returns only 185 students (those with enrollments) |
| `LEFT JOIN` | Returns all 200 students (15 show NULL for course) |

**Real Impact:** The requirement was to identify students who haven't enrolled yet. INNER JOIN would make this impossible.

---

## 2. HAVING vs WHERE

**Query Example:** Query 13 - Find students with more than 20 submissions

```sql
SELECT st.student_id, st.name, COUNT(s.submission_id) AS total_submissions
FROM students st
INNER JOIN submissions s ON st.student_id = s.student_id
GROUP BY st.student_id, st.name
HAVING COUNT(s.submission_id) > 20;
```

**Why HAVING is required:**

- `WHERE` filters **rows before aggregation**
- `HAVING` filters **groups after aggregation**

**Why WHERE fails:**
```sql
WHERE COUNT(s.submission_id) > 20  -- INVALID - cannot use aggregate in WHERE
```

**Execution order:**
1. `FROM` + `JOIN` → get rows
2. `WHERE` → filter rows (no aggregates allowed)
3. `GROUP BY` → aggregate
4. `HAVING` → filter groups (aggregates allowed)
5. `SELECT` → return columns

---

## 3. Subquery Example

**Query Example:** Query 16 - Students above overall average score

```sql
SELECT st.student_id, st.name, AVG(s.score) AS avg_score
FROM students st
INNER JOIN submissions s ON st.student_id = s.student_id
GROUP BY st.student_id, st.name
HAVING AVG(s.score) > (SELECT AVG(score) FROM submissions);
```

**How the subquery solved the problem:**

The challenge: Compare each student's average against the **overall** average.

**Subquery role:**
```sql
(SELECT AVG(score) FROM submissions)  -- Returns 72.3
```

This calculates the global average **independent** of the outer query's grouping.

**Why subquery is essential:**
- Dynamic: Automatically updates when data changes
- Single query: No manual intervention needed
- Correct: Computes overall average independently

---

## 4. Misleading Output with Duplicate Records

**Situation:** Query 8 (Courses with enrollment count) could be misleading if duplicate enrollments exist.

```sql
SELECT c.course_id, COUNT(e.student_id) AS enrolled_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = c.course_id
GROUP BY c.course_id;
```

**Problem:** If enrollments has duplicates (same student enrolled twice):

| course_id | student_id |
|-----------|------------|
| 1 | 101 |
| 1 | 101 | ← duplicate! |
| 1 | 102 |

**Result:** COUNT returns 3 instead of 2 unique students.

**Solution:** Use `COUNT(DISTINCT e.student_id)`:
```sql
COUNT(DISTINCT e.student_id) AS enrolled_students
```

**Lesson:** Always check for duplicates in joined tables for COUNT aggregations.

---

## 5. Edge Case Considered

**Edge Case:** NULL values in JOIN conditions and aggregations

**Query affected:** Query 12 (Average score per problem)

```sql
SELECT p.problem_id, p.title, AVG(s.score) AS avg_score
FROM problems p
LEFT JOIN submissions s ON p.problem_id = s.problem_id
GROUP BY p.problem_id, p.title;
```

**Edge case:** Problems with **zero submissions**

- `LEFT JOIN` ensures problems appear even without submissions
- `AVG(s.score)` returns `NULL` for problems with no submissions (not 0!)
- This is correct: no submissions = no average, not average of 0

**What could go wrong:**
- If we used `INNER JOIN`, unattempted problems disappear
- If we assumed `AVG(NULL) = 0`, we'd misrepresent difficulty

**Handling:**
- Kept NULL to explicitly indicate "no data"
- Or use `COALESCE(AVG(s.score), 0)` if business requires 0
