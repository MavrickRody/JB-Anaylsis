---Importing CSV into SQL Server---

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick
FROM traffic_data t
GROUP BY t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick
FROM traffic_data t
WHERE t.channel_type = 'unpaid'
GROUP BY t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick
FROM traffic_data t
WHERE t.channel_type = 'paid'
GROUP BY t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick,
	t.marketing_partner_id
FROM traffic_data t
GROUP BY t.marketing_partner_id,
		 t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick,
	t.marketing_partner_id
FROM traffic_data t
WHERE t.channel_type = 'unpaid'
GROUP BY t.marketing_partner_id,
		 t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick,
	t.marketing_partner_id
FROM traffic_data t
WHERE t.channel_type = 'paid'
GROUP BY t.marketing_partner_id,
		 t.channel

SELECT
	t.channel,
	SUM(CAST(t.cpc AS MONEY)) AS TotalCostPerClick,
	t.marketing_partner_id,
	p.date
FROM traffic_data t
INNER JOIN performance_data p
	ON p.marketing_partner_id = t.marketing_partner_id
GROUP BY p.date,
		 t.marketing_partner_id,
		 t.channel
ORDER BY t.marketing_partner_id

--Total Traffic---
SELECT
	COUNT(*) AS TCount,
	channel
FROM traffic_data
GROUP BY channel

--Total Traffic by CostperClick
SELECT
	SUM(CAST(cpc AS MONEY)) AS TotalCPC,
	channel
FROM traffic_data
GROUP BY channel
-----#####-Customer Related--#####-
SELECT
	*
FROM customer_data
SELECT
	*
FROM performance_data
SELECT
	*
FROM traffic_data

---Total RPC---------
SELECT
	SUM(CAST(rpc AS MONEY))
FROM customer_data

--Total RPC by Customer---
SELECT
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS RPC
FROM customer_data
GROUP BY customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) DESC

---Toal RPC by Customer and Date---
SELECT
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	import_timestamp
FROM customer_data
GROUP BY customer_id,
		 import_timestamp
ORDER BY SUM(CAST(rpc AS MONEY)) DESC

--Finding the Best Customer -- from where we have earned RPC---

SELECT
	SUM(CAST(rpc AS MONEY)) AS RPC,
	c.customer_id
FROM customer_data c
GROUP BY c.customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) DESC



--Finding the Best Customer -- from where we have earned RPC--- with date

SELECT
	SUM(CAST(rpc AS MONEY)) AS RPC,
	c.customer_id,
	c.import_timestamp
FROM customer_data c
GROUP BY c.customer_id,
		 c.import_timestamp
ORDER BY SUM(CAST(rpc AS MONEY)) DESC


--1.-----Total Reveune Per Click------
Create view TotalRevenuePerClick
As
SELECT
	SUM(CAST(rpc AS MONEY)) AS TotalRPC
FROM dbo.customer_data

----Total Reveune Per Click by Job_ID----Occurance Once---
Create view TotalRevenuePerClick_by_jobID
As
SELECT
	job_Id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY job_id
HAVING COUNT(*) = 1

------Total Reveune Per Click by Job_ID----Occurance Twice---
--select job_Id,sum(cast(rpc as money)) as TotalRPC,count(*) from customer_data group by job_id having count(*)>1

----Total Reveune Per Click by Customer ID 
Create view TotalRevenuePerClick_by_Customer
As
SELECT
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY customer_id

----Total Reveune Per Click by Customer ID --Top 10 Customer by Reveune
Create view Top10Customer_by_RPC
As
SELECT TOP 10
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) DESC

----Total Reveune Per Click by Customer ID --Top 20 Customer by Reveune
Create view Top20Customer_by_RPC
As
SELECT TOP 20
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) DESC


----Total Reveune Per Click by Customer ID --Top 20 Customer by Reveune- performing low----
Create view Low10Customer_by_RPC
As
SELECT TOP 20
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) ASC

----Total Reveune Per Click by Customer ID --Top 40 Customer by Reveune- performing low----
Create view Low40Customer_by_RPC
As
SELECT TOP 40
	customer_id,
	SUM(CAST(rpc AS MONEY)) AS TotalRPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) ASC


--Since the DateTimeStamp is in the constant form so we can apply the static values for extraction otherwise Dynamic Extraction is preferred---
SELECT
	SUBSTRING(import_timestamp, 1, 4) AS DYear,
	SUBSTRING(import_timestamp, 6, 2) AS DMonth,
	SUBSTRING(import_timestamp, 9, 2) AS DDay,
	SUBSTRING(import_timestamp, 11, 9) AS DTime,
	*
FROM customer_data
 


