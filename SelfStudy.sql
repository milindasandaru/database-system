-- Tutorial 01. Create the object types and tables

-- CREATE TYPE dept_t;
-- /

-- CREATE TYPE emp_t AS OBJECT(
-- 	eno NUMBER(4),
-- 	ename VARCHAR2(12),
-- 	edept REF dept_t,
-- 	salary NUMBER(8, 2)
-- );
-- /

-- CREATE TYPE dept_t AS OBJECT(
-- 	dno NUMBER(2),
-- 	dname VARCHAR2(12),
-- 	mgr REF emp_t
-- );
-- /

-- CREATE TYPE proj_t AS OBJECT(
-- 	pno NUMBER(4),
-- 	pname VARCHAR2(15),
-- 	pdept REF dept_t,
-- 	budget NUMBER(10, 2)
-- );
-- /

-- CREATE TABLE emp OF emp_t(
-- 	eno PRIMARY KEY,
-- 	edept REFERENCES dept
-- );
-- CREATE TABLE dept OF dept_t(
-- 	dno PRIMARY KEY,
-- 	mgr REFERENCES emp
-- );
-- CREATE TABLE proj OF proj_t(
-- 	pno PRIMARY KEY,
-- 	pdept REFERENCES dept
-- );

-- INSERT INTO dept VALUES(01, 'IT Department', NULL);

-- INSERT INTO emp VALUES(0001, 'Tanisha Perera', (SELECT REF(d) FROM dept d WHERE dno = 1), 80000);

-- UPDATE dept
-- SET mgr = (SELECT REF(e) FROM emp e WHERE eno = 0001) 
-- WHERE dno = 1;

-- SELECT  d.dno
-- 	d.mgr.ename,
-- 	d.mgr.salary
-- FROM dept d;

-- SELECT p.pname,
-- 	p.pdept.mgr.ename
-- FROM proj p
-- WHERE p.budget > 50000;

-- SELECT p.pdept.dno,
-- 	p.pdept.dname,
-- 	SUM(p.budget)
-- FROM proj p
-- GROUP BY p.pdept.dno, p.pdept.dname;

-- SELECT p.pdept.mgr.ename
-- FROM proj p
-- WHERE p.budget = (SELECT MAX(budget) FROM proj);

-- SELECT p.pdet.mgr.enO
-- 	SUM(p.budget)
-- FROM proj p
-- GROUP BY p.pdept.mgr.eno
-- HAVING SUM(p.budget) > 60000;

-- SELECT 
--     p.pdept.mgr.eno, 
--     SUM(p.budget)
-- FROM proj p
-- GROUP BY p.pdept.mgr.eno
-- HAVING SUM(p.budget) = (
--     SELECT MAX(SUM(budget)) 
--     FROM proj 
--     GROUP BY p.pdept.mgr.eno
-- );



-- Tutorial 02. Create the object types and tables


-- LAB Sheet 01

CREATE TABLE client(
	clno CHAR(3) PRIMARY KEY,
	name VARCHAR(12),
	address VARCHAR(30)
);

CREATE TABLE stock(
	company CHAR(7) PRIMARY KEY,
	price NUMBER(6, 2),
	dividend NUMBER(4, 2),
	eps NUMBER(4, 2)
);

CREATE TABLE trading(
	cmpany CHAR(7),
	exchange VARCHAR(12),
	PRIMARY KEY(company, exchange),
	FOREIGN KEY (company) REFERENCES stock(company)
);

CREATE TABLE purchase(
	clno CHAR(3),
	company CHAR(7),
	pdate DATE,
	qty NUMBER(6),
	price NUMBER(6, 2),
	PRIMARY KEY(clno, company, pdate),
	FOREIGN KEY(clno) REFERENCES client(clno),
	FOREIGN KEY (company) REFERENCES stock(company)
);

INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley, WA 6102');
INSERT INTO client VALUES ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001');

INSERT INTO stock VALUES('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES('INTEL', 76.50, 5.00, 12.40);
INSERT INTO stock VALUES('FORD', 40.00, 2.00, 8.50); 
INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80);

INSERT INTO trading VALUES ('BHP', 'Sydney');
INSERT INTO trading VALUES ('BHP', 'New York');
INSERT INTO trading VALUES ('IBM', 'New York');
INSERT INTO trading VALUES ('IBM', 'London');
INSERT INTO trading VALUES ('IBM', 'Tokyo');
INSERT INTO trading VALUES ('INTEL', 'New York');
INSERT INTO trading VALUES ('INTEL', 'London');
INSERT INTO trading VALUES ('FORD', 'New York');
INSERT INTO trading VALUES ('GM', 'New York');
INSERT INTO trading VALUES ('INFOSYS', 'New York');

INSERT INTO purchase VALUES ('c01', 'BHP', '02-OCT-2001', 1000, 12.00);
INSERT INTO purchase VALUES ('c01', 'BHP', '08-JUN-2002', 2000, 10.50);
INSERT INTO purchase VALUES ('c01', 'IBM', '12-FEB-2000', 500, 58.00);
INSERT INTO purchase VALUES ('c01', 'IBM', '10-APR-2001', 1200, 65.00);
INSERT INTO purchase VALUES ('c01', 'INFOSYS', '11-AUG-2001', 1000, 64.00);

