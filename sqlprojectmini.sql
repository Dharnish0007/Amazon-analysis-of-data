create database amazon;

select * from amazon.products;
select * from amazon.customers;
select * from amazon.order_details;
select * from amazon.orders;
select * from amazon.reviews;
select * from amazon.suppliers;

-- Retrieve all customers from a specific city.
select name,city from amazon.customers 
where city = "Meganfort";

-- Fetch all products under the "Fruits" category.
select productName,Category from amazon.products
where category = "Fruits";

-- Write DDL statements to recreate the Customers table with the following
-- 1)CustomerID as the primary key.
-- 2)Ensure Age cannot be null and must be greater than 18.
-- 3)Add a unique constraint for Name.
-- 1)
alter table amazon.customers
add primary key (CustomerID); 
-- 2)
select Age from amazon.customers
where age > 18; 

-- Insert 3 new rows into the Products table using INSERT statements.
insert into amazon.products (ProductID , ProductName , Category , SubCategory , PricePerUnit , StockQuantity , SupplierID) values
("1","back","Snacks","Sub-Snacks-1","305","567","2dgt567-h7895jk-hjki7843"),
("2","front","Fruits","Sub-Fruits-2","897","765","2sd56hsth-hdgdn763-67nfen"),
("3","side","Meat","Sub-Meat-2","896","769","gghng456-hhnnrg7-bvnmkmg8");

-- Update the stock quantity of a product where ProductID matches a specific ID.
UPDATE amazon.products
SET StockQuantity = 456
WHERE ProductID = '2';

-- Delete a supplier from the Suppliers table where their city matches a specific values
set sql_safe_updates=0;
delete from amazon.suppliers
 where city = "South Ana";
 
 -- Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
ALTER TABLE amazon.reviews
ADD CONSTRAINT CHECK ( Rating between 1 and 5);

-- Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No").
ALTER TABLE amazon.customers
ALTER PrimeMember SET DEFAULT 'No';

-- Write queries using: WHERE clause to find orders placed after 2024-01-01.
select * from amazon.orders
where OrderDate > 2024-01-01;

-- HAVING clause to list products with average ratings greater than 4.
select * from amazon.products
having avg(Rating) > 4;
select ProductID,avg(Rating) as rate from amazon.reviews
group by ProductID
having rate > 4 order by rate asc ;

-- GROUP BY and ORDER BY clauses to rank products by total sales.
select p.productName,p.ProductID,sum(o.Quantity * o.UnitPrice - o.Discount) as total_sales from amazon.order_details as o
join amazon.products as p 
on p.ProductID = o.ProductID
group by p.ProductName,p.ProductID
order by total_sales desc;

-- 1. Calculate each customer's total spending.
select c.Name,c.CustomerID, sum(o.orderAmount + o.DeliveryFee - o.DiscountApplied) as total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
group by c.Name,o.CustomerID
order by total_spending desc;

-- Rank customers based on their spending.
select c.Name,o.CustomerID,sum(o.OrderAmount + o.DeliveryFee - DiscountApplied)as total_spending , 
dense_rank() over(order by sum(o.OrderAmount + o.DeliveryFee - DiscountApplied)desc) from amazon.orders as o
join amazon.customers  as c
on c.CustomerID=o.CustomerID
group by c.Name,o.CustomerID
order by total_spending desc;

-- Identify customers who have spent more than ₹5,000.
select c.Name,c.CustomerID,sum(o.orderAmount + o.DeliveryFee - o.DiscountApplied) as Total_spending from amazon.orders as o
join amazon.customers as c
on c.CustomerID=o.CustomerID
group by c.Name,o.CustomerID
having Total_spending > 5000;

-- Join the Orders and OrderDetails tables to calculate total revenue per order.
select o.OrderID, sum(od.Quantity + od.UnitPrice - od.Discount) as total_revenue from amazon.order_details as od
join amazon.orders as o
on o.OrderID = od.OrderID 
group by o.OrderID; 

