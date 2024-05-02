/*
Industria: Bancaria.
Este script crea diferentes tablas y añade datos a cada una de ellas.
*/


-- bank 3
-- Table creation for department
CREATE TABLE department (
    dept_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

-- Table creation for branch
CREATE TABLE branch (
    branch_id SERIAL PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    address VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(2),
    zip VARCHAR(12)
);

-- Table creation for employee
CREATE TABLE employee (
    emp_id SERIAL PRIMARY KEY,
    fname VARCHAR(20) NOT NULL,
    lname VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    superior_emp_id INTEGER,
    dept_id INTEGER,
    title VARCHAR(20),
    assigned_branch_id INTEGER,
    CONSTRAINT fk_e_emp_id FOREIGN KEY (superior_emp_id) REFERENCES employee (emp_id),
    CONSTRAINT fk_dept_id FOREIGN KEY (dept_id) REFERENCES department (dept_id),
    CONSTRAINT fk_e_branch_id FOREIGN KEY (assigned_branch_id) REFERENCES branch (branch_id)
);

-- Table creation for product_type
CREATE TABLE product_type (
    product_type_cd VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

-- Table creation for product
CREATE TABLE product (
    product_cd VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    product_type_cd VARCHAR(10) NOT NULL,
    date_offered DATE,
    date_retired DATE,
    CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd) REFERENCES product_type (product_type_cd)
);

-- Table creation for customer
CREATE TABLE customer (
    cust_id SERIAL PRIMARY KEY,
    fed_id VARCHAR(12) NOT NULL,
    cust_type_cd CHAR(1) NOT NULL,
    address VARCHAR(30),
    city VARCHAR(20),
    state VARCHAR(20),
    postal_code VARCHAR(10)
);

-- Table creation for individual
CREATE TABLE individual (
    cust_id INTEGER PRIMARY KEY,
    fname VARCHAR(30) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    birth_date DATE,
    CONSTRAINT fk_i_cust_id FOREIGN KEY (cust_id) REFERENCES customer (cust_id)
);

-- Table creation for business
CREATE TABLE business (
    cust_id INTEGER PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    state_id VARCHAR(10) NOT NULL,
    incorp_date DATE,
    CONSTRAINT fk_b_cust_id FOREIGN KEY (cust_id) REFERENCES customer (cust_id)
);

-- Table creation for officer
CREATE TABLE officer (
    officer_id SERIAL PRIMARY KEY,
    cust_id INTEGER NOT NULL,
    fname VARCHAR(30) NOT NULL,
    lname VARCHAR(30) NOT NULL,
    title VARCHAR(20),
    start_date DATE NOT NULL,
    end_date DATE,
    CONSTRAINT fk_o_cust_id FOREIGN KEY (cust_id) REFERENCES business (cust_id)
);

-- Table creation for account
CREATE TABLE account (
    account_id SERIAL PRIMARY KEY,
    product_cd VARCHAR(10) NOT NULL,
    cust_id INTEGER NOT NULL,
    open_date DATE NOT NULL,
    close_date DATE,
    last_activity_date DATE,
    status VARCHAR(10),
    open_branch_id INTEGER,
    open_emp_id INTEGER,
    avail_balance NUMERIC(10,2),
    pending_balance NUMERIC(10,2),
    CONSTRAINT fk_product_cd FOREIGN KEY (product_cd) REFERENCES product (product_cd),
    CONSTRAINT fk_a_cust_id FOREIGN KEY (cust_id) REFERENCES customer (cust_id),
    CONSTRAINT fk_a_branch_id FOREIGN KEY (open_branch_id) REFERENCES branch (branch_id),
    CONSTRAINT fk_a_emp_id FOREIGN KEY (open_emp_id) REFERENCES employee (emp_id)
);

-- Table creation for transaction
CREATE TABLE transaction (
    txn_id SERIAL PRIMARY KEY,
    txn_date TIMESTAMP NOT NULL,
    account_id INTEGER NOT NULL,
    txn_type_cd CHAR(3),
    amount NUMERIC(10,2) NOT NULL,
    teller_emp_id INTEGER,
    execution_branch_id INTEGER,
    funds_avail_date TIMESTAMP,
    CONSTRAINT fk_t_account_id FOREIGN KEY (account_id) REFERENCES account (account_id),
    CONSTRAINT fk_teller_emp_id FOREIGN KEY (teller_emp_id) REFERENCES employee (emp_id),
    CONSTRAINT fk_exec_branch_id FOREIGN KEY (execution_branch_id) REFERENCES branch (branch_id)
);


-- Department data
INSERT INTO department (name)
VALUES ('Operations'),
       ('Loans'),
       ('Administration');

-- Branch data
INSERT INTO branch (name, address, city, state, zip)
VALUES ('Headquarters', '3882 Main St.', 'Waltham', 'MA', '02451'),
       ('Woburn Branch', '422 Maple St.', 'Woburn', 'MA', '01801'),
       ('Quincy Branch', '125 Presidential Way', 'Quincy', 'MA', '02169'),
       ('So. NH Branch', '378 Maynard Ln.', 'Salem', 'NH', '03079');


-- Employee data
INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Michael', 'Smith', '2001-06-22', d.dept_id, 'President', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Administration';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Susan', 'Barker', '2002-09-12', d.dept_id, 'Vice President', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Administration';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Robert', 'Tyler', '2000-02-09', d.dept_id, 'Treasurer', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Administration';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Susan', 'Hawthorne', '2002-04-24', d.dept_id, 'Operations Manager', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'John', 'Gooding', '2003-11-14', d.dept_id, 'Loan Manager', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Loans';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Helen', 'Fleming', '2004-03-17', d.dept_id, 'Head Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Chris', 'Tucker', '2004-09-15', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Sarah', 'Parker', '2002-12-02', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Jane', 'Grossman', '2002-05-03', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Headquarters'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Paula', 'Roberts', '2002-07-27', d.dept_id, 'Head Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Woburn Branch'
WHERE d.name = 'Operations';

-- Employee data
INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Thomas', 'Ziegler', '2000-10-23', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Woburn Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Samantha', 'Jameson', '2003-01-08', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Woburn Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'John', 'Blake', '2000-05-11', d.dept_id, 'Head Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Quincy Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Cindy', 'Mason', '2002-08-09', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Quincy Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Frank', 'Portman', '2003-04-01', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'Quincy Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Theresa', 'Markham', '2001-03-15', d.dept_id, 'Head Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'So. NH Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Beth', 'Fowler', '2002-06-29', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'So. NH Branch'
WHERE d.name = 'Operations';

INSERT INTO employee (fname, lname, start_date, dept_id, title, assigned_branch_id)
SELECT 'Rick', 'Tulman', '2002-12-12', d.dept_id, 'Teller', b.branch_id
FROM department d
JOIN branch b ON b.name = 'So. NH Branch'
WHERE d.name = 'Operations';




-- Create temporary table for employee data
CREATE TEMPORARY TABLE emp_tmp AS
SELECT emp_id, fname, lname FROM employee;

-- Update superior_emp_id based on employee names
UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Smith' AND fname = 'Michael'
)
WHERE (lname = 'Barker' AND fname = 'Susan')
   OR (lname = 'Tyler' AND fname = 'Robert');

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Tyler' AND fname = 'Robert'
)
WHERE lname = 'Hawthorne' AND fname = 'Susan';

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Hawthorne' AND fname = 'Susan'
)
WHERE (lname = 'Gooding' AND fname = 'John')
   OR (lname = 'Fleming' AND fname = 'Helen')
   OR (lname = 'Roberts' AND fname = 'Paula') 
   OR (lname = 'Blake' AND fname = 'John') 
   OR (lname = 'Markham' AND fname = 'Theresa'); 

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Fleming' AND fname = 'Helen'
)
WHERE (lname = 'Tucker' AND fname = 'Chris') 
   OR (lname = 'Parker' AND fname = 'Sarah') 
   OR (lname = 'Grossman' AND fname = 'Jane');  

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Roberts' AND fname = 'Paula'
)
WHERE (lname = 'Ziegler' AND fname = 'Thomas')  
   OR (lname = 'Jameson' AND fname = 'Samantha');   

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Blake' AND fname = 'John'
)
WHERE (lname = 'Mason' AND fname = 'Cindy')   
   OR (lname = 'Portman' AND fname = 'Frank');    

