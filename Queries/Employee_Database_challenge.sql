-- Employees close to retirement and their titles
SELECT a.emp_no, a.first_name, a.last_name, b.title, b.from_date, b.to_date
INTO retirement_titles
FROM employees AS a
INNER JOIN titles AS b ON a.emp_no=b.emp_no
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY a.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title, from_date, to_date
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Count of retiring titles 
SELECT count(1), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(1) DESC;

-- Mentorship Eligibility
SELECT DISTINCT ON (a.emp_no) 
a.emp_no, a.first_name, a.last_name,  a.birth_date, b.from_date, b.to_date, c.title
INTO mentorship_eligibilty
FROM employees AS a
INNER JOIN dept_emp AS b ON a.emp_no=b.emp_no
LEFT JOIN titles AS c ON a.emp_no=c.emp_no
WHERE b.to_date > NOW() AND a.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY a.emp_no, c.from_date DESC;

-- All vs Retirement by Title
select d.title, count(1) as "all", e.count as retiring, round(e.count/count(1)::decimal*100,2) as percentage
from
(
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title, from_date, to_date
FROM
(
SELECT a.emp_no, a.first_name, a.last_name, b.title, b.from_date, b.to_date
FROM employees AS a
INNER JOIN titles AS b ON a.emp_no=b.emp_no
ORDER BY a.emp_no
) c
ORDER BY emp_no, to_date DESC
) d
left join retiring_titles as e on d.title=e.title
group by d.title, e.count
order by "all" desc

-- Retirement by Department
SELECT c.dept_name, count(b.title) AS mentors FROM
(
SELECT DISTINCT ON (emp_no) emp_no, dept_no  FROM dept_emp
ORDER BY emp_no, from_date DESC
) a
INNER JOIN unique_titles b ON a.emp_no=b.emp_no
INNER JOIN departments c ON a.dept_no=c.dept_no
GROUP BY  dept_name
ORDER BY mentors DESC;

-- Mentors by Department
SELECT c.dept_name, count(b.title) AS mentors FROM
(
SELECT DISTINCT ON (emp_no) emp_no, dept_no  FROM dept_emp
ORDER BY emp_no, from_date DESC
) a
INNER JOIN mentorship_eligibilty b ON a.emp_no=b.emp_no
INNER JOIN departments c ON a.dept_no=c.dept_no
GROUP BY  dept_name
ORDER BY mentors DESC;

