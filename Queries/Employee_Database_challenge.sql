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
FROM public.retirement_titles
ORDER BY emp_no, from_date desc;

-- Count of retiring titles 
SELECT count(1), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count(1) desc

-- Mentorship Eligibility
SELECT DISTINCT ON (a.emp_no) 
a.emp_no, a.first_name, a.last_name,  a.birth_date, b.from_date, b.to_date, c.title
INTO mentorship_eligibilty
FROM employees AS a
INNER JOIN dept_emp AS b ON a.emp_no=b.emp_no
LEFT JOIN titles AS c ON a.emp_no=c.emp_no
WHERE b.to_date > now() and a.birth_date BETWEEN '1965-01-01' AND '1965-12-31'
ORDER BY a.emp_no, c.from_date desc