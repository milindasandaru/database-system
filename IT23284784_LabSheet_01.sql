--IT23284784
--Senarath S.A.M.S
--Lab Sheet 01

-- 1. Client Table
CREATE TABLE client (
    clno CHAR(3),
    name VARCHAR(12),
    address VARCHAR(30),
    PRIMARY KEY (clno)
);

-- 2. Stock Table
CREATE TABLE stock (
    company CHAR(7),
    price NUMBER(6, 2),
    dividend NUMBER(4, 2),
    eps NUMBER(4, 2),
    PRIMARY KEY (company) 
);

-- 3. Trading Table (Links Company to Exchanges)
CREATE TABLE trading (
    company CHAR(7),
    exchange VARCHAR(12),
    PRIMARY KEY (company, exchange),
    FOREIGN KEY (company) REFERENCES stock(company)
);

-- 4. Purchase Table (Transactions)
CREATE TABLE purchase (
    clno CHAR(3),
    company CHAR(7),
    pdate DATE,
    qty NUMBER(6),
    price NUMBER(6,2), -- This is the PURCHASE price
    PRIMARY KEY (clno, company, pdate),
    FOREIGN KEY (clno) REFERENCES client(clno),
    FOREIGN KEY (company) REFERENCES stock(company)
);

-- Drop Tables
DROP TABLE client; 
DROP TABLE stock; 
DROP TABLE purchase; 
DROP TABLE trading;

-- INSERT CLIENTS
INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley, WA 6102');
INSERT INTO client VALUES ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001');

SELECT * 
FROM client;

-- INSERT STOCKS (Current Market Info)
INSERT INTO stock VALUES ('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES ('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES ('INTEL', 76.50, 5.00, 12.40);
INSERT INTO stock VALUES ('FORD', 40.00, 2.00, 8.50);
INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80);

SELECT * 
FROM stock;

-- INSERT TRADING LOCATIONS
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

SELECT * 
FROM trading;

-- INSERT PURCHASES (History)
-- John Smith (c01)
INSERT INTO purchase VALUES ('c01', 'BHP', '02-OCT-2001', 1000, 12.00);
INSERT INTO purchase VALUES ('c01', 'BHP', '08-JUN-2002', 2000, 10.50);
INSERT INTO purchase VALUES ('c01', 'IBM', '12-FEB-2000', 500, 58.00);
INSERT INTO purchase VALUES ('c01', 'IBM', '10-APR-2001', 1200, 65.00);
INSERT INTO purchase VALUES ('c01', 'INFOSYS', '11-AUG-2001', 1000, 64.00);

-- Jill Brody (c02)
INSERT INTO purchase VALUES ('c02', 'INTEL', '30-JAN-2000', 300, 35.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', '30-JAN-2001', 400, 54.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', '02-OCT-2001', 200, 60.00);
INSERT INTO purchase VALUES ('c02', 'FORD', '05-OCT-1999', 300, 40.00);
INSERT INTO purchase VALUES ('c02', 'GM', '12-DEC-2000', 500, 55.50);

SELECT *
FROM purchase;

-- Questions
--(a): Client Investments List
SELECT c.name, s.company, s.price AS current_price, s.dividend, s.eps
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company;

--(b): Weighted Average Purchase Price
SELECT c.name, p.company, SUM(p.qty) AS total_shares, 
       SUM(p.qty * p.price) / SUM(p.qty) AS avg_purchase_price
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name, p.company;


--(c): New York Holdings & Current Value
SELECT s.company, c.name, SUM(p.qty) AS total_shares, 
       SUM(p.qty) * s.price AS current_value
FROM trading t
JOIN stock s ON t.company = s.company
JOIN purchase p ON s.company = p.company
JOIN client c ON p.clno = c.clno
WHERE t.exchange = 'New York'
GROUP BY s.company, c.name, s.price;

--(d): Total Portfolio Value
SELECT c.name, SUM(p.qty * p.price) AS total_portfolio_purchase_value
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name;

--(e): Book Profit
SELECT c.name, 
       (SUM(p.qty * s.price) - SUM(p.qty * p.price)) AS book_profit
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company
GROUP BY c.name;

