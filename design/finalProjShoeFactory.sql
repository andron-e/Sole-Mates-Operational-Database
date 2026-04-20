/* 
    TABLES 
*/

DROP TABLE IF EXISTS SalesTransaction;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Model;
DROP TABLE IF EXISTS Brand;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Store;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS SaleIncludes;


CREATE TABLE Brand
(
brand_id NUMBER,
brand_name VARCHAR2(30) NOT NULL,
CONSTRAINT brand_id_pk PRIMARY KEY (brand_id)
);

CREATE TABLE Category
(
category_id NUMBER,
category_name VARCHAR2(30) NOT NULL,
CONSTRAINT category_id_pk PRIMARY KEY (category_id)
);

CREATE TABLE Model
(
model_id NUMBER,
model_name VARCHAR2(30) NOT NULL,
price NUMBER NOT NULL,
category_id NUMBER NOT NULL,
brand_id NUMBER NOT NULL,
CONSTRAINT model_id_pk PRIMARY KEY (model_id)
);

CREATE TABLE Product
(
product_id NUMBER,
product_style VARCHAR2(30) NOT NULL,
product_size NUMBER NOT NULL,
model_id NUMBER NOT NULL,
CONSTRAINT product_id_pk PRIMARY KEY (product_id)
);

CREATE TABLE Customer
(
customer_id NUMBER,
last_name VARCHAR2(30) NOT NULL,
first_name VARCHAR2(30) NOT NULL,
address VARCHAR2(30) NOT NULL,
phone_number VARCHAR2(20) NOT NULL,
CONSTRAINT customer_id_pk PRIMARY KEY (customer_id)
);

CREATE TABLE Store
(
store_id NUMBER NOT NULL,
zip_code NUMBER NOT NULL,
region_id NUMBER NOT NULL,
CONSTRAINT store_id_pk PRIMARY KEY (store_id)
);

CREATE TABLE Region
(
region_id NUMBER,
region_name VARCHAR2(30) NOT NULL,
CONSTRAINT region_id_pk PRIMARY KEY (region_id)
);

CREATE TABLE SalesTransaction
(
transaction_id NUMBER,
date_transaction DATE NOT NULL,
store_id NUMBER NOT NULL,
customer_id NUMBER NOT NULL,
CONSTRAINT transaction_id_pk PRIMARY KEY (transaction_id)
);

CREATE TABLE SaleIncludes
(
    transaction_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL
);

/* 
    FK CONSTRAINTS
*/
ALTER TABLE Model ADD CONSTRAINT category_id_fk FOREIGN KEY (category_id) REFERENCES Category (category_id);
ALTER TABLE Model ADD CONSTRAINT brand_id_fk FOREIGN KEY (brand_id) REFERENCES Brand (brand_id);
ALTER TABLE Product ADD CONSTRAINT model_id_fk FOREIGN KEY (model_id) REFERENCES Model (model_id);
ALTER TABLE Store ADD CONSTRAINT region_id_fk FOREIGN KEY (region_id) REFERENCES Region (region_id);
ALTER TABLE SalesTransaction ADD CONSTRAINT customer_id_fk FOREIGN KEY (customer_id) REFERENCES Customer (customer_id);
ALTER TABLE SaleIncludes ADD CONSTRAINT transaction_id_fk FOREIGN KEY (transaction_id) REFERENCES SalesTransaction (transaction_id);
ALTER TABLE SaleIncludes ADD CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES Product (product_id);

/* 
    INDEXES
*/
CREATE INDEX model_category_id_ix ON Model(category_id);

CREATE INDEX model_brand_id_ix ON Model(brand_id);

CREATE INDEX product_model_id_ix ON Product(model_id);

CREATE INDEX store_region_id_ix ON Store(region_id);

/* 
    SEQUENCES
*/
DROP SEQUENCE IF EXISTS brand_id_seq;
DROP SEQUENCE IF EXISTS category_id_seq;
DROP SEQUENCE IF EXISTS model_id_seq;
DROP SEQUENCE IF EXISTS product_id_seq;
DROP SEQUENCE IF EXISTS customer_id_seq;
DROP SEQUENCE IF EXISTS store_id_seq;
DROP SEQUENCE IF EXISTS region_id_seq;
DROP SEQUENCE IF EXISTS transaction_id_seq;

