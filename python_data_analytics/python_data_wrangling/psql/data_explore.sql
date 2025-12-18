-- Show table schema 
\d+ retail;

-- Show first 10 rows
SELECT * FROM retail limit 10;

--Check # of records--
SELECT COUNT(*) from retail;

--Check # of UNIQUE Clients--
SELECT COUNT(DISTINCT customer_id) from retail;

--invoice date range--
SELECT MAX(invoice_date) as max, MIN(invoice_date) as min from retail;

--number of SKU/merchants--
SELECT COUNT(DISTINCT stock_code) from retail;

--avg invoice amount--
SELECT AVG(invoice_total) as avg
from
	(SELECT SUM(quantity * unit_price) AS invoice_total
		from retail
		GROUP BY invoice_no
		HAVING SUM(quantity * unit_price) >0) as total_amount_per_invoice;

--Calculate total revenue--
SELECT SUM(unit_price*quantity) as sum
from retail;

--Calculate total revenue by YYYYMM--
SELECT TO_CHAR(invoice_date, 'YYYYMM') as yyyymm,SUM(unit_price*quantity) as sum
from retail
GROUP BY yyyymm
ORDER BY yyyymm;
