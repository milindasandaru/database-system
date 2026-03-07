--IT23284784
--Senarath S.A.M.S
--Lab Sheet 06

-- 01. create the table with XMLtype
CREATE TABLE AdminDocs(
    id INT PRIMARY KEY,
    xDoc XMLTYPE NOT NULL
);

-- 02. insert XML documents into the table
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

-- 03. insert the table data 
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

-- 04. simple path navigation
SELECT id,
       XMLQuery('/catalog/product'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

SELECT id,
       XMLQuery('//product'
       PASSING xDoc
       RETURNING CONTENT) AS result
FROM AdminDocs;

SELECT XMLQUERY('//product[@dept="WMN"]'
        PASSING xDoc
        RETURNING CONTENT)
FROM AdminDocs;

SELECT XMLQuery('//product[number>500]'
        PASSING xDoc
        RETURNING CONTENT)
        FROM AdminDocs
WHERE id = 1;