----Checking on which Day of the Month has profitable more RPC--------
----Top performing by Year---------
Create view TopperformingbyYear
As
SELECT TOP 20
	SUBSTRING(import_timestamp, 1, 4) AS DYear,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 1, 4)
ORDER BY SUM(CAST(rpc AS MONEY)) DESC


----Checking on which Day of the Month has profitable more RPC--------
----Top performing Months of the Year---------
Create view TopperformingMonthsoftheYear
As
SELECT TOP 20
	SUBSTRING(import_timestamp, 6, 2) AS DMonth,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 6, 2)
ORDER BY SUM(CAST(rpc AS MONEY)) DESC



----Checking on which Day of the Month has profitable more RPC--------
----Low performing Months of the Year---------
Create view LowperformingMonths
As
SELECT TOP 1
	SUBSTRING(import_timestamp, 6, 2) AS DMonth,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 6, 2)
ORDER BY SUM(CAST(rpc AS MONEY)) ASC


----Checking on which Day of the Month has profitable more RPC--------
----Top performing Days of the Months---------
Create view TopperformingDaysoftheMonths
As
SELECT TOP 20
	SUBSTRING(import_timestamp, 9, 2) AS DDay,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 9, 2)
ORDER BY SUM(CAST(rpc AS MONEY)) DESC


----Checking on which Day of the Month has been less profitable more RPC--------
----Low performing Days of the Months---------
Create view LowperformingDaysoftheMonths
As
SELECT TOP 20
	SUBSTRING(import_timestamp, 9, 2) AS DDay,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 9, 2)
ORDER BY SUM(CAST(rpc AS MONEY)) ASC


----Checking on which Time of the Day has been more profitable more RPC--------
----Top performin Times by Day---------
Create view TopperforminTimesbyDay
As
SELECT TOP 5
	SUBSTRING(import_timestamp, 11, 9) AS DTime,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 11, 9)
ORDER BY SUM(CAST(rpc AS MONEY)) DESC

----Checking on which Time of the Day has been more profitable more RPC--------
----Low performin Times by Day---------
Create view LowperformingTimesbyDay
As
SELECT TOP 5
	SUBSTRING(import_timestamp, 11, 9) AS DTime,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 11, 9)
ORDER BY SUM(CAST(rpc AS MONEY)) ASC


----Checking on which Time of the Day has been more profitable more RPC--------
----Occurances by Day--------- greater the number of occurances - greater the RPC
--Occurances are directly proportional to RPC---
Create view OccurancesaredirectlyproportionaltoRPC
As
SELECT
	SUBSTRING(import_timestamp, 11, 9) AS DTime,
	SUM(CAST(rpc AS MONEY)) AS RPC,
	COUNT(*) AS Occurances
FROM customer_data
GROUP BY SUBSTRING(import_timestamp, 11, 9)
 


----Anaylsis of Traffic Table--Individually---

--Total CPC---
Create view TotalCPC
As
SELECT
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data
 

--Highest Amount Paid to CPC -- Meaning this is the major source of Traffic--high performing
Create view HighestAmountPaidtoCPC
As
SELECT TOP 1
	channel,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data
GROUP BY channel
ORDER BY SUM(CAST(cpc AS MONEY)) DESC

--Low Performing Source by CPC--Desc
Create view LowPerformingSourcebyCPC
As
SELECT TOP 1
	channel,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data
WHERE channel_type = 'Paid'
GROUP BY channel
ORDER BY SUM(CAST(cpc AS MONEY)) ASC

--Top 3 Markerting Partner -- Meaning this is the major source of Traffic--high performing
Create view Top3MarkertingPartner
As
SELECT TOP 3
	marketing_partner_id,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data t
GROUP BY marketing_partner_id
ORDER BY SUM(CAST(cpc AS MONEY)) DESC


--Low 3 Markerting Partner -- Meaning this is the major source of Traffic--high performing
Create view Low3MarkertingPartner
As
SELECT TOP 3
	marketing_partner_id,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data t
GROUP BY marketing_partner_id
ORDER BY SUM(CAST(cpc AS MONEY)) ASC


--With Channels---

--Top 3 Markerting Partner -- Meaning this is the major source of Traffic--high performing
Create view Top3MarkertingPartner
As
SELECT TOP 3
	marketing_partner_id,
	channel,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data t
GROUP BY marketing_partner_id,
		 channel
ORDER BY SUM(CAST(cpc AS MONEY)) DESC


--Low 3 Markerting Partner -- Meaning this is the major source of Traffic--high performing
Create view Low3MarkertingPartner
As
SELECT TOP 3
	marketing_partner_id,
	channel,
	SUM(CAST(cpc AS MONEY)) AS [Cost Per Click]