UPDATE employee
SET superior_emp_id = (
    SELECT emp_id FROM emp_tmp WHERE lname = 'Markham' AND fname = 'Theresa'
)
WHERE (lname = 'Fowler' AND fname = 'Beth')   
   OR (lname = 'Tulman' AND fname = 'Rick');    

-- Drop temporary table
DROP TABLE emp_tmp;


-- Product type data
INSERT INTO product_type (product_type_cd, name)
VALUES ('ACCOUNT', 'Customer Accounts'),
       ('LOAN', 'Individual and Business Loans'),
       ('INSURANCE', 'Insurance Offerings');


-- Product data
INSERT INTO product (product_cd, name, product_type_cd, date_offered)
VALUES ('CHK', 'checking account', 'ACCOUNT', '2000-01-01'),
       ('SAV', 'savings account', 'ACCOUNT', '2000-01-01'),
       ('MM', 'money market account', 'ACCOUNT', '2000-01-01'),
       ('CD', 'certificate of deposit', 'ACCOUNT', '2000-01-01'),
       ('MRT', 'home mortgage', 'LOAN', '2000-01-01'),
       ('AUT', 'auto loan', 'LOAN', '2000-01-01'),
       ('BUS', 'business line of credit', 'LOAN', '2000-01-01'),
       ('SBL', 'small business loan', 'LOAN', '2000-01-01');

