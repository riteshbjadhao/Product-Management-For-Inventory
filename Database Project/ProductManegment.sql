create database ProductManagement

go 

use ProductManagement
----- productTable----

CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18,2) NOT NULL,
    StockQuantity INT NOT NULL,
    CreatedAt DATETIME NOT NULL,
    UpdatedAt DATETIME NOT NULL
);

go 

---- Categories Table-----
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    CategoryName NVARCHAR(100) NOT NULL
);

go

------- ProductCategories Table----
CREATE TABLE ProductCategories (
    ProductID INT,
    CategoryID INT,
    PRIMARY KEY (ProductID, CategoryID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
go 


-----------------STORED PROCEDURES (SPs)------
CREATE PROCEDURE InsertProduct
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(10, 2),
    @StockQuantity INT
AS
BEGIN
    INSERT INTO Products (Name, Description, Price, StockQuantity)
    VALUES (@Name, @Description, @Price, @StockQuantity)
END

GO

------- Insert Category-----

CREATE PROCEDURE InsertCategory
    @CategoryName NVARCHAR(100)
AS
BEGIN
    INSERT INTO Categories (CategoryName)
    VALUES (@CategoryName)
END

GO

-----Product to Category---

CREATE PROCEDURE LinkProductToCategory
    @ProductID INT,
    @CategoryID INT
AS
BEGIN
    INSERT INTO ProductCategories (ProductID, CategoryID)
    VALUES (@ProductID, @CategoryID)
END

GO

---- Get All Products with Categories---
CREATE PROCEDURE GetAllProductsWithCategories
AS
BEGIN
    SELECT 
        P.ProductID, P.Name, P.Description, P.Price, P.StockQuantity, P.CreatedAt, P.UpdatedAt,
        C.CategoryID, C.CategoryName
    FROM Products P
    LEFT JOIN ProductCategories PC ON P.ProductID = PC.ProductID
    LEFT JOIN Categories C ON PC.CategoryID = C.CategoryID
END


---Update Product---

CREATE PROCEDURE UpdateProduct
    @ProductID INT,
    @Name NVARCHAR(100),
    @Description NVARCHAR(500),
    @Price DECIMAL(10, 2),
    @StockQuantity INT
AS
BEGIN
    UPDATE Products
    SET 
        Name = @Name,
        Description = @Description,
        Price = @Price,
        StockQuantity = @StockQuantity,
        UpdatedAt = GETDATE()
    WHERE ProductID = @ProductID
END

GO 

--- Delete Product---

CREATE PROCEDURE DeleteProduct
    @ProductID INT
AS
BEGIN
    DELETE FROM ProductCategories WHERE ProductID = @ProductID
    DELETE FROM Products WHERE ProductID = @ProductID
END