FROM traffic_data t
GROUP BY marketing_partner_id,
		 channel
ORDER BY SUM(CAST(cpc AS MONEY)) ASC


---Top 5 Job----
Create view Top5Job
As
SELECT TOP 5
	job_id,
	COUNT(*) AS Occurances
FROM performance_data
GROUP BY job_id
ORDER BY COUNT(*) DESC


---Top 5 Job by Makerting Partner----
Create view Top5JobbyMakertingPartner
As
SELECT TOP 5
	job_id,
	marketing_partner_id,
	COUNT(*) AS Occurances
FROM performance_data
GROUP BY job_id,
		 marketing_partner_id
ORDER BY COUNT(*) DESC



---Top 5 Job by Customer----
Create view Top5JobbyCustomer
As
SELECT TOP 5
	p.job_id,
	c.customer_id,
	COUNT(*) AS Occurances
FROM performance_data p
INNER JOIN customer_data c
	ON c.job_id = p.job_id
GROUP BY p.job_id,
		 c.customer_id
ORDER BY COUNT(*) DESC

---Top 10 Job by Customer and RPC----
Create view Top10JobbyCustomerandRPC
As
SELECT TOP 10
	p.job_id,
	c.customer_id,
	SUM(CAST(rpc AS MONEY)) AS Occurances
FROM performance_data p
INNER JOIN customer_data c
	ON c.job_id = p.job_id
GROUP BY p.job_id,
		 c.customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) DESC


---Low 10 Job by Customer and RPC----
Create view Low10JobbyCustomerandRPC
As
SELECT TOP 20
	p.job_id,
	c.customer_id,
	SUM(CAST(rpc AS MONEY)) AS Occurances
FROM performance_data p
INNER JOIN customer_data c
	ON c.job_id = p.job_id
GROUP BY p.job_id,
		 c.customer_id
ORDER BY SUM(CAST(rpc AS MONEY)) ASC


---clicks ---
Create view NumberofClicksNTCPC
As
SELECT
	(x.numberofclicks * CAST(cpc AS MONEY)) AS TotalCPC,
	t.marketing_partner_id,
	x.numberofclicks,
	t.channel
FROM traffic_data t
INNER JOIN (SELECT
	COUNT(click_id) AS numberofclicks,
	marketing_partner_id
FROM performance_data
GROUP BY marketing_partner_id) x
	ON t.marketing_partner_id = x.marketing_partner_id
 
--order by x.numberofclicks desc
--group by 
--grouping  SETS
--	(
--		(t.marketing_partner_id), --1st grouping set
--		(numberofclicks) --2nd grouping set
--	)


---TOP 10 JOBS -------
Create view TOP10JOBS
As
SELECT TOP 20
	job_id,
	COUNT(*) Occurances
FROM performance_data
GROUP BY job_id
HAVING COUNT(*) > 4
ORDER BY COUNT(*) DESC

----LOW PERFORMING JOBS---
Create view LOWPERFORMINGJOBS
As
SELECT TOP 20
	job_id,
	COUNT(*) Occurances
FROM performance_data
GROUP BY job_id
ORDER BY COUNT(*) ASC

---TOP 20 JOBS BY MAKERKERTING PARTNER---
Create view TOP20JOBSBYMAKERKERTINGPARTNER
As
SELECT TOP 20
	marketing_partner_id,
	job_id,
	COUNT(*) Occurances
FROM performance_data
GROUP BY job_id,
		 marketing_partner_id
HAVING COUNT(*) > 4
ORDER BY COUNT(*) DESC

---LOW 20 JOBS BY MAKERKERTING PARTNER---
Create view LOW20JOBSBYMAKERKERTINGPARTNER
As
SELECT TOP 20
	marketing_partner_id,
	job_id,
	COUNT(*) Occurances
FROM performance_data
GROUP BY job_id,
		 marketing_partner_id
HAVING COUNT(*) > 4
ORDER BY COUNT(*) ASC


---Clicks per partner---
Create view Clicksperpartner
As
SELECT
	COUNT(*) AS NumberofClicks,
	marketing_partner_id
FROM performance_data
GROUP BY marketing_partner_id
ORDER BY NumberofClicks DESC

---Clicks per job---
SELECT
	COUNT(*) AS NumberofClicks,
	job_id
FROM performance_data
GROUP BY job_id
ORDER BY NumberofClicks DESC

---Clicks per session---
SELECT
	COUNT(*) AS NumberofClicks,
	session_id
FROM performance_data
GROUP BY session_id
ORDER BY NumberofClicks DESC

---Clicks per session---
SELECT
	COUNT(*) AS NumberofClicks,
	user_id
FROM performance_data
GROUP BY user_id
ORDER BY NumberofClicks DESC



