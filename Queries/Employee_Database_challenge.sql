SELECT a.emp_no, a.first_name, a.last_name, b.title, b.from_date, b.to_date
INTO retirement_titles
FROM employees AS a
INNER JOIN titles AS b ON a.emp_no=b.emp_no
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY a.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (______) _____,
______,
______,
______

INTO nameyourtable
FROM _______
ORDER BY _____, _____ DESC;


