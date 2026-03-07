-- Tutorial 01. Create the object types and tables

CREATE TYPE dept_t;
/

CREATE TYPE emp_t AS OBJECT(
	eno NUMBER(4),
	ename VARCHAR2(15),
	edept REF dept_t, 
	salary NUMBER(8,2)
);
/

CREATE OR REPLACE dept_t AS OBJECT(
	dno NUMBER(2),
	dname VARCHAR2(12),
	mgr REF emp_t
);
/

CREATE TYPE proj_t AS OBJECT(
	pno NUMBER(4),
	pname VARCHAR2(15),
	pdept REF dept_t,
	budget NUMBER(10,2)
);
/

CREATE TABLE employee OF emp_t(
	PRIMARY KEY (eno)
);

CREATE TABLE dept OF dept_t(
	PRIMARY KEY (dno)
);

CREATE TABLE proj OF proj_t(
	PRIMARY KEY (pno)
);

INSERT ALL
	INTO dept VALUES (dept_t( 01, 'PLANNING', NULL));
	INTO dept VALUES (dept_t( 02, 'INFORMATION CENTRE', NULL));
SELECT * FROM dual;

INSERT INTO employee VALUES (emp_t( 
	0001, 
	'Christine Haas', 
	(SELECT REF(d) FROM dept d WHERE dno = 01),
	5000.00)
);

INSERT INTO employee VALUES (emp_t( 
	0002, 
	'Sally Kwan', 
	(SELECT REF(d) FROM dept d WHERE dno = 02),
	8000.00)
);

UPDATE dept d
SET d mgr(SELECT REF(e) FROM employee e WHERE eno=0001 )
WHERE d.dno= 01;

UPDATE dept d
SET d mgr(SELECT REF(e) FROM employee e WHERE eno=0002 )
WHERE d.dno= 02;

-- Best practices with DEREF
SELECT d.dno,
       DEREF(d.mgr).ename AS mgr_name,
       DEREF(d.mgr).salary AS mgr_salary
FROM dept d;

SELECT DEREF(DEREF(p.pdept).mgr).ename AS mgr_name,
       p.pname
FROM proj p
WHERE p.budget > 50000;

SELECT DEREF(p.pdept).dno   AS dept_no,
       DEREF(p.pdept).dname AS dept_name,
       SUM(p.budget)        AS total_budget
FROM proj p
GROUP BY DEREF(p.pdept).dno,
         DEREF(p.pdept).dname;

SELECT DEREF(DEREF(p.pdept).mgr).ename AS mgr_name
FROM proj p
WHERE p.budget = (
    SELECT MAX(budget)
    FROM proj
);

SELECT DEREF(DEREF(p.pdept).mgr).eno AS mgr_no,
       SUM(p.budget) AS total_budget
FROM proj p
GROUP BY DEREF(DEREF(p.pdept).mgr).eno
HAVING SUM(p.budget) > 60000;

SELECT mgr_no, total_budget
FROM (
    SELECT DEREF(DEREF(p.pdept).mgr).eno AS mgr_no,
           SUM(p.budget) AS total_budget
    FROM proj p
    GROUP BY DEREF(DEREF(p.pdept).mgr).eno
)
WHERE total_budget = (
    SELECT MAX(total_budget)
    FROM (
        SELECT SUM(p.budget) AS total_budget
        FROM proj p
        GROUP BY DEREF(DEREF(p.pdept).mgr).eno
    )
);




