-- Tutorial 01. Create the object types and tables

CREATE TYPE dept_t;
/

CREATE TYPE emp_t AS OBJECT(
	eno NUMBER(4),
	ename VARCHAR2(12),
	edept REF dept_t,
	salary NUMBER(8, 2)
);
/

CREATE TYPE dept_t AS OBJECT(
	dno NUMBER(2),
	dname VARCHAR2(12),
	mgr REF emp_t
);
/

CREATE TYPE proj_t AS OBJECT(
	pno NUMBER(4),
	pname VARCHAR2(15),
	pdept REF dept_t,
	budget NUMBER(10, 2)
);
/

CREATE TABLE emp OF emp_t(
	eno PRIMARY KEY,
	edept REFERENCES dept
);
CREATE TABLE dept OF dept_t(
	dno PRIMARY KEY,
	mgr REFERENCES emp
);
CREATE TABLE proj OF proj_t(
	pno PRIMARY KEY,
	pdept REFERENCES dept
);

INSERT INTO dept VALUES(01, 'IT Department', NULL);

INSERT INTO emp VALUES(0001, 'Tanisha Perera', (SELECT REF(d) FROM dept d WHERE dno = 1), 80000);

UPDATE dept
SET mgr = (SELECT REF(e) FROM emp e WHERE eno = 0001) 
WHERE dno = 1;

SELECT  d.dno
	d.mgr.ename,
	d.mgr.salary
FROM dept d;

SELECT p.pname,
	p.pdept.mgr.ename
FROM proj p
WHERE p.budget > 50000;

SELECT p.pdept.dno,
	p.pdept.dname,
	SUM(p.budget)
FROM proj p
GROUP BY p.pdept.dno, p.pdept.dname;

SELECT p.pdept.mgr.ename
FROM proj p
WHERE p.budget = (SELECT MAX(budget) FROM proj);

SELECT p.pdet.mgr.enO
	SUM(p.budget)
FROM proj p
GROUP BY p.pdept.mgr.eno
HAVING SUM(p.budget) > 60000;

SELECT 
    p.pdept.mgr.eno, 
    SUM(p.budget)
FROM proj p
GROUP BY p.pdept.mgr.eno
HAVING SUM(p.budget) = (
    SELECT MAX(SUM(budget)) 
    FROM proj 
    GROUP BY p.pdept.mgr.eno
);



-- Tutorial 02. Create the object types and tables
