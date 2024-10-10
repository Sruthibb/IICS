----SOURCE TABLES -----------------------------------------------------
DROP TABLE SRC_CUSTOMERS;
CREATE TABLE SRC_CUSTOMERS
(
    CUST_ID          number(15),
    CUST_NAME        nvarchar2(255),
    ADDRESS          nvarchar2(255),
    CITY             nvarchar2(50),
    STATE            nvarchar2(10),
    WEBSITE          nvarchar2(255),
    CREDIT_LIMIT     number(8,2),
    TRANSACTION_DATE date
);

DROP TABLE SRC_PRODUCTS;
CREATE TABLE SRC_PRODUCTS
(
    PRODUCT_ID       number,
    PRODUCT_NAME     varchar2(255),
    DESCRIPTION      varchar2(2000),
    STANDARD_COST    number(9,2),
    LIST_PRICE       number(9,2),
    CATEGORY_ID      number,
    TRANSACTION_DATE date
);

DROP TABLE  SRC_EMPLOYEES;
CREATE TABLE SRC_EMPLOYEES
(
    EMPLOYEE_ID      number,
    FULLNAME         nvarchar2(255),
    EMAIL            nvarchar2(255),
    PHONE            nvarchar2(50),
    HIRE_DATE        date,
    MANAGER_ID       number(12),
    LOCATION         nvarchar2(255),
    SALARY           number(8,2),
    TRANSACTION_DATE date
);

DROP TABLE  SRC_DEALERSHIP;
CREATE TABLE SRC_DEALERSHIP
(
    DEALERSHIP_ID          number(15),
    DEALERSHIP_MANAGER_ID  nvarchar2(255),
    DEALERSHIP_DESCRIPTION nvarchar2(255),
    CITY                   nvarchar2(80),
    STATE                  nvarchar2(30),
    REGION                 nvarchar2(30),
    TRANSACTION_DATE       date
);

DROP TABLE SRC_SALES_TRANSACTION;
CREATE TABLE SRC_SALES_TRANSACTION
(
    PRODUCT_ID       number(15),
    CUST_ID          number(15),
    EMPLOYEE_ID      number(15),
    DEALERSHIP_ID    number(15),
    TRANSACTION_DATE date,
    HOLDBACK         number(15),
    REBATE           number(15),
    SELLING_PRICE    number(8,2),
    DELIVERY_CHARGES number(8,2),
    QUANITITY        number(15),
    DISCOUNT         number(15)
);


------------STAGE TABLES -----------------------------------------------------

DROP TABLE STG_EMPLOYEES;
CREATE TABLE STG_EMPLOYEES
(
    EMPLOYEE_ID  number(15),
    FULLNAME     nvarchar2(255),
    EMAIL        nvarchar2(255),
    PHONE        nvarchar2(50),
    HIRE_DATE    date,
    MANAGER_ID   number(12),
    LOCATION     nvarchar2(255),
    SALARY       number(8,2),
    DATE_ENTERED   date
);


DROP TABLE STG_CUSTOMERS;
CREATE TABLE STG_CUSTOMERS
(
    CUST_ID      number(15),
    CUST_NAME    nvarchar2(255),
    ADDRESS      nvarchar2(255),
    CITY         nvarchar2(50),
    STATE        nvarchar2(10),
    WEBSITE      nvarchar2(255),
    CREDIT_LIMIT number(8,2),
	DATE_ENTERED   date
);

DROP TABLE STG_PRODUCTS;
CREATE TABLE STG_PRODUCTS
(
    PRODUCT_ID    number(15),
    PRODUCT_NAME  varchar2(255),
    DESCRIPTION   varchar2(2000),
    STANDARD_COST number(9,2),
    LIST_PRICE    number(9,2),
    CATEGORY_ID   number,
	DATE_ENTERED   date
);

DROP TABLE STG_DEALERSHIP;
CREATE TABLE STG_DEALERSHIP
(
    DEALERSHIP_ID          number(15),
    DEALERSHIP_MANAGER_ID  varchar2(255),
    DEALERSHIP_DESCRIPTION varchar2(255),
    CITY                   varchar2(80),
    STATE                  varchar2(30),
    REGION                 varchar2(30),
	DATE_ENTERED   date
);

DROP TABLE STG_SALES_TRANSACTION;
CREATE TABLE STG_SALES_TRANSACTION
(
    PRODUCT_ID       number(15),
    CUST_ID          number(15),
    EMPLOYEE_ID      number(15),
    DEALERSHIP_ID    number(15),
    TRANSACTION_DATE date,
    HOLDBACK         number,
    REBATE           number,
    SELLING_PRICE    number(8,2),
    DELIVERY_CHARGES number(8,2),
    QUANITITY        number,
    DISCOUNT         number
);
-------------------------------------------------------------------------

