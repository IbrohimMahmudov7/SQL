create database homework_15
go
use homework_15


--1. Find Employees with Minimum Salary

CREATE TABLE employees (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (id, name, salary) VALUES
(1, 'Alice', 50000),
(2, 'Bob', 60000),
(3, 'Charlie', 50000);


Select *  from employees
where salary =(select MIN(salary) from employees AS MIN_SALARY)

--TASK 2. Find Products Above Average Price

CREATE TABLE products (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2)
);

INSERT INTO products (id, product_name, price) VALUES
(1, 'Laptop', 1200),
(2, 'Tablet', 400),
(3, 'Smartphone', 800),
(4, 'Monitor', 300);

select * from products
where price >=(select AVG(price) from products AS AVG_PRICE)


--TASK  3. Find Employees in Sales Department Task: Retrieve employees who work in the "Sales" department. 

CREATE TABLE departments (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees1 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments (id, department_name) VALUES
(1, 'Sales'),
(2, 'HR');

INSERT INTO employees1 (id, name, department_id) VALUES
(1, 'David', 1),
(2, 'Eve', 2),
(3, 'Frank', 1);

select * from departments
select * from employees1

select name from employees1
Where department_id= ( select id from departments where department_name='Sales')

--Task 4 Task: Retrieve customers who have not placed any orders. Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers (customer_id, name) VALUES
(1, 'Grace'),
(2, 'Heidi'),
(3, 'Ivan');

INSERT INTO orders (order_id, customer_id) VALUES
(1, 1),
(2, 1);

select name from customers
where customer_id NOT IN ( Select customer_id from orders)

--TASK 5 Task: Retrieve products with the highest price in each category. Tables: products (columns: id, product_name, price, category_id)

CREATE TABLE products1 (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products1 (id, product_name, price, category_id) VALUES
(1, 'Tablet', 400, 1),
(2, 'Laptop', 1500, 1),
(3, 'Headphones', 200, 2),
(4, 'Speakers', 300, 2);

select * from products1 as p
where price = (select MAX(price) from products1 where category_id=p.category_id)

--TASK 6  Retrieve employees working in the department with the highest average salary.
--Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)

CREATE TABLE departments1 (
    id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE employees2 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

INSERT INTO departments1 (id, department_name) VALUES
(1, 'IT'),
(2, 'Sales');

INSERT INTO employees2 (id, name, salary, department_id) VALUES
(1, 'Jack', 80000, 1),
(2, 'Karen', 70000, 1),
(3, 'Leo', 60000, 2);


--Task 7 

CREATE TABLE employees3 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees3 (id, name, salary, department_id) VALUES
(1, 'Mike', 50000, 1),
(2, 'Nina', 75000, 1),
(3, 'Olivia', 40000, 2),
(4, 'Paul', 55000, 2);

select * from employees3
where salary >= (select AVG(salary) from employees3)	


--8 Task: Retrieve students who received the highest grade in each course. 
--Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE grades (
    student_id INT,
    course_id INT,
    grade DECIMAL(4, 2),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students (student_id, name) VALUES
(1, 'Sarah'),
(2, 'Tom'),
(3, 'Uma');

INSERT INTO grades (student_id, course_id, grade) VALUES
(1, 101, 95),
(2, 101, 85),
(3, 102, 90),
(1, 102, 80);

select * from students
where grade =(select MAX(grade) from students) 

select * from grades g
where grade = (select MAX(grade) from grades where course_id = g.course_id)

--Task 9 Find Third-Highest Price per Category Task: Retrieve products with the third-highest price in each category. 
--Tables: products (columns: id, product_name, price, category_id)

CREATE TABLE products9 (
    id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10, 2),
    category_id INT
);

INSERT INTO products9 (id, product_name, price, category_id) VALUES
(1, 'Phone', 800, 1),
(2, 'Laptop', 1500, 1),
(3, 'Tablet', 600, 1),
(4, 'Smartwatch', 300, 1),
(5, 'Headphones', 200, 2),
(6, 'Speakers', 300, 2),
(7, 'Earbuds', 100, 2);

select * from products9 p1
where 2 = ( select count(distinct p2.price) from products9 p2
where p2.category_id=p1.category_id
AND p2.price > p1.price)


--TASK 10 Retrieve employees with salaries above the company average but below the maximum in their department. Tables: employees (columns: id, name, salary, department_id)

CREATE TABLE employees5 (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    department_id INT
);

INSERT INTO employees5 (id, name, salary, department_id) VALUES
(1, 'Alex', 70000, 1),
(2, 'Blake', 90000, 1),
(3, 'Casey', 50000, 2),
(4, 'Dana', 60000, 2),
(5, 'Evan', 75000, 1);

select * from employees5 e
where e.salary> ( select AVG (salary) from employees5)
AND e.salary < ( select MAX(salary) from employees5 
Where department_id= e.department_id)
