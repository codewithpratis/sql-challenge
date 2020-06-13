-- Data Engineering -- 
-- Drop Tables if Existed -- 
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS department_emp;
DROP TABLE IF EXISTS department_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;

-- Creating tables and Importing CSV file -- 
CREATE TABLE departments (
	dept_no VARCHAR NOT NULL,
	dept_name VARCHAR NOT NULL,
	CONSTRAINT pk_departments PRIMARY KEY (dept_no)
);
CREATE TABLE department_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL
);
CREATE TABLE department_manager (
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL
);
CREATE TABLE employees (
	emp_no INT NOT NULL,
	emp_title_id VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	CONSTRAINT pk_employees PRIMARY KEY (emp_no)
);
CREATE TABLE salaries (
	emp_no INT NOT NULL,
	salary INT NOT NULL
);
CREATE TABLE titles (
	title_id VARCHAR NOT NULL,
	title VARCHAR(255)
);

ALTER TABLE department_emp ADD CONSTRAINT fk_dept_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE department_emp ADD CONSTRAINT fk_department_emp_deptno FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE department_manager ADD CONSTRAINT fk_department_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE department_manager ADD CONSTRAINT fk_department_manager_empno FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

-- QUERIES --
SELECT * FROM departments;
SELECT * FROM department_emp;
SELECT * FROM department_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

-- Data Analysis --

-- 1. List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT employees.emp_no, employees.last_name, employees.first_name, employees.sex, salaries.salary
FROM employees
JOIN salaries
ON employees.emp_no = salaries.emp_no;

-- 2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT employees.first_name, employees.last_name, employees.hire_date
FROM employees
WHERE hire_date BETWEEN '1986-01-01' AND '1987-01-01';

-- 3. List the manager of each department with the following information: 
-- 	  department number, department name, the manager's employee number, last name, first name.
SELECT departments.dept_no, departments.dept_name, department_manager.emp_no, employees.last_name, employees.first_name
FROM departments
JOIN department_manager
ON departments.dept_no = department_manager.dept_no
JOIN employees
ON department_manager.emp_no = employees.emp_no;

-- 4. List the department of each employee with the following information: 
-- 	  employee number, last name, first name, and department name.
SELECT employees.emp_no, employees.last_name, employees.first_name, departments.dept_name, department_emp.emp_no
FROM department_emp
JOIN employees
ON department_emp.emp_no = employees.emp_no
JOIN departments
ON departments.dept_no = departments.dept_no;

-- 5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.first_name, employees.last_name, employees.sex
FROM employees
WHERE employees.first_name = 'Hercules' AND employees.last_name LIKE 'B%';

-- 6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT department_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM department_emp
JOIN employees
ON department_emp.emp_no = employees.emp_no
JOIN departments
ON department_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

-- 7.List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT department_emp.emp_no, employees.last_name, employees.first_name, departments.dept_name
FROM department_emp
JOIN employees
ON department_emp.emp_no = employees.emp_no
JOIN departments
ON department_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales' OR departments.dept_name = 'Development';

-- 8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT employees.last_name,
COUNT(employees.last_name) AS "frequency"
FROM employees
GROUP BY employees.last_name
ORDER BY
COUNT(employees.last_name) DESC;

