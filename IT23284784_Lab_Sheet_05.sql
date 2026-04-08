-- IT23284784
-- Senarath S.A.M.S
-- Lab Sheet 05

-- example 
DECLARE
    var_cname VARCHAR2(12);
    var_clno CHAR(3) := 'c01';

    BEGIN
        SELECT c.name INTO var_cname
        FROM clients c
        WHERE c.clno = var_clno;

        DBMS_OUTPUT.PUT_LINE('Name of the client with clno: ' || var_clno || ' is ' || var_cname || '.' );
    END;
/


-- 01. retrieve the current price of a stock IBM
DECLARE
    var_cname VARCHAR2(12) := 'IBM';
    var_cprice NUMBER(6, 2);

    BEGIN
        SELECT s.cprice INTO var_cprice
        FROM stocks s
        WHERE s.cname = var_cname;

        DBMS_OUTPUT.PUT_LINE(
            'Company name: ' || var_cname || CHR(10) ||
            'Current price: ' || var_cprice 
        );
    END;
/


-- 02. display a message about IBM stocks
DECLARE 
    var_cprice NUMBER(6,2);

    BEGIN
        SELECT s.cprice INTO var_cprice
        FROM stocks s
        WHERE s.cname = 'IBM';

        IF (var_cprice < 45) THEN
            DBMS_OUTPUT.PUT_LINE('Current price is very low !');
        ELSIF ( var_cprice < 55 ) THEN
            DBMS_OUTPUT.PUT_LINE('Current price is low !');
        ELSIF ( var_cprice < 65 ) THEN
            DBMS_OUTPUT.PUT_LINE('Current price is medium !');
        ELSIF ( var_cprice < 75 ) THEN
            DBMS_OUTPUT.PUT_LINE('Current price is medium high !');
        ELSE 
            DBMS_OUTPUT.PUT_LINE('Current price is high !');
        END IF;
    END;
/


-- 03. make a pattern using 3 type loops
DECLARE
    i_loop NUMBER := 9;
    j_loop NUMBER;

    BEGIN
        FOR i_loop IN REVERSE 1..9 LOOP
            j_loop := 1;

            WHILE j_loop <= i_loop LOOP
                LOOP
                    DBMS_OUTPUT.PUT(i_loop);
                    EXIT WHEN j_loop >= i_loop;
                    j_loop := j_loop + 1;
                END LOOP;
                j_loop := j_loop + 1;
            END LOOP;

            DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END;
/


-- 04. Offer bonus to loyal customers
DECLARE
    v_investments investment_list_t;

    BEGIN
        FOR c_rec IN (SELECT clno, investments FROM clients) LOOP
            v_investments := c_rec.investments;

            FOR i IN 1 .. v_investments.COUNT LOOP
                IF v_investments(i).pdate < TO_DATE('2000-01-01', 'YYYY-MM-DD') THEN
                    v_investments(i).qty := v_investments(i).qty + 150;
                ELSIF v_investments(i).pdate < TO_DATE('2001-01-01', 'YYYY-MM-DD') THEN
                    v_investments(i).qty := v_investments(i).qty + 100;
                ELSIF v_investments(i).pdate < TO_DATE('2002-01-01', 'YYYY-MM-DD') THEN
                    v_investments(i).qty := v_investments(i).qty + 50;
                END IF;
            END LOOP;

        UPDATE clients
        SET investments = v_investments
        WHERE clno = c_rec.clno;
        
        END LOOP;
    END;
/


-- test the update of the stocks
SELECT c.clno,
       c.name,
       i.company_ref.cname AS company,
       i.pdate,
       i.qty
FROM clients c,
     TABLE(c.investments) i
ORDER BY c.clno, i.pdate;


-- 05. explicit cursor to perform the same 4th question
DECLARE
  CURSOR client_cur IS
    SELECT clno, investments
    FROM clients;

    client_rec client_cur%ROWTYPE;
    client_investments investment_list_t;

    BEGIN
    OPEN client_cur;
    FETCH client_cur INTO client_rec;

    WHILE client_cur%FOUND LOOP
    client_investments := client_rec.investments;

        FOR i IN 1 .. client_investments.COUNT LOOP

            IF client_investments(i).pdate < DATE '2000-01-01' THEN
                client_investments(i).qty := client_investments(i).qty + 150;
            ELSIF client_investments(i).pdate < DATE '2001-01-01' THEN
                client_investments(i).qty := client_investments(i).qty + 100;
            ELSIF client_investments(i).pdate < DATE '2002-01-01' THEN
                client_investments(i).qty := client_investments(i).qty + 50;
            END IF;

        END LOOP;

        -- Update modified nested table back
        UPDATE clients
        SET investments = client_investments
        WHERE clno = client_rec.clno;

        FETCH client_cur INTO client_rec;
    END LOOP;
    CLOSE client_cur;
    END;
/

-- test the explicit cursor part
SELECT c.clno,
       c.name,
       i.company_ref.cname,
       i.pdate,
       i.qty
FROM clients c,
     TABLE(c.investments) i
ORDER BY c.clno, i.pdate;
