-- Inventory Tracking Database Schema

-- Create database
CREATE DATABASE InventoryDB;
USE InventoryDB;

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL UNIQUE
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierName VARCHAR(150) NOT NULL,
    ContactEmail VARCHAR(150) UNIQUE,
    Phone VARCHAR(50),
    Address VARCHAR(255)
);

-- Products Table
CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    ProductName VARCHAR(150) NOT NULL,
    SKU VARCHAR(100) NOT NULL UNIQUE,
    CategoryID INT NOT NULL,
    SupplierID INT,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
        ON UPDATE CASCADE ON DELETE SET NULL
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerName VARCHAR(150) NOT NULL,
    Email VARCHAR(150) UNIQUE,
    Phone VARCHAR(50),
    Address VARCHAR(255)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATE NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    CONSTRAINT fk_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- OrderItems Table (Many-to-Many relationship between Orders and Products)
CREATE TABLE OrderItems (
    OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    Price DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Inventory Table (Track stock levels per product)
CREATE TABLE Inventory (
    InventoryID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT NOT NULL UNIQUE,
    QuantityInStock INT NOT NULL DEFAULT 0 CHECK (QuantityInStock >= 0),
    LastUpdated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
        ON UPDATE CASCADE ON DELETE CASCADE
);