CREATE SEQUENCE brand_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE category_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE model_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE product_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE customer_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE store_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE region_id_seq
    INCREMENT BY 1
    START WITH 1;

CREATE SEQUENCE transaction_id_seq
    INCREMENT BY 1
    START WITH 1;


/*
    DATA INSERTIONS
*/

INSERT INTO Brand VALUES (brand_id_seq.NEXTVAL, 'Nikeme');
INSERT INTO Brand VALUES (brand_id_seq.NEXTVAL, 'Pumeme');

INSERT INTO Category VALUES (category_id_seq.NEXTVAL, 'sneakers');
INSERT INTO Category VALUES (category_id_seq.NEXTVAL, 'flip-flops');

INSERT INTO Region VALUES (region_id_seq.NEXTVAL, 'Northeast');
INSERT INTO Region VALUES (region_id_seq.NEXTVAL, 'West');
INSERT INTO Region VALUES (region_id_seq.NEXTVAL, 'Midwest');
INSERT INTO Region VALUES (region_id_seq.NEXTVAL, 'Southwest');
INSERT INTO Region VALUES (region_id_seq.NEXTVAL, 'Southeast');

INSERT INTO Customer VALUES (customer_id_seq.NEXTVAL, 'Smith', 'John', '123 Main St', '215-555-1234');
INSERT INTO Customer VALUES (customer_id_seq.NEXTVAL, 'Doe', 'Jane', '456 Oak Ave', '267-555-5678');

-- brand_id 1 = Nikeme, 2 = Pumeme; category_id 1 = sneakers, 2 = flip-flops
INSERT INTO Model VALUES (model_id_seq.NEXTVAL, 'Air Max', 120, 1, 1);
INSERT INTO Model VALUES (model_id_seq.NEXTVAL, 'Beach Walker', 30, 2, 2);

-- model_id 1 = Air Max, 2 = Beach Walker
INSERT INTO Product VALUES (product_id_seq.NEXTVAL, 'Low-top', 10, 1);
INSERT INTO Product VALUES (product_id_seq.NEXTVAL, 'Classic', 9, 2);

-- region_id 1 = Northeast, 2 = West, 3 = Midwest, 4 = Southwest, 5 = Southeast
INSERT INTO Store VALUES (store_id_seq.NEXTVAL, 19122, 1);
INSERT INTO Store VALUES (store_id_seq.NEXTVAL, 90210, 2);
INSERT INTO Store VALUES (store_id_seq.NEXTVAL, 49009, 3);
INSERT INTO Store VALUES (store_id_seq.NEXTVAL, 19153, 4);
INSERT INTO Store VALUES (store_id_seq.NEXTVAL, 28119, 5);

INSERT INTO SalesTransaction VALUES (transaction_id_seq.NEXTVAL, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 1, 1);
INSERT INTO SalesTransaction VALUES (transaction_id_seq.NEXTVAL, TO_DATE('2025-02-20', 'YYYY-MM-DD'), 2, 2);

-- transactions to products
INSERT INTO SaleIncludes VALUES (1, 1);
INSERT INTO SaleIncludes VALUES (1, 2);
INSERT INTO SaleIncludes VALUES (2, 2);


/* 
    PERMA DATA
*/

COMMIT;


/*
    QUERIES
*/

-- 1) "which region is pulling in the most sales?"
SELECT
    r.region_name,
    COUNT(DISTINCT st.transaction_id) AS total_transactions,
    SUM(m.price)                      AS total_revenue
FROM Region r
LEFT JOIN Store s             ON r.region_id = s.region_id
LEFT JOIN SalesTransaction st ON s.store_id = st.store_id
LEFT JOIN SaleIncludes si     ON st.transaction_id = si.transaction_id
LEFT JOIN Product p           ON si.product_id = p.product_id
LEFT JOIN Model m             ON p.model_id = m.model_id
GROUP BY r.region_name
ORDER BY total_revenue DESC;

-- 2) "which brand is moving the most product?"
SELECT
    b.brand_name,
    COUNT(si.product_id) AS units_sold,
    SUM(m.price)         AS brand_revenue
FROM Brand b
JOIN Model m         ON b.brand_id = m.brand_id
JOIN Product p       ON m.model_id = p.model_id
JOIN SaleIncludes si ON p.product_id = si.product_id
GROUP BY b.brand_name
ORDER BY units_sold DESC;