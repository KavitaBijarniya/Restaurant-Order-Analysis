USE restaurant_db


select * from menu_items

select * from order_details$

--What are the least and most expensive items on the menu?

select min(price) least_expensive, max(price) most_expensive from menu_items

--How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

select item_name, min(price) least_expensive, max(price) most_expensive from menu_items
where category = 'Italian'
group by item_name

--How many dishes are in each category? What is the average dish price within each category?

select distinct category, count(item_name) total_dishes, AVG(CAST(price AS DECIMAL(10, 2)))  avg_price   from menu_items
group by category

--the order_details table. What is the date range of the table?

select count(*) from order_details$

--How many orders were made within this date range? How many items were ordered within this date range?

SELECT COUNT( distinct order_id) AS num_orders
FROM order_details$
WHERE order_date BETWEEN 'start_date' AND 'end_date';

SELECT count(order_details_id) AS total_items
FROM order_details$
WHERE order_id IN (
    SELECT order_id
    FROM order_details$
    WHERE order_date BETWEEN 'start_date' AND 'end_date'
);


--Which orders had the most number of items?

SELECT order_id, count(order_details_id) AS num_items
FROM order_details$
group by order_id
order by num_items desc

--How many orders had more than 12 items?

SELECT count(order_id) as total_orders
FROM order_details$
HAVING count(order_details_id) > 12;

--Combine the menu_items and order_details tables into a single table

select * from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id

--What were the least and most ordered items? What categories were they in?


select  top 1 count(order_details_id) as least_ordered, item_name from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id
group by item_name
order by least_ordered asc



select  top 1 count(order_details_id) as most_ordered, item_name from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id
group by item_name
order by most_ordered desc

--What were the top 5 orders that spent the most money?

select top 5 order_id, SUM(CAST(price AS DECIMAL(10, 2))) AS total_spending from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id
group by order_id
order by total_spending desc

--View the details of the highest spend order. Which specific items were purchased?

select top 1 order_id, SUM(CAST(price AS DECIMAL(10, 2))) AS total_spending, STRING_AGG(item_name, ', ') AS purchased_items from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id
group by order_id
order by total_spending desc

-- View the details of the top 5 highest spend orders

select top 5 order_id, SUM(CAST(price AS DECIMAL(10, 2))) AS total_spending, from order_details$
join menu_items
on order_details$.item_id = menu_items.menu_item_id
group by   order_id
order by total_spending desc
