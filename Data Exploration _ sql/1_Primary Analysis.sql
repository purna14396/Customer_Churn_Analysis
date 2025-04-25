drop table stagging_churn;

CREATE DATABASE db_churn;

-- Data Exploration – Check Distinct Values

-- 1. Lets see what data we have avaliable
SELECT * FROM stagging_churn;


-- 2. Lets see column wise contributions
-- 2.1 Gender Distribution
SELECT Gender , COUNT(Gender) AS TotalCount,
COUNT(Gender)*100.0/(SELECT COUNT(*) FROM stagging_churn) AS Percentage
FROM stagging_churn
GROUP BY Gender;

-- we can see that around 63.07 % are Females and remaining 36.93% were Males


-- 2.2 Contract Based Distribution
SELECT Contract , COUNT(Contract) AS TotalCount,
COUNT(Contract)*100.0/(SELECT COUNT(*) FROM stagging_churn) AS Percentage
FROM stagging_churn
GROUP BY Contract;
-- we can see that people are more likely to have the month-to-month subscription with 51% than yearly subscriptions


-- 2.3 Customer status vs revenue generated 
SELECT Customer_Status, Count(Customer_Status) as TotalCount,
COUNT(Customer_Status)*100.0/(SELECT COUNT(*) FROM stagging_churn) AS CustPercentage,Sum(Total_Revenue) as TotalRev,
Sum(Total_Revenue) / (Select sum(Total_Revenue) from stagging_Churn) * 100  as RevPercentage
from stagging_Churn
Group by Customer_Status;
-- we can see that almost 66% of people are being stayed with generating the revenue of around 82 % of the over all revenue
-- and the churned people are 26% with generated revenue around 17 % contribution of the overall revenue




-- 2.4 State wise contribution
SELECT State, Count(State) as TotalCount,
Count(State)* 100.0 / (Select Count(*) from stagging_Churn)  as Percentage
from stagging_Churn
Group by State
Order by Percentage desc;
-- we can see that Uttarpradesh and TamilNadu are hte top contributers 
-- chattisgarh and puducherry are the least Contributors 


-- Data Exploration – Check Nulls

-- 1. if we want to check the nulls for each columns we can use distinct keyword

select distinct Internet_type
from stagging_churn;
-- By this we can clearly see the what are all the distinct data names along with the Null values 

