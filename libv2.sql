-- Database: Library System Management

-- DROP DATABASE IF EXISTS "Library System Management";

CREATE DATABASE "Library System Management"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;



CREATE DATABASE library_db;
DROP TABLE IF EXISTS branchs;
CREATE TABLE branchs
(
            branch_id VARCHAR(10) PRIMARY KEY,
            manager_id VARCHAR(10),
            branch_address VARCHAR(30),
            contact_no VARCHAR(15)
);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
            emp_id VARCHAR(10) PRIMARY KEY,
            emp_name VARCHAR(30),
            position VARCHAR(30),
            salary DECIMAL(10,2),
            branch_id VARCHAR(10),
            FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);

DROP TABLE IF EXISTS memberss;
CREATE TABLE memberss
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);

DROP TABLE IF EXISTS bookss;
CREATE TABLE bookss
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

DROP TABLE IF EXISTS issued_statuss;
CREATE TABLE issued_statuss
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);

DROP TABLE IF EXISTS return_statuss;
CREATE TABLE return_statuss
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);


-------------------------------------
INSERT INTO bookss(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM bookss;

------------------------------------
UPDATE memberss
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-------------------------------
DELETE 
FROM issued_statuss
WHERE   issued_id =   'IS121';
-----------------------------
SELECT *
FROM issued_statuss
WHERE issued_emp_id = 'E101'
-------------------------------
SELECT issued_emp_id, COUNT(*)
FROM issued_statuss
GROUP BY 1
HAVING COUNT(*) > 1

------------------------------------

CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title,
COUNT(ist.issued_id) AS issue_count
FROM issued_statuss as ist
JOIN bookss as b ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

-----------------------------------
SELECT * FROM bookss
WHERE category = 'Classic';
-----------------------------------
SELECT b.category,SUM(b.rental_price),COUNT(*)
FROM issued_statuss as ist
JOIN bookss as b ON b.isbn = ist.issued_book_isbn
GROUP BY 1

----------------------------------

SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
-----------------------------------
SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
INNER JOIN  branch as b ON e1.branch_id = b.branch_id    
JOIN employees as e2 ON e2.emp_id = b.manager_id

-----------------------
CREATE TABLE expensive_bookss AS
SELECT * 
FROM bookss
WHERE rental_price > 7.00;
--------------------------
SELECT * 
FROM issued_statuss as ist
LEFT JOIN return_statuss as rs ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;
---------------------------