-- Residential customer data
WITH inserted_customers AS (
    INSERT INTO customer (fed_id, cust_type_cd, address, city, state, postal_code)
    VALUES 
    ('111-11-1111', 'I', '47 Mockingbird Ln', 'Lynnfield', 'MA', '01940'),
    ('222-22-2222', 'I', '372 Clearwater Blvd', 'Woburn', 'MA', '01801'),
    ('333-33-3333', 'I', '18 Jessup Rd', 'Quincy', 'MA', '02169'),
    ('444-44-4444', 'I', '12 Buchanan Ln', 'Waltham', 'MA', '02451'),
    ('555-55-5555', 'I', '2341 Main St', 'Salem', 'NH', '03079'),
    ('666-66-6666', 'I', '12 Blaylock Ln', 'Waltham', 'MA', '02451'),
    ('777-77-7777', 'I', '29 Admiral Ln', 'Wilmington', 'MA', '01887'),
    ('888-88-8888', 'I', '472 Freedom Rd', 'Salem', 'NH', '03079'),
    ('999-99-9999', 'I', '29 Maple St', 'Newton', 'MA', '02458')
    RETURNING cust_id, fed_id
)
INSERT INTO individual (cust_id, fname, lname, birth_date)
SELECT ic.cust_id, vals.fname, vals.lname, vals.birth_date::date
FROM inserted_customers ic
JOIN (
    VALUES 
    ('111-11-1111', 'James', 'Hadley', '1972-04-22'::date),
    ('222-22-2222', 'Susan', 'Tingley', '1968-08-15'::date),
    ('333-33-3333', 'Frank', 'Tucker', '1958-02-06'::date),
    ('444-44-4444', 'John', 'Hayward', '1966-12-22'::date),
    ('555-55-5555', 'Charles', 'Frasier', '1971-08-25'::date),
    ('666-66-6666', 'John', 'Spencer', '1962-09-14'::date),
    ('777-77-7777', 'Margaret', 'Young', '1947-03-19'::date),
    ('888-88-8888', 'Louis', 'Blake', '1977-07-01'::date),
    ('999-99-9999', 'Richard', 'Farley', '1968-06-16'::date)
) AS vals (fed_id, fname, lname, birth_date) ON ic.fed_id = vals.fed_id;

-- Corporate customer data
WITH inserted_customers AS (
    INSERT INTO customer (fed_id, cust_type_cd, address, city, state, postal_code)
    VALUES 
    ('04-1111111', 'B', '7 Industrial Way', 'Salem', 'NH', '03079'),
    ('04-2222222', 'B', '287A Corporate Ave', 'Wilmington', 'MA', '01887'),
    ('04-3333333', 'B', '789 Main St', 'Salem', 'NH', '03079'),
    ('04-4444444', 'B', '4772 Presidential Way', 'Quincy', 'MA', '02169')
    RETURNING cust_id, fed_id
)
INSERT INTO business (cust_id, name, state_id, incorp_date)
SELECT ic.cust_id, vals.name, vals.state_id::varchar, vals.incorp_date::date
FROM (
    VALUES 
    ('04-1111111', 'Chilton Engineering', '12-345-678', '1995-05-01'),
    ('04-2222222', 'Northeast Cooling Inc.', '23-456-789', '2001-01-01'),
    ('04-3333333', 'Superior Auto Body', '34-567-890', '2002-06-30'),
    ('04-4444444', 'AAA Insurance Inc.', '45-678-901', '1999-05-01')
) AS vals (fed_id, name, state_id, incorp_date) 
JOIN inserted_customers ic ON ic.fed_id = vals.fed_id;


