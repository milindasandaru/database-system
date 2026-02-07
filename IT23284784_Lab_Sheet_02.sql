-- IT23284784
-- Senarath S.A.M.S
-- Lab Sheet 02

-- a.
-- 1. Create department declaration first
CREATE TYPE dept_t;
/

-- 2. Create employee type
CREATE TYPE emp_t AS OBJECT (
    empno CHAR(6),
    firstname VARCHAR2(12), -- I used vachar 2 because lecturer mention it
    lastname VARCHAR2(15),
    workdept REF dept_t, 
    sex CHAR(1),
    birthdate DATE,
    salary NUMBER(8, 2)
);
/

-- 3. Create department type
CREATE OR REPLACE TYPE dept_t AS OBJECT (
    deptno CHAR(3),
    deptname VARCHAR2(36),
    mgrno REF emp_t, 
    admrdept REF dept_t 
);
/

-- b.
-- 4. Create OREMP table
CREATE TABLE OREMP OF emp_t (
    PRIMARY KEY (empno)
);

-- 5. Create ORDEPT table
CREATE TABLE ORDEPT OF dept_t (
    PRIMARY KEY (deptno)
);

-- Cleaning the directory
-- DROP TABLE ORDEPT CASCADE CONSTRAINTS;
-- DROP TABLE OREMP CASCADE CONSTRAINTS;
-- DROP TYPE dept_t FORCE;
-- DROP TYPE emp_t FORCE;

-- 6. Insert values for the dept
INSERT ALL
  INTO ORDEPT VALUES (dept_t('A00','SPIFFY COMPUTER SERVICE DIV.',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('B01','PLANNING',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('C01','INFORMATION CENTRE',NULL,NULL))
  INTO ORDEPT VALUES (dept_t('D01','DEVELOPMENT CENTRE',NULL,NULL))
SELECT * FROM dual;

SELECT *
FROM ORDEPT;

-- 7. Insert values for the emp
INSERT INTO OREMP VALUES (
    emp_t('000010', 'CHRISTINE', 'HAAS',
    (SELECT REF(d) FROM ORDEPT d WHERE deptno = 'A00'),
    'F', '01-JAN-1965', 52750)
);

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

SELECT *
FROM OREMP;

-- 8. Update department managers
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


-- Questions
--(a): Get the department name and manager's last name
SELECT d.deptname, d.mgrno.lastname
FROM ORDEPT d;

--(b): Get employee number, last name and department name
SELECT
    e.empno,
    e.lastname,
    e.workdept.deptname AS deptname
FROM OREMP e;

--(c). Get department number, department name and administrative department
SELECT
    d.deptno,
    d.deptname,
    d.admrdept.deptname
FROM ORDEPT d;

--(d). Get department number, department name, name of administrative and last name of the manager
SELECT
    d.deptno,
    d.deptname,
    d.admrdept.deptname AS admin_dept_name, 
    d.mgrno.lastname AS admin_dept_manager
    --d.admrdept.mgrno.lastname AS admin_dept_manager
FROM ORDEPT d;

--(e). Get employee number, firstname, lastname, salary lastname work department
SELECT 
    e.empno, 
    e.firstname, 
    e.lastname, 
    e.salary, 
    e.workdept.mgrno.lastname AS manager_name, 
    e.workdept.mgrno.salary AS manager_salary
FROM OREMP e;

--(f). Get average salary for men and average salary for women
SELECT e.workdept.deptno, e.workdept.deptname, e.sex, AVG(e.salary)
FROM OREMP e
GROUP BY e.workdept.deptno, e.workdept.deptname, e.sex;

