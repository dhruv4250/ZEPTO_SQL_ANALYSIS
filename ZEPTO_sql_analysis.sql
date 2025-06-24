DROP TABLE IF EXISTS zepto;

CREATE TABLE zepto (
sku_id SERIAL PRIMARY KEY,
Category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC (5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);


--COUNT OF ROWS
SELECT COUNT(*) FROM zepto;

--SAMPLE DATA
SELECT * FROM zepto
LIMIT 10;

--NULL VALUES
SELECT * FROM zepto
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;


--different product category

SELECT DISTINCT category
FROM zepto
ORDER BY category;


--products instock vs outofstocks

SELECT outofstock ,count(sku_id)
FROM zepto
GROUP BY outofstock;


--product names present multipletimes

SELECT name,COUNT(sku_id) as "Number of SKU's"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id) > 1
ORDER BY COUNT(sku_id) DESC;


--DATA CLEANING

--products with price = 0

SELECT * FROM zepto
WHERE mrp = 0 OR  discountedsellingprice =0;

DELETE FROM zepto 
WHERE mrp =0;


-- convert paise into rupees


UPDATE zepto
SET mrp = mrp/100.0,
discountedsellingprice = discountedsellingprice/100.0;

SELECT mrp, discountedsellingprice FROM zepto;



--q1. TOP 10 BEST-VALUES PRODUCTS BASED ON DISCOUNT PERCENTGE.

SELECT DISTINCT name,mrp,discountPercent
FROM zepto
ORDER BY discountPercent DESC
LIMIT 10;


--q2. PRODUCT WITH HIGH MRP BUT OUT OF STOCK

SELECT DISTINCT name ,mrp
FROM zepto
WHERE outofstock = TRUE and mrp> 300
ORDER BY mrp DESC;


--q3. ESTIMATE REVANUE FOR EACH CATEGORY

SELECT category ,
SUM(discountedsellingprice * availablequantity) as total_revanue
FROM zepto
GROUP BY category
ORDER BY total_revanue;


--q4.  PRODUCTS WHERE MRP IS GREATER THEN 500 AND DISCOUNT IS LESS THEN 10%


SELECT DISTINCT name, mrp,discountpercent
FROM zepto
WHERE mrp > 500 AND discountpercent > 10
ORDER BY mrp DESC, discountpercent DESC;


--q5.  TOP 5 CATEGORIES OFFERING THE HIGEST AVERAGE DISCOUNT PERCENTAGE

SELECT category,
ROUND (AVG(discountpercent),2) AS avg_discount
FROM zepto
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;


--q6.  PRICE PER GRAM OF PRODUCTS ABOVE 100GMS AND SORT BY BEST VALUES

SELECT DISTINCT name , weightingms, discountedsellingprice,
discountedsellingprice/weightingms AS price_per_grams
FROM zepto
WHERE weightingms >= 100
ORDER BY price_per_grams;


--q7.  GROUPING THE PRODUCT INTO CATEGORIES LIKE LOW, MEDIUM, BULK

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'LOW'
	WHEN weightingms < 5000 THEN 'medium'
	ELSE 'bulk'
	END AS weight_category
FROM zepto;


--q8.  TOTAL INVENTORY WEIGHT PER CATEGORY

SELECT category ,
SUM(weightingms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category
ORDER BY total_weight;

