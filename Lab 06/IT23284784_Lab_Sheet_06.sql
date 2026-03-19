--IT23284784
--Senarath S.A.M.S
--Lab Sheet 06

-- 01. create the table with XMLtype
CREATE TABLE AdminDocs(
    id INT PRIMARY KEY,
    xDoc XMLTYPE NOT NULL
);

-- insert XML documents into the table
INSERT INTO AdminDocs VALUES (1,
XMLTYPE ('<catalog>
    <product dept="WMN">
        <number>557</number>
        <name language="en">Fleece Pullover</name>
        <colorChoices>navy black</colorChoices>
    </product>
    <product dept="ACC">
        <number>563</number>
        <name language="en">Floppy Sun Hat</name>
    </product>
    <product dept="ACC">
        <number>443</number>
        <name language="en">Deluxe Travel Bag</name>
    </product>
    <product dept="MEN">
        <number>784</number>
        <name language="en">Cotton Dress Shirt</name>
        <colorChoices>white gray</colorChoices>
        <desc>Our <i>favorite</i> shirt!</desc>
    </product>
</catalog>'));

-- insert the table data 
INSERT INTO AdminDocs VALUES (2,
XMLTYPE ('<doc id="123">
    2 of 4
    <sections>
        <section num="1"><title>XML Schema</title></section>
        <section num="3"><title>Benefits</title></section>
        <section num="4"><title>Features</title></section>
    </sections>
</doc>'));

-- testing the table
SELECT * FROM AdminDocs;

-- 02. simple path navigation
-- a. 
SELECT id,
       XMLQuery('/catalog/product'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

-- b.
SELECT id,
       XMLQuery('//product'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

-- c.
SELECT id,
       XMLQuery('/*/product'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

-- d.
SELECT id,
       XMLQuery('/*/product[@dept="WMN"]'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

-- e.
SELECT id,
       XMLQuery('/*/child::product[attribute::dept="WMN"]'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

-- f.
SELECT XMLQUERY('//product[@dept="WMN"]'
        PASSING xDoc
        RETURNING CONTENT)
FROM AdminDocs;

-- g.
SELECT id,
         XMLQuery('descendant-or-self::product[attribute::dept="WMN"]'
         PASSING xDoc
         RETURNING CONTENT) AS result
FROM AdminDocs;

-- h.
SELECT XMLQuery('//product[number>500]'
        PASSING xDoc
        RETURNING CONTENT)
FROM AdminDocs
WHERE id = 1;

-- i.
SELECT id,
         XMLQuery('//product/number[. > 500]'
         PASSING xDoc
         RETURNING CONTENT) AS result
FROM AdminDocs
WHERE id = 1;

-- j.
SELECT id,
        XMLQUERY('/catalog/product[4]'
        PASSING xDoc
        RETURNING CONTENT) AS result
FROM AdminDocs
WHERE id = 1;

-- k.
SELECT id,
        XMLQUERY('//product[number > 500][@dept="ACC"]'
        PASSING xDoc
        RETURNING CONTENT) AS result
FROM AdminDocs
WHERE id = 1;

-- l.
SELECT id,
        XMLQUERY('//product[number > 500][1]'
        PASSING xDoc
        RETURNING CONTENT) AS result
FROM AdminDocs
WHERE id = 1;

-- 03. 
-- a.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 return $x'
            PASSING xDoc
            RETURNING CONTENT)
FROM AdminDocs
WHERE id = 1;

-- b.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 where $x > 500
                 return $x' 
       PASSING xDoc 
       RETURNING CONTENT)
FROM AdminDocs 
WHERE id = 1;

-- c.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 return $x'
            PASSING xDoc
            RETURNING CONTENT)
FROM AdminDocs
WHERE id = 1;

-- d.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 where $x > 500
                 return (<Item>{$x}</Item>)' 
       PASSING xDoc 
       RETURNING CONTENT)
FROM AdminDocs 
WHERE id = 1;

-- e.
SELECT XMLQuery('for $prod in //product[number > 500]
                 let $x := $prod/number
                 return (<Item>{$x}</Item>)' 
       PASSING xDoc 
       RETURNING CONTENT)
FROM AdminDocs 
WHERE id = 1;

-- f.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 where $x > 500
                 return (<Item>{data($x)}</Item>)'
       PASSING xDoc 
       RETURNING CONTENT)
FROM AdminDocs 
WHERE id = 1;

-- g.
SELECT XMLQuery('for $prod in //product
                 let $x := $prod/number
                 return if ($x>500) 
                    then <book>{data($x)}</book>
                    else <paper>{data($x)}</paper>'
       PASSING xDoc 
       RETURNING CONTENT)
FROM AdminDocs 
WHERE id = 1;

-- 04. insert a new product into the XML document
UPDATE AdminDocs 
SET xDoc = XMLQuery('copy $i := .
                     modify insert node <section num="2"><title>Background</title></section> 
                     after ($i/doc/sections/section[@num="1"])
                     return $i' 
           PASSING xDoc RETURNING CONTENT)
WHERE id = 2;

SELECT * 
FROM AdminDocs;
--WHERE id = 2;

-- 5. Deleting the section we just added
UPDATE AdminDocs 
SET xDoc = XMLQuery('copy $i := .
                     modify delete nodes $i//section[@num="2"]
                     return $i' 
           PASSING xDoc RETURNING CONTENT)
WHERE id = 2;
