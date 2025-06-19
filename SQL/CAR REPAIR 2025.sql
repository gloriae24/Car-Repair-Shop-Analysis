-- DESIGNNING THE ER DIAGRAM

CREATE DATABASE car_repair_sales_analysis;
USE car_repair_sales_analysis;

CREATE TABLE fact_invoice (
    invoice_id INT PRIMARY KEY,
    invoice_date DATE,
    customer_id INT,
    vehicle_id INT,
    shop_location_id INT,
    total_parts_amount DECIMAL(10,2),
    total_labor_amount DECIMAL(10,2),
    total_invoice_amount DECIMAL(10,2)
);

CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255),
    customer_email VARCHAR(255),
    customer_phone VARCHAR(20)
);

CREATE TABLE dim_vehicle (
    vehicle_id INT PRIMARY KEY,
    customer_id INT,
    make VARCHAR(100),
    model VARCHAR(100),
    year INT
);

CREATE TABLE dim_shop_location (
    shop_location_id INT PRIMARY KEY,
    location_name VARCHAR(255),
    address TEXT,
    province VARCHAR(100)
);
CREATE TABLE dim_job (
    job_id INT PRIMARY KEY,
    invoice_id INT,
    job_type VARCHAR(100),
    job_description TEXT,
    job_cost DECIMAL(10,2)
);
CREATE TABLE dim_part (
    part_id INT PRIMARY KEY,
    part_name VARCHAR(255),
    part_description TEXT,
    unit_price DECIMAL(10,2)
);

CREATE TABLE bridge_job_part (
    job_part_id INT PRIMARY KEY,
    job_id INT,
    part_id INT,
    quantity INT,
    total_part_cost DECIMAL(10,2)
);


DROP TABLE fact_invoice;

DROP TABLE dim_customer ;
DROP TABLE dim_vehicle;
DROP TABLE  dim_shop_location;
DROP TABLE  dim_job;
DROP TABLE dim_part;
DROP TABLE bridge_job_part;


ALTER TABLE dim_job ADD COLUMN vehicle_id INT;
ALTER TABLE dim_job ADD COLUMN hours DECIMAL(4,2);
ALTER TABLE dim_job ADD COLUMN rate DECIMAL(6,2);


ALTER TABLE fact_invoice ADD COLUMN subtotal DECIMAL(10,2);
ALTER TABLE fact_invoice ADD COLUMN sales_tax DECIMAL(10,2);
ALTER TABLE fact_invoice ADD COLUMN sales_tax_rate DECIMAL(5,2);


-- What Relationships Should Exist in EER

-- fact_invoice foreign keys
ALTER TABLE fact_invoice
ADD FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
ADD FOREIGN KEY (vehicle_id) REFERENCES dim_vehicle(vehicle_id);

-- dim_vehicle foreign key
ALTER TABLE dim_vehicle
ADD FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id);

-- dim_job foreign keys
ALTER TABLE dim_job
ADD FOREIGN KEY (invoice_id) REFERENCES fact_invoice(invoice_id),
ADD FOREIGN KEY (vehicle_id) REFERENCES dim_vehicle(vehicle_id);

-- bridge_job_part foreign keys
ALTER TABLE bridge_job_part
ADD FOREIGN KEY (job_id) REFERENCES dim_job(job_id),
ADD FOREIGN KEY (part_id) REFERENCES dim_part(part_id);

-- STARTING AFRESH


-- Drop tables if they already exist (order matters because of FK constraints)

DROP TABLE IF EXISTS dim_Parts;
DROP TABLE IF EXISTS dim_Job;
DROP TABLE IF EXISTS Fact_Invoice;
DROP TABLE IF EXISTS dim_Vehicle;
DROP TABLE IF EXISTS dim_Customer;



-- 1. Dimension: Customer
CREATE TABLE dim_customer (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(20)
);
-- USE THIS BELLOW INSTEAD-- 
CREATE TABLE dim_Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    Phone VARCHAR(50)
);


