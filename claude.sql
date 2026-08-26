/* ============================================================
   RETAIL SALES ANALYSIS SQL PROJECT
   ------------------------------------------------------------
   A portfolio-ready project covering:
     1. Database schema design (DDL)
     2. Sample data (DML)
     3. Business analysis queries (joins, aggregates, subqueries,
        window functions, CTEs, views)
   Compatible with MySQL / PostgreSQL (minor tweaks noted where needed)
   ============================================================ */


/* ============================================================
   1. SCHEMA CREATION
   ============================================================ */

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS stores;

CREATE TABLE categories (
    category_id     INT PRIMARY KEY,
    category_name   VARCHAR(50) NOT NULL
);

CREATE TABLE products (
    product_id      INT PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    category_id     INT NOT NULL,
    unit_price      DECIMAL(10,2) NOT NULL,
    unit_cost       DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE customers (
    customer_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    email           VARCHAR(100),
    city            VARCHAR(50),
    signup_date     DATE
);

CREATE TABLE stores (
    store_id        INT PRIMARY KEY,
    store_name      VARCHAR(50),
    city            VARCHAR(50)
);

CREATE TABLE employees (
    employee_id     INT PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    store_id        INT NOT NULL,
    hire_date       DATE,
    FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

CREATE TABLE orders (
    order_id        INT PRIMARY KEY,
    customer_id     INT NOT NULL,
    employee_id     INT NOT NULL,
    store_id        INT NOT NULL,
    order_date      DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id),
    FOREIGN KEY (store_id)    REFERENCES stores(store_id)
);

CREATE TABLE order_items (
    order_item_id   INT PRIMARY KEY,
    order_id        INT NOT NULL,
    product_id      INT NOT NULL,
    quantity        INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


/* ============================================================
   2. SAMPLE DATA
   ============================================================ */

INSERT INTO categories VALUES
(1,'Electronics'),(2,'Home & Kitchen'),(3,'Apparel'),(4,'Sports'),(5,'Books');

INSERT INTO products VALUES
(101,'Wireless Mouse',1,19.99,8.00),
(102,'Bluetooth Speaker',1,49.99,22.00),
(103,'USB-C Cable',1,9.99,2.50),
(104,'Non-stick Pan',2,34.99,15.00),
(105,'Blender',2,59.99,28.00),
(106,'Cotton T-Shirt',3,14.99,5.00),
(107,'Running Shoes',4,79.99,35.00),
(108,'Yoga Mat',4,24.99,9.00),
(109,'Novel: Ocean Drift',5,12.99,4.00),
(110,'Desk Lamp',2,27.99,10.00);

INSERT INTO customers VALUES
(1,'Asha','Rao','asha.rao@mail.com','Hyderabad','2023-01-15'),
(2,'Ben','Carter','ben.carter@mail.com','Chicago','2023-02-20'),
(3,'Chen','Wu','chen.wu@mail.com','Singapore','2023-03-05'),
(4,'Divya','Menon','divya.menon@mail.com','Vijayawada','2023-04-10'),
(5,'Ethan','Brooks','ethan.brooks@mail.com','New York','2023-05-18'),
(6,'Farah','Khan','farah.khan@mail.com','Dubai','2023-06-22'),
(7,'George','Silva','george.silva@mail.com','London','2023-07-30'),
(8,'Hana','Sato','hana.sato@mail.com','Tokyo','2023-08-14');

INSERT INTO stores VALUES
(1,'Downtown Store','Hyderabad'),
(2,'Mall Store','Chicago'),
(3,'Airport Store','Singapore');

INSERT INTO employees VALUES
(201,'Kiran','Patel',1,'2022-01-10'),
(202,'Liam','Ford',2,'2022-03-15'),
(203,'Mia','Tanaka',3,'2022-05-01'),
(204,'Noah','Smith',1,'2023-01-20');

INSERT INTO orders VALUES
(1001,1,201,1,'2024-01-05'),
(1002,2,202,2,'2024-01-12'),
(1003,3,203,3,'2024-01-20'),
(1004,1,204,1,'2024-02-02'),
(1005,4,201,1,'2024-02-15'),
(1006,5,202,2,'2024-02-25'),
(1007,6,203,3,'2024-03-03'),
(1008,2,202,2,'2024-03-10'),
(1009,7,201,1,'2024-03-18'),
(1010,8,203,3,'2024-04-01'),
(1011,3,203,3,'2024-04-09'),
(1012,1,204,1,'2024-04-20');

INSERT INTO order_items VALUES
(1,1001,101,2),(2,1001,103,3),
(3,1002,104,1),(4,1002,105,1),
(5,1003,106,4),(6,1003,109,2),
(7,1004,107,1),(8,1004,108,1),
(9,1005,102,1),(10,1005,110,2),
(11,1006,101,1),(12,1006,106,3),
(13,1007,105,1),(14,1007,109,1),
(15,1008,107,2),(16,1008,103,5),
(17,1009,108,2),(18,1009,110,1),
(19,1010,102,2),(20,1010,104,1),
(21,1011,106,2),(22,1011,101,1),
(23,1012,109,3),(24,1012,105,1);


/* ============================================================
   3. BUSINESS ANALYSIS QUERIES
   ============================================================ */

-- 3.1 Total revenue per order (join order_items -> products)
SELECT o.order_id,
       SUM(oi.quantity * p.unit_price) AS order_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p      ON oi.product_id = p.product_id
GROUP BY o.order_id
ORDER BY order_revenue DESC;

-- 3.2 Revenue and profit by category
SELECT c.category_name,
       SUM(oi.quantity * p.unit_price)                  AS revenue,
       SUM(oi.quantity * (p.unit_price - p.unit_cost))  AS profit
FROM order_items oi
JOIN products p    ON oi.product_id = p.product_id
JOIN categories c  ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;

-- 3.3 Top 5 customers by total spend
SELECT cu.customer_id, cu.first_name, cu.last_name,
       SUM(oi.quantity * p.unit_price) AS total_spent
FROM customers cu
JOIN orders o       ON cu.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- 3.4 Monthly sales trend
SELECT DATE_TRUNC('month', o.order_date) AS sales_month,
       SUM(oi.quantity * p.unit_price)   AS monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY sales_month
ORDER BY sales_month;
-- MySQL alternative: DATE_FORMAT(o.order_date, '%Y-%m')

-- 3.5 Store performance ranking
SELECT s.store_name,
       COUNT(DISTINCT o.order_id)          AS total_orders,
       SUM(oi.quantity * p.unit_price)     AS total_revenue
FROM stores s
JOIN orders o       ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;

-- 3.6 Employee performance (sales handled per employee)
SELECT e.first_name, e.last_name, s.store_name,
       COUNT(DISTINCT o.order_id)      AS orders_handled,
       SUM(oi.quantity * p.unit_price) AS revenue_generated
FROM employees e
JOIN stores s       ON e.store_id = s.store_id
JOIN orders o       ON e.employee_id = o.employee_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY e.first_name, e.last_name, s.store_name
ORDER BY revenue_generated DESC;

-- 3.7 Best-selling products by quantity
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 5;

-- 3.8 Customers who have never ordered (LEFT JOIN + NULL check)
SELECT cu.customer_id, cu.first_name, cu.last_name
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 3.9 Running total of revenue by order date (window function)
SELECT o.order_date,
       SUM(oi.quantity * p.unit_price) AS daily_revenue,
       SUM(SUM(oi.quantity * p.unit_price)) OVER (ORDER BY o.order_date)
           AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- 3.10 Rank products within each category by revenue (window function)
SELECT category_name, product_name, revenue,
       RANK() OVER (PARTITION BY category_name ORDER BY revenue DESC) AS rank_in_category
FROM (
    SELECT c.category_name, p.product_name,
           SUM(oi.quantity * p.unit_price) AS revenue
    FROM order_items oi
    JOIN products p    ON oi.product_id = p.product_id
    JOIN categories c  ON p.category_id = c.category_id
    GROUP BY c.category_name, p.product_name
) ranked
ORDER BY category_name, rank_in_category;

-- 3.11 Customers whose spend is above the average customer spend (subquery)
SELECT cu.customer_id, cu.first_name, cu.last_name, spend.total_spent
FROM customers cu
JOIN (
    SELECT o.customer_id, SUM(oi.quantity * p.unit_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.customer_id
) spend ON cu.customer_id = spend.customer_id
WHERE spend.total_spent > (
    SELECT AVG(total_spent) FROM (
        SELECT SUM(oi.quantity * p.unit_price) AS total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p     ON oi.product_id = p.product_id
        GROUP BY o.customer_id
    ) avg_sub
);

-- 3.12 CTE: month-over-month revenue growth %
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', o.order_date) AS sales_month,
           SUM(oi.quantity * p.unit_price)   AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY sales_month
)
SELECT sales_month,
       revenue,
       LAG(revenue) OVER (ORDER BY sales_month)         AS prev_month_revenue,
       ROUND(
         (revenue - LAG(revenue) OVER (ORDER BY sales_month))
         / LAG(revenue) OVER (ORDER BY sales_month) * 100, 2
       ) AS growth_pct
FROM monthly_revenue
ORDER BY sales_month;

-- 3.13 View: reusable "order details" summary
CREATE OR REPLACE VIEW vw_order_details AS
SELECT o.order_id, o.order_date, cu.first_name, cu.last_name,
       s.store_name, p.product_name, oi.quantity,
       p.unit_price, (oi.quantity * p.unit_price) AS line_total
FROM orders o
JOIN customers cu   ON o.customer_id = cu.customer_id
JOIN stores s        ON o.store_id = s.store_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p     ON oi.product_id = p.product_id;

-- Example usage of the view:
SELECT * FROM vw_order_details WHERE store_name = 'Downtown Store';

-- 3.14 Profit margin percentage per product
SELECT product_name,
       unit_price, unit_cost,
       ROUND((unit_price - unit_cost) / unit_price * 100, 2) AS margin_pct
FROM products
ORDER BY margin_pct DESC;

-- 3.15 Customer segmentation: first purchase date & lifetime value (CTE)
WITH customer_orders AS (
    SELECT o.customer_id,
           MIN(o.order_date) AS first_purchase,
           SUM(oi.quantity * p.unit_price) AS lifetime_value
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p     ON oi.product_id = p.product_id
    GROUP BY o.customer_id
)
SELECT cu.first_name, cu.last_name, co.first_purchase, co.lifetime_value,
       CASE
           WHEN co.lifetime_value >= 150 THEN 'High Value'
           WHEN co.lifetime_value >= 75  THEN 'Medium Value'
           ELSE 'Low Value'
       END AS segment
FROM customer_orders co
JOIN customers cu ON co.customer_id = cu.customer_id
ORDER BY co.lifetime_value DESC;

/* ============================================================
   END OF PROJECT
   Ideas to extend this further:
     - Add a returns/refunds table and analyze return rates
     - Add stored procedures for common reports
     - Build a dashboard on top of vw_order_details (Tableau/Power BI)
     - Add indexes on foreign keys and benchmark query performance
   ============================================================ */