INSERT INTO purchase VALUES ('c02', 'INTEL', '30-JAN-2000', 300, 35.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', '30-JAN-2001', 400, 54.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', '02-OCT-2001', 200, 60.00);
INSERT INTO purchase VALUES ('c02', 'FORD', '05-OCT-1999', 300, 40.00);
INSERT INTO purchase VALUES ('c02', 'GM', '12-DEC-2000', 500, 55.50);

-- a. 
SELECT c.name, s.company, s.price AS current_price, s.dividend AS last_dividend, s.eps
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company;

-- b.
SELECT c.name, p.company, SUM(p.qty) AS total_shares, SUM(p.qty * p.price) / SUM(p.qty) AS average_price
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name, p.company;

-- c.
SELECT s.company, c.name, SUM(p.qty) AS number_of_shares, SUM(p.qty * s.price) AS current_value
FROM trading t
JOIN stock s ON t.company = s.company
JOIN purchase p ON s.company = p.company
JOIN client c ON p.clno = c.clno
WHERE t.exchange = 'New York'
GROUP BY s.company, c.name, s.price;

-- d.
SELECT c.name, SUM(p.qty * p.price) AS total_portfolio_purchase_value
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name;

-- e.
SELECT c.name, 
       (SUM(p.qty * s.price) - SUM(p.qty * p.price)) AS book_profit
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company
GROUP BY c.name;



-- LAB Sheet 02
CREATE TYPE dept_t;
/

CREATE TYPE emp_t AS OBJECT(
	empno CHAR(6),
	firstname VARCHAR2(12),
	lastname VARCHAR2(15),
	workdept REF dept_t,
	sex CHAR(1),
	birthdate DATE,
	salary NUMBER(8, 2)
);
/

CREATE OR REPLACE TYPE dept_t AS OBJECT(
	deptno CHAR(3),
	deptname VARCHAR2(36),
	mgrno REF emp_t,
	admrdept CHAR(3)
);
/

CREATE TABLE oremp OF emp_t(
	PRIMARY KEY (empno)
);

CREATE TABLE ORDEPT OF dept_t(
	PRIMARY KEY (deptno)
);

INSERT ALL
  INTO ORDEPT VALUES (dept_t('A00','SPIFFY COMPUTER SERVICE DIV.',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('B01','PLANNING',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('C01','INFORMATION CENTRE',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('D01','DEVELOPMENT CENTRE',NULL,NULL))
SELECT * FROM dual;

INSERT INTO OREMP 
SELECT emp_t('000020', 'MICHAEL', 'THOMPSON',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'B01'),
    'M', '02/FEB/68', 61250) FROM dual
UNION ALL
SELECT emp_t('000030', 'SALLY', 'KWAN',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'C01'),
    'F', '11/MAY/71 ', 58250) FROM dual
UNION ALL
SELECT emp_t('000060', 'IRVING', 'STERN',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'D01'),
    'M', '07/JUL/65', 55555) FROM dual
UNION ALL
SELECT emp_t('000070', 'EVA', 'PULASKI',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'D01'),
    'F', '26/MAY/73', 56170) FROM dual
UNION ALL
SELECT emp_t('000050', 'JOHN', 'GEYER',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'C01'),
    'M', '15/SEP/55', 60175) FROM dual
UNION ALL
SELECT emp_t('000090', 'EILEEN', 'HENDERSON',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'B01'),
    'F', '15/MAY/61', 49750) FROM dual
UNION ALL
SELECT emp_t('000100', 'THEODORE', 'SPENSER',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'B01'),
    'M', '18/DEC/76', 46150) FROM dual;

UPDATE ORDEPT d 
SET d.mgrno = (SELECT REF(e) FROM OREMP e WHERE empno = '000010') 
WHERE d.deptno = 'A00';

UPDATE ORDEPT d 
SET d.mgrno = (SELECT REF(e) FROM OREMP e WHERE empno = '000020') 
WHERE d.deptno = 'B01';

UPDATE ORDEPT d 
SET d.mgrno = (SELECT REF(e) FROM OREMP e WHERE empno = '000030') 
WHERE d.deptno = 'C01';

UPDATE ORDEPT d 
SET d.mgrno = (SELECT REF(e) FROM OREMP e WHERE empno = '000060') 
WHERE d.deptno = 'D01';

-- a.
SELECT d.deptname, d.mgrno.lastname AS manager_lastname
from ordept d;

-- b.
SELECT e.empno, e.lastname, e.workdept.deptname AS department_name
FROM oremp e;

-- c.
SELECT d.deptno, d.deptname, d.admrdept AS admin_dept
FROM ORDEPT d;

-- d.
SELECT
    d.deptno,
    d.deptname,
    d.admrdept.deptname AS admin_dept_name, 
    d.mgrno.lastname AS admin_dept_manager
FROM ORDEPT d; 

-- e.
SELECT 
    e.empno, 
    e.firstname, 
    e.lastname, 
    e.salary, 
    e.workdept.mgrno.lastname AS manager_name, 
    e.workdept.mgrno.salary AS manager_salary
FROM OREMP e;

-- f.
SELECT e.workdept.deptno, e.workdept.deptname, e.sex, AVG(e.salary)
FROM OREMP e
GROUP BY e.workdept.deptno, e.workdept.deptname, e.sex;