select * from STG_EMPLOYEES order by employee_id;
select * from STG_PRODUCTS ORDER BY PRODUCT_ID;
Select * from  STG_CUSTOMERS  order by cust_id;
select * from STG_DEALERSHIP order by dealership_id;
select * from STG_SALES_TRANSACTION ;
----------------------------------------------------------------------------
------DIMENSIONS TABLES-----------------------------------------------------
DROP TABLE FACT_SALES;
DROP TABLE DATE_DIMENSION;
DROP TABLE DIM_EMPLOYEES;
DROP TABLE DIM_CUSTOMERS;
DROP TABLE DIM_PRODUCTS;
DROP TABLE DIM_DEALERSHIP;


CREATE TABLE DATE_DIMENSION
(
    DATEKEY        number NOT NULL,
    FULLDATE       date,
    DATE_DAY       number,
    DAYOFWEEK      number,
    DAYNAMEOFWEEK  varchar2(15),
    DAYOFYEAR      number,
    WEEKDAYWEEKEND varchar2(15),
    WEEKOFYEAR     number,
    MONTHNAME      varchar2(15),
    MONTHOFYEAR    number,
    QTR            number,
    CAL_YEAR       number
);


ALTER TABLE DATE_DIMENSION ADD PRIMARY KEY (DATEKEY);



CREATE TABLE DIM_EMPLOYEES
(
    EMPLOYEE_KEY number NOT NULL,
    EMPLOYEE_ID  number(15),
    FULLNAME     nvarchar2(255),
    EMAIL        nvarchar2(255),
    PHONE        nvarchar2(50),
    HIRE_DATE    date,
    MANAGER_ID   number(12),
    LOCATION     nvarchar2(255),
    SALARY       number(8,2),
    START_DATE   date,
    END_DATE     date
);


ALTER TABLE DIM_EMPLOYEES ADD PRIMARY KEY (EMPLOYEE_KEY);



CREATE TABLE DIM_CUSTOMERS
(
    CUSTOMER_KEY number NOT NULL,
    CUST_ID      number(15),
    CUST_NAME    nvarchar2(255),
    ADDRESS      nvarchar2(255),
    CITY         nvarchar2(50),
    STATE        nvarchar2(10),
    WEBSITE      nvarchar2(255),
    CREDIT_LIMIT number(8,2),
	START_DATE   date,
    END_DATE     date
);

ALTER TABLE DIM_CUSTOMERS ADD PRIMARY KEY (CUSTOMER_KEY);

CREATE TABLE DIM_PRODUCTS
(
    PRODUCT_KEY   number NOT NULL,
    PRODUCT_ID    number,
    PRODUCT_NAME  varchar2(255),
    DESCRIPTION   varchar2(2000),
    STANDARD_COST number(9,2),
    LIST_PRICE    number(9,2),
    CATEGORY_ID   number,
	START_DATE   date,
    END_DATE     date
);

ALTER TABLE DIM_PRODUCTS ADD PRIMARY KEY (PRODUCT_KEY);


CREATE TABLE DIM_DEALERSHIP
(
    DEALERSHIP_KEY         number NOT NULL,
    DEALERSHIP_ID          number(15),
    DEALERSHIP_MANAGER_ID  varchar2(255),
    DEALERSHIP_DESCRIPTION varchar2(255),
    CITY                   varchar2(80),
    STATE                  varchar2(30),
    REGION                 varchar2(30),
	START_DATE   date,
    END_DATE     date
);

ALTER TABLE DIM_DEALERSHIP ADD PRIMARY KEY (DEALERSHIP_KEY);




------- FACT TABLE -----------------------------------------------------------

CREATE TABLE FACT_SALES
(
    PRODUCT_KEY    number,
    CUSTOMER_KEY   number,
    EMPLOYEE_KEY   number,
    DLALERSHIP_KEY number,
    DATE_KEY       number,
    HOLDBACK       number,
    REBATE         number,
    UNIT_SOLD      number(15,4),
    DISCOUNTED_AMT number(15,4),
    REVENUE        number(15,4),
    COST           number(15,4)
);

ALTER TABLE FACT_SALES ADD 
    FOREIGN KEY (PRODUCT_KEY) REFERENCES DIM_PRODUCTS (PRODUCT_KEY);

ALTER TABLE FACT_SALES ADD 
    FOREIGN KEY (CUSTOMER_KEY) REFERENCES DIM_CUSTOMERS (CUSTOMER_KEY);

ALTER TABLE FACT_SALES ADD 
    FOREIGN KEY (EMPLOYEE_KEY) REFERENCES DIM_EMPLOYEES (EMPLOYEE_KEY);

ALTER TABLE FACT_SALES ADD 
    FOREIGN KEY (DLALERSHIP_KEY) REFERENCES DIM_DEALERSHIP (DEALERSHIP_KEY);

ALTER TABLE FACT_SALES ADD 
    FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIMENSION (DATEKEY);
	
---------------------------------------------------------------------------------------
--Select Statements
select * from DIM_EMPLOYEES order by employee_key;
select * from DIM_PRODUCTS ORDER BY PRODUCT_key;
Select * from  DIM_CUSTOMERS order by customer_key;
select * from DIM_DEALERSHIP order by DEALERSHIP_KEY;
select * from FACT_SALES;
