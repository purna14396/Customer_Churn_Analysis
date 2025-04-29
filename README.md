# 📉 Customer Churn Analysis & Prediction – Telecom 

<div align="center">
  <img src="https://github.com/user-attachments/assets/e87a9a1f-fb25-45ac-abb0-c3f6bf22e674" alt="Churn Overview" width="600">
</div>

## 🎯 Objective

In today’s subscription economy, customer retention is more critical than ever. This project aims to:
- Identify churn-prone customer segments
- Understand reasons for churn using data analysis
- Predict churners using a machine learning model
- Deliver actionable insights using **Power BI Dashboards**

---

## 🏢 Project Context: Telecom Industry

Telecommunication companies face high churn rates due to competitive offers, service issues, and pricing concerns. This end-to-end churn analysis project helps businesses:
- Analyze customer behavior across demographics, geography, services, and billing
- Predict which customers are likely to churn
- Recommend targeted retention strategies

---

## 🧾 Dataset Overview

- 📂 7,043 rows × 30+ columns
- 📌 Attributes include:
  - **Demographics**: Gender, Age, Marital Status, State
  - **Services**: Internet Type, Online Security, Streaming Services
  - **Billing**: Monthly Charges, Total Revenue, Refunds
  - **Churn Info**: Customer Status, Category, Reason

<div align="center">
  <img src="https://github.com/user-attachments/assets/f404651c-e800-4a23-9711-faa43fcd1ee1" alt="Data Overview" width="800">
</div>

---

## ⚙️ Tech Stack

| Layer             | Tools Used                              |
|------------------|------------------------------------------|
| **ETL**           | Microsoft SQL Server, SQL Server Management Studio |
| **Data Modeling** | Power BI (DAX, Query Editor, Measures)  |
| **ML Model**      | Python (Random Forest using scikit-learn) |
| **IDE**           | Jupyter Notebook (via Anaconda)         |
| **Storage**       | Local CSV → SQL → Power BI              |

---

## 🔄 Workflow Pipeline

### STEP 1 – ETL in SQL Server

- Cleaned & inserted raw data into `prod_Churn` table  
- Created views:
  - `vw_ChurnData` – Used for ML training
  - `vw_JoinData` – Used for predicting churners


**Remove null and insert the new data into Prod table**
```
SELECT 
    Customer_ID,
    Gender,
    Age,
    Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'None') AS Value_Deal,
    Phone_Service,
    ISNULL(Multiple_Lines, 'No') As Multiple_Lines,
    Internet_Service,
    ISNULL(Internet_Type, 'None') AS Internet_Type,
    ISNULL(Online_Security, 'No') AS Online_Security,
    ISNULL(Online_Backup, 'No') AS Online_Backup,
    ISNULL(Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    ISNULL(Premium_Support, 'No') AS Premium_Support,
    ISNULL(Streaming_TV, 'No') AS Streaming_TV,
    ISNULL(Streaming_Movies, 'No') AS Streaming_Movies,
    ISNULL(Streaming_Music, 'No') AS Streaming_Music,
    ISNULL(Unlimited_Data, 'No') AS Unlimited_Data,
    Contract,
    Paperless_Billing,
    Payment_Method,
    Monthly_Charge,
    Total_Charges,
    Total_Refunds,
    Total_Extra_Data_Charges,
    Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others') AS Churn_Category,
    ISNULL(Churn_Reason , 'Others') AS Churn_Reason
 
INTO [db_Churn].[dbo].[prod_Churn]
FROM [db_Churn].[dbo].[stg_Churn];
```

**Create View for Power BI for prediction**
```
Create View vw_ChurnData as
    select * from prod_Churn where Customer_Status In ('Churned', 'Stayed')
 ```
``` 
Create View vw_JoinData as
    select * from prod_Churn where Customer_Status = 'Joined'
```

### STEP 2 – Power BI Data Modeling

- **Created buckets** for:  
  - Age Group: `<20`, `20–35`, `36–50`, `>50`
  - Monthly Charges: `<20`, `20–50`, `50–100`, `>100`
  - Tenure Group: `<6M`, `6–12M`, `12–18M`, `18–24M`, `>24M`
