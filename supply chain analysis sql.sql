create database analysis;
use analysis;
select * from supply_chain_data;
describe supply_chain_data;
-- ---------------sales and product analysis-------

-- Q Which product category generates the highest revenue?
select `product type`,
sum(`number of products sold`) AS total_units_sold,
sum(`revenue generated`) AS total_revenue
from supply_chain_data
group by `product type`
order by total_revenue desc;

-- Which SKUs sell the most and least?
SELECT `SKU`,
SUM(`REVENUE GENERATED`) AS TOTAL_REVENUE 
FROM SUPPLY_CHAIN_DATA
group by `SKU`
ORDER BY TOTAL_REVENUE DESC
LIMIT 10;

-- What is the average selling price?
SELECT AVG(`PRICE`)
FROM SUPPLY_CHAIN_DATA;

-- Which products have high sales but low recorded revenue? 

SELECT `PRODUCT TYPE`,`sku`,
SUM(`Number of products sold`) AS product_sold,
SUM(`Revenue generated`) AS revenue_generated
from supply_chain_data
group by `product type`,`sku`
ORDER BY product_sold DESC, revenue_generated  ASC;

-- What percentage of total sales comes from each category?

select 
`product type`,
SUM(`Number of products sold`) AS total_sales,
round(
sum(`number of products sold`) *100 /
(select sum(`number of products sold`)
from supply_chain_data),
2
)AS sales_percentage
FROM supply_chain_datak
GROUP BY `Product Type`
ORDER BY sales_percentage DESC;


-- ------------------Inventory and demand analysis-------------
-- Which products have low or zero stock?
SELECT `PRODUCT TYPE`,`STOCK LEVELS`,`SKU`
FROM SUPPLY_CHAIN_DATA 
WHERE `STOCK LEVELS` <=10 OR `STOCK LEVELS` = 0
ORDER BY `STOCK LEVELS` ASC;

-- Which products sell well but have low inventory?
SELECT `PRODUCT TYPE`,`sku`,
SUM(`Number of products sold`) AS product_sold,
SUM(`Stock levels`) AS 	inventory_level
from supply_chain_data
WHERE `STOCK LEVELS` <=40
group by `product type`,`sku`
ORDER BY product_sold DESC,  inventory_level ASC ;

-- Logistics and transportation analysis---------

-- Which transportation mode has the lowest average cost?
SELECT `Transportation modes`,
round(avg(costs),2) as avg_cost
from supply_chain_data
group by `Transportation modes`
order by avg_cost asc;

-- Which routes have high costs relative to other routes?
select `Routes`,
sum(costs) AS high_cost_route
from supply_chain_data
group by `routes`
order by high_cost_route;

-- Quality control analysis
-- Which suppliers have the highest defect rates?
select `Supplier name`,
round(sum(`Defect rates`),2) as defect_rates
from supply_chain_data
group by `Supplier name`
order by defect_rates;
 
-- What percentage of inspections passed, failed, or remain pending?

select `Inspection results`,
COUNT(*) AS total_inspection,
round(
count(*) * 100.0 /
(select count(*) from supply_chain_data),
2
) AS percentage
from supply_chain_data
group by `Inspection results`
order by percentage desc;

-- Which product categories have higher defect rates?
select `product type`,
avg(`Defect rates`) as defect_rates
from supply_chain_data
group by `product type`
order by `defect_Rates`;


SELECT
    ROUND(
        (
            COUNT(*) * SUM(`Price` * `Number of products sold`)
            - SUM(`Price`) * SUM(`Number of products sold`)
        ) /
        SQRT(
            (
                COUNT(*) * SUM(`Price` * `Price`)
                - POWER(SUM(`Price`), 2)
            ) *
            (
                COUNT(*) * SUM(`Number of products sold` * `Number of products sold`)
                - POWER(SUM(`Number of products sold`), 2)
            )
        ),
        3
    ) AS price_sales_correlation
FROM supply_chain_data;


-- Is shipping time associated with transportation costs?

SELECT
    ROUND(
        (
            COUNT(*) * SUM(`Shipping times` * `Costs`)
            - SUM(`Shipping times`) * SUM(`Costs`)
        ) /
        SQRT(
            (
                COUNT(*) * SUM(`Shipping times` * `Shipping times`)
                - POWER(SUM(`Shipping times`), 2)
            ) *
            (
                COUNT(*) * SUM(`Costs` * `Costs`)
                - POWER(SUM(`Costs`), 2)
            )
        ),
        3
    ) AS shipping_cost_correlation
FROM supply_chain_data;

-- Are higher defect rates associated with longer lead times?

SELECT
    ROUND(
        (
            COUNT(*) * SUM(`Defect rates` * `Lead time`)
            - SUM(`Defect rates`) * SUM(`Lead time`)
        ) /
        SQRT(
            (
                COUNT(*) * SUM(`Defect rates` * `Defect rates`)
                - POWER(SUM(`Defect rates`), 2)
            ) *
            (
                COUNT(*) * SUM(`Lead time` * `Lead time`)
                - POWER(SUM(`Lead time`), 2)
            )
        ),
        3
    ) AS defect_leadtime_correlation
FROM supply_chain_data;









