-- Which orders are still pending, and for what amount?
SELECT order_id, customer_id, item, amount
FROM orders
WHERE status = 'pending'
ORDER BY order_id ASC;
