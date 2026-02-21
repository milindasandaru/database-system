-- IT23284784
-- Senarath S.A.M.S
-- Lab Sheet 04

-- 01.
-- Change the existing stock object type
ALTER TYPE stocks_t ADD MEMBER FUNCTION get_yield RETURN NUMBER CASCADE;
ALTER TYPE stocks_t ADD MEMBER FUNCTION get_price_usd(rate NUMBER) RETURN NUMBER CASCADE;
ALTER TYPE stocks_t ADD MEMBER FUNCTION count_exch RETURN NUMBER CASCADE;

CREATE OR REPLACE TYPE BODY stocks_t AS 
    -- (a): Calculate yield
    MEMBER FUNCTION get_yield RETURN NUMBER IS
    BEGIN
        RETURN (SELF.dividend / SELF.cprice) * 100;
    END;
    
    -- (b): Convert to USD using an input parameter
    MEMBER FUNCTION get_price_usd(rate NUMBER) RETURN NUMBER IS
    BEGIN
        RETURN (SELF.cprice * rate);
    END;
    
    -- (c): Count the number of exchanges in the VARRAY
    MEMBER FUNCTION count_exch RETURN NUMBER IS
    BEGIN
        RETURN SELF.exchanges.COUNT; 
    END;
END;
/

-- Test the stock method
SELECT 
    s.cname AS Company, 
    s.cprice AS Price_AUD,
    s.get_yield() AS Yield_Percent, 
    s.get_price_usd(0.74) AS Price_USD, 
    s.count_exch() AS Exchange_Count
FROM stocks s;

-- Change the existing client object type
ALTER TYPE client_t ADD MEMBER FUNCTION get_purchase_value RETURN NUMBER CASCADE;
ALTER TYPE client_t ADD MEMBER FUNCTION get_profit RETURN NUMBER CASCADE;

CREATE OR REPLACE TYPE BODY client_t AS
    -- (d): Total purchase value
    MEMBER FUNCTION get_purchase_value RETURN NUMBER IS
        v_total NUMBER := 0; -- Initail as 0 when begins
    BEGIN
        -- If client has no investment return 0
        IF SELF.investments IS NULL OR SELF.investments.COUNT = 0 THEN
        RETURN 0;
        END IF;

        -- Looping to count all values
        FOR i IN 1 ..SELF.investments.COUNT LOOP
            -- purchase value = purchase price * qty
            v_total := v_total + (SELF.investments(i).price * SELF.investments(i).qty);
        END LOOP;

        RETURN v_total;
    END;

    -- (e): Total profit 
    MEMBER FUNCTION get_profit RETURN NUMBER IS
        v_profit NUMBER := 0;
        v_current_price NUMBER;
    BEGIN
        -- If client has no shares
        IF SELF.investments IS NULL OR SELF.investments.COUNT = 0 THEN
        RETURN 0;
        END IF;

        -- Looping to count total profit
        FOR i IN 1 ..SELF.investments.COUNT LOOP

            -- Fetch the current price using the REF pointer
            SELECT s.cprice INTO v_current_price
            FROM stocks s
            WHERE REF(s) = SELF.investments(i).company_ref;

            -- total profit = (current price - purchase price) * qty
            v_profit := v_profit + (v_current_price - SELF.investments(i).price) * SELF.investments(i).qty;
        END LOOP;

        RETURN v_profit;
    END;
END;

-- Test the client method
SELECT 
    c.clno AS Client_Id, 
    c.name AS Client_Name,
    c.get_purchase_value() AS Purchase_Value, 
    c.get_profit() AS Profit
FROM clients c;

-- 02.
-- (a): Get yield and USD price (rate 0.74)
SELECT 
    s.cname, 
    s.exchanges, 
    s.get_yield() AS yield_pct, 
    s.get_price_usd(0.74) AS price_usd
FROM stocks s;

-- (b): Find stocks traded on more than one exchange
SELECT 
    s.cname, 
    s.cprice, 
    s.count_exch() AS exchange_count
FROM stocks s
WHERE s.count_exch() > 1;

-- (c): Client investments with yield
SELECT 
    c.name, 
    t.company_ref.cname AS stock, 
    t.company_ref.get_yield() AS yield_pct, 
    t.company_ref.cprice AS current_price, 
    t.company_ref.earnings AS eps
FROM clients c, TABLE(c.investments) t;

-- (d): otal Purchase Value for all clients
SELECT 
    c.name, 
    c.get_purchase_value() AS total_purchase_value
FROM clients c;
