
select * from prod_churn;

-- we can see that in our Churn Category ( churned , stayed , joiners )  
-- we can use the views to view them in seperate tables 

-- 1_ Create view for existing data based on stayed and churned 

Create view vw_ChurnData as
select * from prod_churn where Customer_Status in ('Churned','Stayed');

-- drop view vw_churndata;

-- 2_ Create view for existing data based on stayed and churned 

Create view vw_JoinData as
select * from prod_churn where Customer_Status = 'Joined';



Select * from vw_ChurnData;
Select count(*) from vw_ChurnData;

Select * from vw_JoinData;
Select count(*) from vw_JoinData;