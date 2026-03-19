drop table client;
drop table stock;
drop table trading;
drop table purch;
--
-- create tables
--
Create table client (clno char(3), name varchar(12), address varchar(30), primary key(clno));
Create table stock (company char(7), price number(6,2), dividend number(4,2), eps 
number(4,2), primary key(company));
Create table trading(company char(7), exchange varchar(12), primary key(company, 
exchange), foreign key(company) references stock);
Create table purch (clno char(3), company char(7), pdate date, qty number(6), price 
number(6,2), primary key(clno, company, pdate), foreign key(clno) references client, foreign 
key(company) references stock);
--
-- insert rows
--
Insert into client values ('c01', 'John Smith', '3 East Av, Bentley, WA 6102');
Insert into client values ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001');
Insert into stock values ('BHP', 10.5, 1.5, 3.2);
Insert into stock values ('IBM', 70.0, 4.25, 10.0);
Insert into stock values ('INTEL', 76.5, 5, 12.4);
Insert into stock values ('FORD', 40, 2, 8.5);
Insert into stock values ('GM', 60, 2.5, 9.2);
Insert into stock values ('INFOSYS', 45, 3, 7.8);
Insert into trading values ('BHP', 'Sydney');
Insert into trading values ('BHP', 'New York');
Insert into trading values ('IBM', 'New York');
Insert into trading values ('IBM', 'London');
Insert into trading values ('IBM', 'Tokyo');
Insert into trading values ('INTEL', 'New York');
Insert into trading values ('INTEL', 'London');
Insert into trading values ('FORD', 'New York');
Insert into trading values ('GM', 'New York');
Insert into trading values ('INFOSYS', 'New York');
Insert into purch values ('c01', 'BHP', '02-OCT-2001', 1000,12);
Insert into purch values ('c01', 'BHP', '08-JUN-2002', 2000, 10.50);
Insert into purch values ('c01', 'IBM', '12-FEB-2000', 500, 58);
Insert into purch values ('c01', 'IBM', '10-APR-2001', 1200, 65);
Insert into purch values ('c01', 'INFOSYS', '11-AUG-2001', 1000, 64);
Insert into purch values ('c02', 'INTEL', '30-JAN-2000', 300, 35);
Insert into purch values ('c02', 'INTEL', '30-JAN-2001', 400, 54);
Insert into purch values ('c02', 'INTEL', '02-OCT-2001', 200, 60);
Insert into purch values ('c02', 'FORD', '05-OCT-1999', 300, 40);
Insert into purch values ('c02', 'GM', '12-DEC-2000', 500, 55.5);