-- 2. Dimension: Vehicle
CREATE TABLE dim_vehicle (
    vehicle_id INT PRIMARY KEY AUTO_INCREMENT,
    make VARCHAR(50),
    model VARCHAR(50),
    year INT,
    color VARCHAR(50),
    vin VARCHAR(50),
    reg_number VARCHAR(50),
    mileage INT,
    Name VARCHAR(100)
);
-- USE THIS BELOW INSTEAD 
CREATE TABLE dim_Vehicle (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    Make VARCHAR(255),
    Model VARCHAR(255),
    Year INT,
    Color VARCHAR(100),
    VIN VARCHAR(255),
    RegNumber VARCHAR(100),
    Mileage INT,
    Name VARCHAR(255)
);



-- 3. Dimension: Job
CREATE TABLE dim_job (
    job_id INT PRIMARY KEY,
    vehicle_id INT,
    description TEXT,
    hours DECIMAL(5,2),
    rate DECIMAL(10,2),
    amount DECIMAL(10,2),
    invoice_id INT,
    FOREIGN KEY (vehicle_id) REFERENCES dim_vehicle(vehicle_id)
);

-- 4. Dimension: Part
CREATE TABLE dim_part (
    part_id INT PRIMARY KEY,
    job_id INT,
    part_number VARCHAR(50),
    part_name VARCHAR(100),
    quantity INT,
    unit_price DECIMAL(10,2),
    amount DECIMAL(10,2),
    invoice_id INT,
    FOREIGN KEY (job_id) REFERENCES dim_job(job_id)
);

-- 5. Fact Table: Invoice
CREATE TABLE fact_invoice (
    invoice_id INT PRIMARY KEY,
    invoice_date DATE,
    subtotal DECIMAL(10,2),
    sales_tax_rate DECIMAL(5,2),
    sales_tax DECIMAL(10,2),
    total_labour DECIMAL(10,2),
    total_parts DECIMAL(10,2),
    total DECIMAL(10,2),
    customer_id INT,
    vehicle_id INT,
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (vehicle_id) REFERENCES dim_vehicle(vehicle_id)
);

SHOW TABLES;
SELECT * FROM dim_Customer;
SELECT * FROM dim_Vehicle;
SELECT * FROM fact_invoice;
SELECT * FROM dim_Job;
SELECT * FROM dim_Part;


-- now add the following in this order because of foreign key constraints

CREATE TABLE Fact_Invoice (
    InvoiceID INT PRIMARY KEY,
    InvoiceDate DATE,
    Subtotal DECIMAL(10,2),
    SalesTaxRate DECIMAL(5,2),
    SalesTax DECIMAL(10,2),
    TotalLabour DECIMAL(10,2),
    TotalParts DECIMAL(10,2),
    Total DECIMAL(10,2),
    CustomerID INT,
    VehicleID INT,
    FOREIGN KEY (CustomerID) REFERENCES dim_Customer(CustomerID),
    FOREIGN KEY (VehicleID) REFERENCES dim_Vehicle(VehicleID)
);


CREATE TABLE dim_Job (
    JobID INT PRIMARY KEY,
    VehicleID INT,
    Description VARCHAR(255),
    Hours DECIMAL(5,2),
    Rate DECIMAL(10,2),
    Amount DECIMAL(10,2),
    InvoiceID INT,
    FOREIGN KEY (VehicleID) REFERENCES dim_Vehicle(VehicleID),
    FOREIGN KEY (InvoiceID) REFERENCES Fact_Invoice(InvoiceID)
);

CREATE TABLE dim_Parts (
    PartID INT PRIMARY KEY,
    JobID INT,
    PartNumber VARCHAR(100),
    PartName VARCHAR(255),
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Amount DECIMAL(10,2),
    InvoiceID INT,
    FOREIGN KEY (JobID) REFERENCES dim_Job(JobID),
    FOREIGN KEY (InvoiceID) REFERENCES Fact_Invoice(InvoiceID)
);


