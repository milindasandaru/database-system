-- IT23284784
-- Senarath S.A.M.S
-- Lab Sheet 03

-- 1. Create the array type for exchanges
CREATE TYPE excharray AS VARRAY(10) OF VARCHAR2(15);
/

-- 2. Create the stock object type
CREATE OR REPLACE TYPE stocks_t AS OBJECT (
    cname VARCHAR2(12),
    cprice NUMBER(6, 2),
    exchanges excharray,
    dividend NUMBER(4, 2),
    earnings NUMBER(6, 2)
);
/

-- 3. Create the stock table
CREATE TABLE stocks OF stocks_t (
    PRIMARY KEY (cname)
);

-- 4. Insert data into stock table
INSERT INTO stocks VALUES (
    'BHP', 10.50, excharray('Sydney', 'New York'), 1.50, 3.20 
) ;

-- 5. Create the array type for address
CREATE TYPE address_t AS OBJECT (
    street_no VARCHAR2(10),
    street_name VARCHAR2(20),
    suburb VARCHAR2(20),
    state VARCHAR2(10),
    pin VARCHAR2(10)
);
/

-- 6. Create the investments object type
CREATE TYPE investment_t AS OBJECT (
    company_ref REF stocks_t,
    price NUMBER(6, 2),
    pdate DATE,
    qty NUMBER(6)
);
/

-- 7. Create investment list
CREATE TYPE investment_list_t AS TABLE OF investment_t;
/

-- 8. Create client object
CREATE TYPE client_t AS OBJECT (
    clno CHAR(3),
    name VARCHAR2(20),
    address address_t,
    investments investment_list_t
);
/
-- 9. Create the client table
CREATE TABLE clients OF client_t (
    PRIMARY KEY (clno)
) NESTED TABLE investments STORE AS client_invest_table;

-- 10. Fill the stock table
INSERT INTO stocks VALUES ('IBM', 70.00, excharray('New York', 'London', 'Tokyo'), 4.25, 10.00);
INSERT INTO stocks VALUES ('INTEL', 76.50, excharray('New York', 'London'), 5.00, 12.40);
INSERT INTO stocks VALUES ('FORD', 40.00, excharray('New York'), 2.00, 8.50);
INSERT INTO stocks VALUES ('GM', 60.00, excharray('New York'), 2.50, 9.20);
INSERT INTO stocks VALUES ('INFOSYS', 45.00, excharray('New York'), 3.00, 7.80);

-- 11. Insert client "john smith"
INSERT INTO clients VALUES (    
    'c01',
    'John Smith',

    -- insert the address object
    address_t('3', 'East Av', 'Bentley', 'WA', '6102'),

    -- insert the nested table data
    investment_list_t(
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='BHP'), 12.00, '02-OCT-2001', 1000),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='BHP'), 10.50, '08-JUN-2002', 2000),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='IBM'), 58.00, '12-FEB-2000', 500),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='IBM'), 65.00, '10-APR-2001', 1200),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='INFOSYS'), 64.00, '11-AUG-2001', 1000)
    )
);

-- 12. Insert client "jill brody"
INSERT INTO clients VALUES (
    'c02',
    'Jill Brody',

    -- insert the address object
    address_t('42', 'Bent St', 'Perth', 'WA', '6001'),

    -- insert the nested table data
    investment_list_t(
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='INTEL'), 35.00, '30-JAN-2000', 300),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='INTEL'), 54.00, '30-JAN-2001', 400),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='INTEL'), 60.00, '02-OCT-2001', 200),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='FORD'), 40.00, '05-OCT-1999', 300),
        investment_t((SELECT REF(s) FROM stocks s WHERE cname='GM'), 55.50, '12-DEC-2000', 500)
    )
);

-- CLEANUP SCRIPT (Deletes everything)
DROP TABLE clients PURGE;
DROP TABLE stocks PURGE;
DROP TYPE client_t FORCE;
DROP TYPE investment_list_t FORCE;
DROP TYPE investment_t FORCE;
DROP TYPE address_t FORCE;
DROP TYPE stocks_t FORCE;
DROP TYPE excharray FORCE;

-- Questions
--(a): client investment lists
SELECT 
    c.name AS client_name, 
    t.company_ref.cname AS stock_name, 
    t.company_ref.cprice AS current_price, 
    t.company_ref.dividend AS last_dividend, 
    t.company_ref.earnings AS eps
FROM clients c, TABLE(c.investments) t;

--(b): portfolio summary
SELECT 
    c.name AS client_name, 
    t.company_ref.cname AS stock_name, 
    SUM(t.qty) AS total_shares,
    SUM(t.qty * t.price) / SUM(t.qty) AS avg_purchase_price
FROM clients c, TABLE(c.investments) t
GROUP BY c.name, t.company_ref.cname;

--(c): new york companies
SELECT 
    t.company_ref.cname AS stock_name, 
    c.name AS client_name, 
    t.qty AS shares_held, 
    (t.qty * t.company_ref.cprice) AS current_value
FROM clients c, TABLE(c.investments) t
WHERE 'New York' IN (SELECT * FROM TABLE(t.company_ref.exchanges));

--(d): total purchase values
SELECT 
    c.name, 
    SUM(t.qty * t.price) AS total_purchase_value
FROM clients c, TABLE(c.investments) t
GROUP BY c.name;

--(e): book profit on total share
SELECT 
    c.name, 
    (SUM(t.qty * t.company_ref.cprice) - SUM(t.qty * t.price)) AS book_profit
FROM clients c, TABLE(c.investments) t
GROUP BY c.name;

-- 1. John sells INFOSYS
DELETE FROM TABLE(SELECT investments FROM clients WHERE name = 'John Smith') t
WHERE t.company_ref.cname = 'INFOSYS';

-- 2. Jill buys INFOSYS
INSERT INTO TABLE(SELECT investments FROM clients WHERE name = 'Jill Brody')
VALUES (
    investment_t(
        (SELECT REF(s) FROM stocks s WHERE cname='INFOSYS'), 
        (SELECT cprice FROM stocks WHERE cname='INFOSYS'), 
        SYSDATE, 
        1000
    )
);

-- 3. Jill sells GM
DELETE FROM TABLE(SELECT investments FROM clients WHERE name = 'Jill Brody') t
WHERE t.company_ref.cname = 'GM';

-- 4. John buys GM
INSERT INTO TABLE(SELECT investments FROM clients WHERE name = 'John Smith')
VALUES (
    investment_t(
        (SELECT REF(s) FROM stocks s WHERE cname='GM'), 
        (SELECT cprice FROM stocks WHERE cname='GM'), 
        SYSDATE, 
        500 
    )
);

-- Check who owns what now
SELECT c.name, t.company_ref.cname 
FROM clients c, TABLE(c.investments) t
WHERE t.company_ref.cname IN ('INFOSYS', 'GM');