-- Identify customers who placed the most orders in a specific time period.
select c.CustomerID,c.Name,count(o.OrderID) as total_quantity from amazon.orders  as o
join amazon.customers as c
on o.CustomerID = c.CustomerID
where OrderDate = "2025-01-01"
group by c.CustomerID,c.Name
order by total_quantity desc;

-- Find the supplier with the most products in stock.
select SupplierID,sum(StockQuantity) as sq from amazon.products 
group by SupplierID
order by sq desc;

-- normalisation
-- Separate product categories and subcategories into a new table.
 create table amazon.productCategory
 (vera_id varchar(100),
 product_id varchar(100),
 product_category varchar(100),
 vera_color varchar(100));
 
 select * from amazon.productCategory;
 
 insert into amazon.productCategory values
("1","0006853b-74cb-44a2-91ed-699aa31c5b5b","Bakery","black"),
("2","0219aafa-5dbc-4d92-acd9-8a78b4158651","Dairy","white"),
("3","0297061c-1241-4540-ac99-ac6a44fa507e","Backery","red"),
("4","02c7c358-da33-4586-8e32-5e459b7394fc","Snacks","green"),
("5","030ff542-d5f3-4387-9654-90ae0e38702c","Meat","maroon"),
("6","04c600c0-b84f-4de8-a71e-205528c610eb","Fruits","peach"),
("7","04d0f4ba-ccde-47d9-b846-ad470b5048fc","Snacks","blue"),
("8","05765892-c750-44cc-96e2-31fa53d42cb2","Vegetables","saffron"),
("9","059541ff-a15f-4d6d-8a5b-860bbae25715","Snacks","yellow"),
("10","0628599d-2f51-46a8-ab5e-7e54a383ca44","Vegetables","grey");

create table amazon.SubCategory
(sub_category_id varchar(100),
vera_id varchar(100),
product_id varchar(100),
sub_category varchar(100));

insert into amazon.SubCategory values
("1a","1","0006853b-74cb-44a2-91ed-699aa31c5b5b","sub-bakery"),
("2a","2","0219aafa-5dbc-4d92-acd9-8a78b4158651","sub-dairy"),
("3a","3","0297061c-1241-4540-ac99-ac6a44fa507e","sub-bakery"),
("4a","4","02c7c358-da33-4586-8e32-5e459b7394fc","sub-snacks"),
("5a","5","030ff542-d5f3-4387-9654-90ae0e38702c","sub-meat"),
("6a","6","04c600c0-b84f-4de8-a71e-205528c610eb","sub-fruits"),
("7a","7","04d0f4ba-ccde-47d9-b846-ad470b5048fc","sub-snacks"),
("8a","8","05765892-c750-44cc-96e2-31fa53d42cb2","sub-vegetables"),
("9a","9","059541ff-a15f-4d6d-8a5b-860bbae25715","sub-snacks"),
("10a","10","0628599d-2f51-46a8-ab5e-7e54a383ca44","sub-vegetables");

select * from amazon.productCategory;
select * from amazon.SubCategory;

-- -- Create foreign keys to maintain relationships.
-- relationship created

--  Write a subquery to:
-- Identify the top 3 products based on sales revenue
select p.ProductID,p.ProductName,sum(od.Quantity * od.UnitPrice - od.Discount) as sal_re from amazon.order_details as od
join amazon.products as p
on p.ProductID = od.ProductID
group by p.ProductID,p.ProductName
order by sal_re desc
limit 3;

-- Find customers who haven’t placed any orders yet.
select c.Name,o.OrderId from amazon.orders as o
join amazon.customers as c
on c.CustomerID = o.CustomerID
where o.CustomerID = null;

-- Provide actionable insights:
-- Which cities have the highest concentration of Prime members?
select City,count(PrimeMember) from amazon.customers
where PrimeMember ="Yes"
group by City
order by count(Primemember) desc;

--  What are the top 3 most frequently ordered categories?
select Category,count(Category) as total_quantity_ordered from amazon.products
group by Category
order by total_quantity_ordered desc
limit 3 ;



 

 








