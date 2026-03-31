SELECT * 
FROM `workspace`.`default`.`bright_coffee_shop_analysis` 
limit 100;


---We have 149116 rows and sales and 3 stores with 80 products---
SELECT COUNT(*) AS Number_of_rows,
       COUNT (DISTINCT transaction_id) AS Number_of_sales,
       COUNT (DISTINCT product_id) AS Number_of_products,
       COUNT (DISTINCT store_id) AS Number_of_stores
FROM  `workspace`.`default`.`bright_coffee_shop_analysis`;

---Check date range
----We have transaction duration of 6 months( from Jan to June---
SELECT MIN(transaction_date) AS start_date,
       MAX(transaction_date) AS last_date
FROM  `workspace`.`default`.`bright_coffee_shop_analysis`;

---Check what time does the store open and close
---Store opens at 6am and close at 9pm---
SELECT MIN(transaction_time) AS store_opens,
       MAX(transaction_time) AS store_closes
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

---Check the store locations
---Our stores are Lower Manhattan, Hell's Kitchen and Astoria---
SELECT DISTINCT (store_location)
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

---Check the min and max sale prices
---The lowest price is 0.8 and highest is 45
SELECT MIN(unit_price) AS lowest_price,
       MAX(unit_price) AS highest_price
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

---Check products sold at the stores
SELECT DISTINCT product_category
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

SELECT DISTINCT product_detail
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

SELECT DISTINCT product_type
FROM `workspace`.`default`.`bright_coffee_shop_analysis`;

---date function (showing days)---
SELECT transaction_id,
      transaction_date,
      Dayname(transaction_date) AS day_name,
      Monthname(transaction_date) AS month_name,
      transaction_qty*unit_price AS amount_per_trans
FROM  `workspace`.`default`.`bright_coffee_shop_analysis`;

---------grouping/aggregating the data---
SELECT
      transaction_date,
      Dayname(transaction_date) AS day_name,
      Monthname(transaction_date) AS month_name,
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      SUM(transaction_qty*unit_price) AS total_amount_pd
FROM  `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY transaction_date,
         day_name,
         month_name;

------date_format(transaction_time, 'HH:mm:ss') AS purchase_time--
SELECT
      transaction_date AS purchase_date,
      Dayname(transaction_date) AS day_name,
      Monthname(transaction_date) AS month_name,
      Dayofmonth(transaction_date) AS day_of_month,

      CASE 
          WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'weekend'
          ELSE 'weekday'
      END AS day_classification,

       CASE
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '07:59:59' THEN 'Early Morning'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '08:00:00' AND '09:59:59' THEN ' Morning Rush'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '10:00:00' AND '11:59:59' THEN 'Late Morning'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '13:59:59' THEN 'Lunch Peak'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '14:00:00' AND '15:59:59' THEN 'Afternoon Lull'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '17:59:59' THEN 'Evening Start'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '19:59:59' THEN 'Evening Wind-down'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '20:00:00' AND '21:59:59' THEN 'Last Call'
      END AS transaction_time_bucket,
     
      COUNT(DISTINCT transaction_id) AS number_of_sales,
      COUNT(DISTINCT product_id) AS number_of_products,
      COUNT(DISTINCT store_id) AS number_of_stores,

      SUM(transaction_qty*unit_price) AS total_amount_pd,

      CASE 
           WHEN total_amount_pd <=50 THEN 'low spend'
           WHEN  total_amount_pd BETWEEN 51 AND 100 THEN 'mid spend'
           ELSE 'high spend'
      END AS spend_bucket,

      store_location,
      product_category,
      product_detail

FROM  `workspace`.`default`.`bright_coffee_shop_analysis`
GROUP BY  transaction_date,
          Dayname(transaction_date),
          Monthname(transaction_date) ,
          Dayofmonth(transaction_date) ,

       CASE 
            WHEN Dayname(transaction_date) IN ('Sun','Sat') THEN 'weekend'
            ELSE 'weekday'
       END,

       CASE
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '06:00:00' AND '07:59:59' THEN 'Early Morning'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '08:00:00' AND '09:59:59' THEN ' Morning Rush'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '10:00:00' AND '11:59:59' THEN 'Late Morning'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '12:00:00' AND '13:59:59' THEN 'Lunch Peak'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '14:00:00' AND '15:59:59' THEN 'Afternoon Lull'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '16:00:00' AND '17:59:59' THEN 'Evening Start'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '18:00:00' AND '19:59:59' THEN 'Evening Wind-down'
             WHEN date_format(transaction_time, 'HH:mm:ss') BETWEEN '20:00:00' AND '21:59:59' THEN 'Last Call'
      END,
      
      store_location,
      product_category,
      product_detail;
     
