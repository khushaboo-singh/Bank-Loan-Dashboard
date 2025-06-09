 -- This is BFSI domain dataset
 -- Collection of information about the high profile loan given by the banking institution to businesses
 -- we need to analyse the financial health and risk associated with the pattern. 

 create database BFSI_db;

 use BFSI_db;

 create table loan_portfolio
 (loan_id	varchar(max),funded_amount varchar(max),
 funded_date varchar(max),	duration_years varchar(max),duration_months varchar(max),
 Ten_yr_treasury_index_date_funded varchar(max),
 interest_rate_percent	varchar(max),interest_rate varchar(max),
 payments varchar(max),	total_past_payments varchar(max),
 loan_balance varchar(max),	property_value	varchar(max),
 purpose varchar(max),	firstname varchar(max),	middlename varchar(max),lastname varchar(max),
 social varchar(max),	phone varchar(max),	title	varchar(max),employment_length varchar(max),
 BUILDING_CLASS_CATEGORY varchar(max),	TAX_CLASS_AT_PRESENT varchar(max),
 BUILDING_CLASS_AT_PRESENT	varchar(max), ADDRESS1 varchar(max),	ADDRESS2 varchar(max),
 ZIPCODE varchar(max),	CITY varchar(max),	STATE varchar(max),	TOTALUNITS varchar(max),LANDSQUAREFEET varchar(max),
 GROSSSQUAREFEET	 varchar(max),TAXCLASSAT_TIME_OF_SALE varchar(max),);

 SELECT * FROM LOAN_PORTFOLIO;


 Bulk insert loan_portfolio
 from 'C:\Users\Acer\Downloads\LoanPortfolio.csv'
 WITH  (fieldterminator=',', rowterminator='\n', firstrow=2, MAXERRORS=20);

 select column_name, DATA_type  
 from information_schema.columns;

 -- change the datatype as per their data

 alter table loan_portfolio
 alter column FUNDED_AMOUNT MONEY;

 alter table loan_portfolio
 alter column FUNDED_DATE DATE;

 alter table loan_portfolio
 alter column DURATION_YEARS int;

 alter table loan_portfolio
 alter column DURATION_MONTHS int;

 alter table loan_portfolio
 alter column TEN_YR_TREASURY_INDEX_DATE_FUNDED FLOAT;

 alter table loan_portfolio
 alter column INTEREST_RATE_PERCENT FLOAT;

 alter table loan_portfolio
 alter column PAYMENTS MONEY;

 alter table loan_portfolio
 alter column TOTAL_PAST_PAYMENTS int;

 alter table loan_portfolio
 alter column LOAN_BALANCE MONEY;

 alter table loan_portfolio
 alter column PROPERTY_VALUE MONEY;

 alter table loan_portfolio
 alter column totalunits int;

 alter table loan_portfolio
 alter column total_past_payments int;

 alter table loan_portfolio
 alter column LOAN_BALANCE MONEY;

 alter table loan_portfolio
 alter column PROPERTY_VALUE MONEY;

 alter table loan_portfolio
 alter column EMPLOYMENT_LENGTH int;

 alter table loan_portfolio
 alter column totalunits int;

 alter table loan_portfolio
 alter column TOTAL_UNITS int;

 alter table loan_portfolio
 alter column funded_date date;

 select * from loan_portfolio; 

 -- we have 1678 nos loan data

 select DISTINCT loan_id from loan_portfolio   ---we don't have any duplicates

 --- the period of the data for the loan

 select min(funded_date) as 'firstloandate', max(funded_date) as 'lastdaterecorded', datediff(year, min(funded_date),max(funded_date)) as 'total_years'
  from loan_portfolio;       --total 7 years, 1stdate is 2012-01-01 and lastdate 2019-12-27

select * from loan_portfolio;

-- we have a purpose attribute, where we can see the distribution of loans_funded between the various purpose

  select distinct purpose from loan_portfolio;

  --- analyse the purpose wise funded_amount_distribution



select purpose, count(loan_id) as 'total_loans', sum(funded_amount) as 'total_funded_amt',
	avg(funded_amount) as 'avg_funded_amount'
  from loan_portfolio
  group by purpose
  order by total_loans DESC;   --

--LOAN DISTRIBUTION EACH YEAR

select purpose, year(funded_date) as 'the_year',
				count(loan_id) as 'total_loans',
				sum(funded_amount) as 'total_funded_amount',
				avg(funded_amount) as 'avg_funded_amount'
