--IT23284784
--Senarath S.A.M.S
--Lab Sheet 07

-- step 1: create PLAN_TABLE to store execution plans
@UTLXPLAN.SQL

-- step 2: create tables and insert sample data
@SampleDB.sql

-- step 3: set optimizer session parameters
ALTER SESSION SET OPTIMIZER_MODE = ALL_ROWS;
ALTER SESSION SET "_optimizer_cost_model" = CPU;

-- part (a) – explain plan before indexes
-- query: clients with purchases over 1000 shares
EXPLAIN PLAN FOR
SELECT c.clno, c.name
FROM client c, purch p
WHERE c.clno = p.clno
AND p.qty > 1000;

-- display the plan
@utlxpls.sql

-- part (c) – create indexes for optimization
-- 1. unclustered B+ Tree index on purch(qty, clno)
-- 2. unclustered B+ Tree index on client(clno, name)
CREATE INDEX idx_purch_qty_clno ON purch(qty, clno);
CREATE INDEX idx_client_clno_name ON client(clno, name);

-- optional: verify indexes were created
SELECT index_name, table_name
FROM user_indexes
WHERE table_name IN ('CLIENT', 'PURCH');

-- part (d) – explain plan after indexes
EXPLAIN PLAN FOR
SELECT c.clno, c.name
FROM client c, purch p
WHERE c.clno = p.clno
AND p.qty > 1000;

-- display the updated plan
@utlxpls.sql

-- optional steps

-- 1. drop an index
-- DROP INDEX idx_client_clno_name;

-- 2. check existing indexes on a table
SELECT index_name, table_name
FROM user_indexes
WHERE table_name = 'CLIENT';

-- 3. obtain DDL used to create indexes
SELECT DBMS_METADATA.GET_DDL('INDEX', u.index_name)
FROM user_indexes u
WHERE table_name = 'CLIENT';
