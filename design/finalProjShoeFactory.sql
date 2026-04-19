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
DROP SEQUENCE IF EXISTS Customer_id_seq;
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

CREATE SEQUENCE Customer_id_seq
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