from loan_portfolio
where year(funded_date) = 2012
group by purpose, year(funded_date)
order by total_loans desc;

--- for the year of 2012- the commercial property is the highest as per the total_loans_given

with funded_dist as (
select purpose, year(funded_date) as 'the_year',
				count(loan_id) as 'total_loans',
				sum(funded_amount) as 'total_funded_amount',
				avg(funded_amount) as 'avg_funded_amount',
				row_number () over (partition by purpose order by year(funded_date) ) as row_num
				from loan_portfolio
				group by purpose, year(funded_date))
select * from funded_dist
where row_num =1
ORDER BY funded_dist.total_loans;

-- we want to analyse the year wise which purpose has most loans

with funded_dist as
( select purpose,
				year(funded_date) as 'the_year',
				count(loan_id) as 'total_loans',
				sum(funded_amount) as 'total_funded_amt',
				avg(funded_amount) as 'avg_funded_amt',
				row_number () over (partition by year (funded_date) order by count(loan_id) desc) as row_num
				from loan_portfolio
				group by purpose, year(funded_date))
select * from funded_dist
where row_num =1
order by purpose;

-- purpose type Commercial_property, Home, Investment_property are top loan segment distributes ,among the year (2012-2019)

select min(funded_amount) as 'min_value_funded', avg(funded_amount) as 'mean_value', max(funded_amount) as 'max_funded_amount'
from loan_portfolio;

--- min-440000, avg- 1848830.1549, max- 156000000.

select count(*) from loan_portfolio
where funded_amount between 440000 and 1848829;

select 1259.00/1678.00   /* 75 % data is under this range (min and avg_value)
--- 25% data is goes above this range

-- Segment 1- low_segment - 600000
--- segment 2- between 600001 and 1000000
-- segment 3- above 1000000*/


SELECT 
    purpose, 
    COUNT(loan_id) AS total_loans,
    CASE 
        WHEN funded_amount <= 600000 THEN 'Low_segment'
        WHEN funded_amount BETWEEN 600001 AND 1000000 THEN 'Med_segment'
        ELSE 'High_segment'
    END AS Loan_segment
FROM loan_portfolio
GROUP BY purpose,
    CASE 
        WHEN funded_amount <= 600000 THEN 'Low_segment'
        WHEN funded_amount BETWEEN 600001 AND 1000000 THEN 'Med_segment'
        ELSE 'High_segment'
    END
	ORDER BY TOTAL_LOANS DESC;

--- The banking institution wants to segregate the customers based on their interest rate applicable to their loans

select distinct interest_rate_percent from loan_portfolio;

--- so the distinct interest range is in between 2, 3, 4,5

select COUNT(*) from loan_portfolio
where interest_rate_percent<3.0;    ---we get only 32 loan which int rate is below 3%

SELECT COUNT(*)
FROM loan_portfolio
WHERE interest_rate_percent between 3.0 and 4.0;
--- mostly the loan is distributed in this interest rate range- 1096


SELECT COUNT(*)
FROM loan_portfolio
WHERE interest_rate_percent>4.0;
-- total_loans- 550


select min(funded_amount),avg(funded_amount),max(funded_amount)
from loan_portfolio
where interest_rate_percent>4.0;

select case when funded_amount<12500000 and interest_rate_percent<4.0 then 'Segment1'
			when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
			else 'Segment3' end as 'Customer_segments', 
			avg(loan_balance) as 'loanamtpending'
			from loan_portfolio
			group by 
			case when funded_amount<12500000 and interest_rate_percent<4.0 then 'Segment1'
			when funded_amount between 12500000 and 15000000 and interest_rate_percent<=3.0 then 'segment2'
			else 'Segment3' end ;

select * from loan_portfolio;

select distinct property_value from loan_portfolio;

---Here we need to evaluate the property value, so that in cas of any default bank can ralize the value for non performance
---create a property value sgment in data, create a column with thie namee and impute the segment_indicator as per the property evaluation
 SELECT * FROM loan_portfolio
 WHERE property_value < funded_amount;--- THERE IS NO SUCH DATA(MORTAGE TYPE)

---CREATING A COLUMN WITH THE NAME PROPERTY_SEGMENT

ALTER TABLE LOAN_PORTFOLIO
ADD PROPERTY_SEGMENT VARCHAR(40);


SELECT MIN(PROPERTY_VALUE) AS 'MINIMUM', AVG(PROPERTY_VALUE) AS 'MEAN_POINT', MAX(PROPERTY_VALUE) AS 'MAXIMUM'
FROM LOAN_PORTFOLIO;