-- Residential account data
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Woburn'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2000-01-15', '2005-01-04', 1057.75, 1057.75),
    ('SAV', '2000-01-15', '2004-12-19', 500.00, 500.00),
    ('CD', '2004-06-30', '2004-06-30', 3000.00, 3000.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '111-11-1111';

-- Insert for customer '222-22-2222'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Woburn'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2001-03-12'::date, '2004-12-27'::date, 2258.02, 2258.02),
    ('SAV', '2001-03-12'::date, '2004-12-11'::date, 200.00, 200.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '222-22-2222';

-- Insert for customer '333-33-3333'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Quincy'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2002-11-23'::date, '2004-11-30'::date, 1057.75, 1057.75),
    ('MM', '2002-12-15'::date, '2004-12-05'::date, 2212.50, 2212.50)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '333-33-3333';

-- Insert for customer '444-44-4444'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Waltham'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2003-09-12'::date, '2005-01-03'::date, 534.12, 534.12),
    ('SAV', '2000-01-15'::date, '2004-10-24'::date, 767.77, 767.77),
    ('MM', '2004-09-30'::date, '2004-11-11'::date, 5487.09, 5487.09)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '444-44-4444';

-- Insert for customer '555-55-5555'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Salem'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2004-01-27'::date, '2005-01-05'::date, 2237.97, 2897.97)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '555-55-5555';

-- Insert for customer '666-66-6666'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Waltham'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2002-08-24'::date, '2004-11-29'::date, 122.37, 122.37),
    ('CD', '2004-12-28'::date, '2004-12-28'::date, 10000.00, 10000.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '666-66-6666';

-- Insert for customer '777-77-7777'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Woburn'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CD', '2004-01-12'::date, '2004-01-12'::date, 5000.00, 5000.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '777-77-7777';

-- Insert for customer '888-88-8888'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Salem'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2001-05-23'::date, '2005-01-03'::date, 3487.19, 3487.19),
    ('SAV', '2001-05-23'::date, '2004-10-12'::date, 387.99, 387.99)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '888-88-8888';

-- Insert for customer '999-99-9999'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Waltham'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2003-07-30'::date, '2004-12-15'::date, 125.67, 125.67),
    ('MM', '2004-10-28'::date, '2004-10-28'::date, 9345.55, 9845.55),
    ('CD', '2004-06-30'::date, '2004-06-30'::date, 1500.00, 1500.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '999-99-9999';

-- Corporate account data for customer '04-1111111'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Salem'
    LIMIT 1
) e
CROSS JOIN (
    VALUES 
    ('CHK', '2002-09-30'::date, '2004-12-15'::date, 23575.12, 23575.12),
    ('BUS', '2002-10-01'::date, '2004-08-28'::date, 0, 0)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '04-1111111';

-- Corporate account data for customer '04-2222222'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Woburn'
    LIMIT 1
) e
CROSS JOIN (
    VALUES ('BUS', '2004-03-22'::date, '2004-11-14'::date, 9345.55, 9345.55)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '04-2222222';

-- Corporate account data for customer '04-3333333'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Salem'
    LIMIT 1
) e
CROSS JOIN (
    VALUES ('CHK', '2003-07-30'::date, '2004-12-15'::date, 38552.05, 38552.05)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '04-3333333';

-- Corporate account data for customer '04-4444444'
INSERT INTO account (product_cd, cust_id, open_date, last_activity_date, status, open_branch_id, open_emp_id, avail_balance, pending_balance)
SELECT a.prod_cd, c.cust_id, a.open_date::date, a.last_date::date, 'ACTIVE', e.branch_id, e.emp_id, a.avail, a.pend
FROM customer c
CROSS JOIN (
    SELECT b.branch_id, e.emp_id 
    FROM branch b
    INNER JOIN employee e ON e.assigned_branch_id = b.branch_id
    WHERE b.city = 'Quincy'
    LIMIT 1
) e
CROSS JOIN (
    VALUES ('SBL', '2004-02-22'::date, '2004-12-17'::date, 50000.00, 50000.00)
) AS a(prod_cd, open_date, last_date, avail, pend)
WHERE c.fed_id = '04-4444444';

-- Put $100 in all checking/savings accounts on date account opened
INSERT INTO transaction (txn_date, account_id, txn_type_cd, amount, funds_avail_date)
SELECT a.open_date, a.account_id, 'CDT', 100, a.open_date
FROM account a
WHERE a.product_cd IN ('CHK', 'SAV', 'CD', 'MM');

-- End data population