- Unpivoted service columns
- Calculated measures for Churn Rate, New Joiners, Total Revenue

### STEP 3 – Power BI Dashboard

<div align="center">
  <img src="https://github.com/user-attachments/assets/3667eb5f-1bdf-4bbe-b761-8bb4490dc66e" alt="Power BI Dashboard 1" width="1000">
  <img src="https://github.com/user-attachments/assets/57b34c91-f856-4786-baac-33bc542057e0" alt="Power BI Dashboard 2" width="600">
</div>

---

## 🤖 STEP 4 – Machine Learning: Random Forest

### ✔️ Process:
- Used `vw_ChurnData` for training the model
- Encoded categorical variables using `LabelEncoder`
- Model trained using `RandomForestClassifier(n_estimators=100)`
- Evaluated using:
  - Accuracy, F1-Score, Confusion Matrix
  - Feature importance visualization

```python
from sklearn.ensemble import RandomForestClassifier
rf_model = RandomForestClassifier(n_estimators=100, random_state=42)
rf_model.fit(X_train, y_train)
```

## 📊 Performance Comparison: Before vs After Handling Imbalanced Dataset

Understanding the impact of class imbalance is crucial for building robust models. Below are visual comparisons showing model performance **before** and **after** applying techniques to balance the dataset (e.g., SMOTE, Resampling Technique).

## 🧠 Explanation:
- Initially, I used SMOTE (Synthetic Minority Over-sampling Technique) to handle class imbalance in the dataset (71.17% vs 28.83%). However, this approach reduced model performance due to the synthetic samples not accurately reflecting the real data distribution, which likely led to overfitting and poor generalization.

- Later, I switched to a resampling technique (e.g., undersampling the majority class or combining over/under sampling) and observed significant improvement in accuracy, recall, and overall performance. This indicates that the resampled data offered a better balance without distorting the underlying patterns, leading to a model that generalizes better to unseen data.

---
## 🔴 Before Handling Imbalanced Data    &nbsp;&nbsp;  🟢 After Handling Imbalanced Data
<img src="https://github.com/user-attachments/assets/3a280be6-6c28-4b21-8569-589b6dcba856" alt="After Imbalance Handling" width="500"/> 

<img src="https://github.com/user-attachments/assets/f5494aca-85a7-4038-8695-c855f560af7b" alt="Before Imbalance Handling" width="500"/>


> ✅ After balancing, we observe improved recall and F1-score for the minority class, indicating better detection of churned customers.

---

## 📈 STEP 5 – Predicting Churn on New Customers

- Used `vw_JoinData` as new input
- Predicted customer status → filtered for predicted churners
- Exported to CSV → connected back to Power BI

```python
new_predictions = rf_model.predict(new_data)
original_data['Customer_Status_Predicted'] = new_predictions
```

<div align="center">
  <img src="https://github.com/user-attachments/assets/ea8a2b9b-c340-442f-a924-b4e6375a8260" alt="Feature Importance" width="1000">
</div>
---

## 📌 Key Insights & Recommendations

| Insight                                     | Action                                                  |
|---------------------------------------------|---------------------------------------------------------|
| 🔻 Premium Support reduces churn (16.51%)   | Promote value-added plans                              |
| 🗺️ J&K & Assam have high churn (>40%)       | Target with loyalty offers                             |
| 💳 Monthly contracts churn more             | Offer annual incentives                                |
| 🚫 No Online Security & Backup → higher churn        | Bundle security services                      |
| 📺 Streaming bundles reduce churn           | Cross-sell media services                              |
---
### Continuously optimize product services and stay competitive with evolving market offerings

## 💡 Business Value

- 📉 **Reduced customer churn by proactive targeting**
- 🔮 **Predicted potential churners for 1:1 marketing**
- 📊 **Powerful, live dashboards for strategic decisions**


---

## 🚀 Future Enhancements

- Switch to Azure SQL + Data Factory (for production pipelines)
- Hyperparameter tuning for Random Forest
- Compare model with XGBoost and Logistic Regression
- Add customer lifetime value estimation

---

## 📬 Let’s Connect!

> 💼 Built by Purna sai

> 📫 For queries, collaborations or walkthroughs – DM me!