--- MIN 473200, MEAN-2012219, MAX-156020900

SELECT * FROM LOAN_PORTFOLIO
WHERE PROPERTY_VALUE <=1500000;
--- IN THIS REANGE WE HAVE 662 LOANS---LOW_VALUE_SEGMENT

SELECT * FROM loan_portfolio
WHERE property_value BETWEEN 1500001 AND 5000000;
---948 --MID_VALUE_SEGMENT

SELECT * FROM LOAN_PORTFOLIO
WHERE PROPERTY_VALUE >=5000000;
--68 --HIGH_VALUE_SEGMENT

SELECT PURPOSE, COUNT(LOAN_ID) AS 'TOTAL_LOANS',
CASE	
	WHEN PROPERTY_VALUE <=1500000 THEN 'LOW_VALUE_SEG'
	WHEN PROPERTY_VALUE BETWEEN 1500001 AND 5000000 THEN 'MID_VALUE_SEG'
	ELSE 'HIGH_VALUE_SEG' END AS 'PROPERTY_SEGMENT'
	FROM LOAN_PORTFOLIO
	GROUP BY PURPOSE,CASE	
	WHEN PROPERTY_VALUE <=1500000 THEN 'LOW_VALUE_SEG'
	WHEN PROPERTY_VALUE BETWEEN 1500001 AND 5000000 THEN 'MID_VALUE_SEG'
	ELSE 'HIGH_VALUE_SEG' END
ORDER BY TOTAL_LOANS DESC;

UPDATE LOAN_PORTFOLIO 
SET PROPERTY_SEGMENT = CASE	
	WHEN PROPERTY_VALUE <=1500000 THEN 'LOW_VALUE_SEG'
	WHEN PROPERTY_VALUE BETWEEN 1500001 AND 5000000 THEN 'MID_VALUE_SEG'
	ELSE 'HIGH_VALUE_SEG' END ;

SELECT * FROM LOAN_PORTFOLIO;

WITH EVAL_SEGMENT_WISE AS (
    SELECT PROPERTY_SEGMENT,  PURPOSE, 
        COUNT(LOAN_ID) AS TOTAL_LOANS, 
        SUM(FUNDED_AMOUNT) AS TOTAL_FUND,
        SUM(LOAN_BALANCE) AS LOAN_BAL_AMT
    FROM LOAN_PORTFOLIO 
    GROUP BY PROPERTY_SEGMENT, PURPOSE
)
SELECT  *, 
TOTAL_FUND - LOAN_BAL_AMT AS AMT_TO_RELEASE,
    ROUND( (CAST(TOTAL_FUND - LOAN_BAL_AMT AS FLOAT) / TOTAL_LOANS) * 100, 2) AS PERC_TO_RELEASE
FROM EVAL_SEGMENT_WISE
ORDER BY TOTAL_LOANS;

SELECT FUNDED_AMOUNT, FUNDED_DATE,YEAR(FUNDED_DATE) AS 'THE_YEAR',MONTH(FUNDED_DATE) AS 'THE_MONTH', DURATION_YEARS, LOAN_BALANCE
FROM LOAN_PORTFOLIO
WHERE PURPOSE = 'PLANE' AND PROPERTY_SEGMENT = 'MID_VALUE_SEG'
ORDER BY YEAR(FUNDED_DATE);

---CORELATION BETWEEN FUNDED_AMOUNT, DURATION , INTEREST_RATE
--TO CHECK THE CORRELATIONS, W WILL TRY TO CRT CORE-COEFFICIENTS
---DURATION_FUNDEDAMT, DURA_INT, FUND_INT

DECLARE @AVG_DUR = AS FLOAT,
		@AVG_FUND AS FLOAT
		@AVG_INT AS FLOAT
SELECT @AVG_DUR = AVG(DURATION_YEARS),
		@AVG_FUND = AVG(FUNDED_AMOUNT),
		@AVG_INT = AVG(INTEREST_RATE)
FROM LOAN_PORTFOLIO

--create corr_coeff betwen duration and fund

DECLARE @CORR_DUR_FUND AS FLOAT

SELECT @CORR_DUR_FUND = SUM((DURATION_YEARS - AVG_DUR) * (FUNDED_AMOUNT - @AVG_FUND)) / SQRT(SUM(POWER(DURATION_YEARS - @AVG_DUR,2))) *
						SQRT(SUM(POWER(DURATION_YEARS - @AVG_DUR,2))) FROM loan_portfolio;
