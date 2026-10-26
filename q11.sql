-- How much completed revenue does each region earn per month?
-- Join choice: INNER JOIN, because only customers with a completed order can form a region-month group;
-- every order has a matching customer, so no order is lost.
-- COUNT(DISTINCT) is necessary because one customer can place several orders in a month, and a plain COUNT would count orders, not customers.
SELECT c.region,
       o.order_month,
       COUNT(*) AS number_of_orders,
       COUNT(DISTINCT o.customer_id) AS number_of_customers,
       SUM(o.amount) AS total_revenue,
       AVG(o.amount) AS average_revenue
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
