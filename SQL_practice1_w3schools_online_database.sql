##1.Select all the products in product category 1. How many in total?
SELECT ProductID,ProductName FROM Products
WHERE CategoryID = 1;
SELECT count(*) FROM products 
WHERE CategoryID = 1; ##12

##2.Select all the customers from France. Out of those, how many are at Paris?
SELECT * FROM Customers
WHERE Country = "France";
SELECT count(*) FROM Customers
WHERE Country = "France" and City = "Paris"; ##2

##3.How many orders are placed during 1996-07-01 and 1996-07-31?
SELECT * FROM Orders
WHERE OrderDate BETWEEN '1996-07-01' AND '1996-07-31';

##4.Which employee graduated from University of Washington?
SELECT * FROM Employees
WHERE Notes LIKE "%Washington%";

##5.How many orders does each product ID have? 
SELECT ProductID, count(OrderID) as OrderNum
From OrderDetails
Group by ProductID
Order by ProductID;
##What are the total quantity for each product? 
SELECT ProductID,sum(Quantity) as TotalAmount FROM OrderDetails
Group by ProductID
Order by ProductID;
##What is the average quantity per order per product?
SELECT OrderID,ProductID,avg(Quantity) FROM OrderDetails
Group by OrderID
Order by ProductID;

##6.How many different products are in each order? 
SELECT OrderID, count(DISTINCT ProductID) as ProductNum FROM OrderDetails
Group by OrderID;
##Which order has the most number of unique products?
SELECT OrderID,ProductNum FROM
(
    SELECT OrderID, count(DISTINCT ProductID) as ProductNum FROM OrderDetails
    Group by OrderID
)
Group by OrderID
HAVING ProductNum in 
(
    SELECT max(ProductNum) FROM 
    (
        SELECT OrderID, count(DISTINCT ProductID) as ProductNum FROM OrderDetails
        Group by OrderID
    )
);

##7.Which products are sold in jars?
SELECT * FROM Products
WHERE Unit like "%jars%";
## What is the most expensive product that's sold in jars?
SELECT ProductID,ProductName,max(Price) FROM Products
WHERE Unit like "%jars%";

##8.What are the product names are included in order ID 10250?
SELECT Products.ProductName From Products
INNER JOIN OrderDetails
ON OrderDetails.ProductID = Products.ProductID
WHERE OrderDetails.OrderID = 10250;
#SELECT Products.ProductName From Products
#Natural Join OrderDetails
#WHERE OrderDetails.OrderID = 10250

##9.What products are contained in category 'Dairy Products'?
SELECT * FROM Products
Left Join Categories
On Products.CategoryID = Categories.CategoryID
WHERE Categories.CategoryName = "Dairy Products";

123456676767
