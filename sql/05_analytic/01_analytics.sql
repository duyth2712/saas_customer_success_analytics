-- =============================================
-- Description:	This script contains SQL queries to analyze key SaaS metrics such as active customers, MRR, churn rate, engagement, retention, and CS activity. These insights help drive data-informed decisions for customer success strategies.
-- =============================================

-- 1. Active Customers & MRR by plan_type
-- Description: Shows monthly active customers and total MRR 
-- Insight: Measures growth and revenue per plan type, helps identify top-performing plans
SELECT
    DATEPART(YEAR, s.subscription_start_date) AS year,
    DATEPART(MONTH, s.subscription_start_date) AS month,
    s.plan_type,
    COUNT(DISTINCT s.customer_id) AS active_customers,
    SUM(s.monthly_fee) AS MRR
FROM dbo.subscription s
WHERE s.subscription_status = 'active'
GROUP BY DATEPART(YEAR, s.subscription_start_date),
         DATEPART(MONTH, s.subscription_start_date),
         s.plan_type
ORDER BY year, month, plan_type;

-- 2. Churn Rate by month
-- Description: Calculates the percentage of customers who cancelled subscriptions per month
-- Insight: Key SaaS metric to identify months with high churn and support retention strategies
WITH cancelled_sub AS (
    SELECT customer_id, subscription_start_date
    FROM dbo.subscription
    WHERE subscription_status = 'cancelled'
)
SELECT
    DATEPART(YEAR, s.subscription_start_date) AS year,
    DATEPART(MONTH, s.subscription_start_date) AS month,
    COUNT(DISTINCT CASE WHEN s.subscription_status='cancelled' THEN s.customer_id END) * 1.0 
        / NULLIF(COUNT(DISTINCT s.customer_id),0) AS churn_rate
FROM dbo.subscription s
LEFT JOIN cancelled_sub c
    ON s.customer_id = c.customer_id
GROUP BY DATEPART(YEAR, s.subscription_start_date),
         DATEPART(MONTH, s.subscription_start_date)
ORDER BY year, month;

-- 3. Engagement & Feature Usage
-- Description: Tracks average feature usage score and total monthly active users per month
-- Insight: Helps understand product adoption and user activity trends
SELECT
    DATEPART(YEAR, e.last_login_date) AS year,
    DATEPART(MONTH, e.last_login_date) AS month,
    AVG(e.feature_usage_score) AS avg_feature_score,
    SUM(e.monthly_active_users) AS MAU
FROM dbo.engagement e
GROUP BY DATEPART(YEAR, e.last_login_date),
         DATEPART(MONTH, e.last_login_date)
ORDER BY year, month;

-- 4. Retention & Churn Risk
-- Description: Shows 6-month and 12-month retention rates and churn risk score for each customer
-- Insight: Evaluates customer loyalty and identifies at-risk customers for prioritizing CS actions
SELECT
    r.customer_id,
    r.retention_rate_6m,
    r.retention_rate_12m,
    r.churn_risk_score
FROM dbo.retention_risk r
ORDER BY r.customer_id;

-- 5. CS Activity Insights
-- Description: Shows last CS touch date and notes per customer
-- Insight: Links CS activity with customer metrics to analyze its impact on retention and churn
SELECT
    c.customer_id,
    c.customer_name,
    ca.last_success_touch_date,
    ca.notes
FROM dbo.customer c
LEFT JOIN dbo.cs_activity ca
    ON c.customer_id = ca.customer_id;


-- 6. Total MRR by Industry & Account Manager
-- Description: Aggregates total MRR and number of active customers per industry and account manager
-- Insight: Identifies high-value industries and which account managers drive revenue
SELECT
    c.industry,
    c.account_manager,
    SUM(s.monthly_fee) AS total_MRR,
    COUNT(DISTINCT s.customer_id) AS active_customers
FROM dbo.subscription s
JOIN dbo.customer c
    ON s.customer_id = c.customer_id
WHERE s.subscription_status = 'active'
GROUP BY c.industry, c.account_manager
ORDER BY total_MRR DESC;

-- 7. Top industries with highest churn
-- Description: Calculates churn rate per industry based on cancelled subscriptions
-- Insight: Highlights industries at risk of losing customers
WITH cancelled_sub AS (
    SELECT customer_id
    FROM dbo.subscription
    WHERE subscription_status = 'cancelled'
)
SELECT
    c.industry,
    COUNT(DISTINCT ch.customer_id) AS churned_customers,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    CAST(COUNT(DISTINCT ch.customer_id) AS FLOAT) / COUNT(DISTINCT s.customer_id) AS churn_rate
FROM dbo.customer c
JOIN dbo.subscription s
    ON c.customer_id = s.customer_id
LEFT JOIN cancelled_sub ch
    ON s.customer_id = ch.customer_id
GROUP BY c.industry
ORDER BY churn_rate DESC;

-- 8. Retention rate by signup month
-- Description: Shows average 6-month and 12-month retention for customers grouped by signup month
-- Insight: Helps track how cohorts retain over time
SELECT
    DATEPART(YEAR, s.subscription_start_date) AS signup_year,
    DATEPART(MONTH, s.subscription_start_date) AS signup_month,
    AVG(r.retention_rate_6m) AS avg_retention_6m,
    AVG(r.retention_rate_12m) AS avg_retention_12m
FROM dbo.subscription s
JOIN dbo.retention_risk r
    ON s.customer_id = r.customer_id
GROUP BY DATEPART(YEAR, s.subscription_start_date),
         DATEPART(MONTH, s.subscription_start_date)
ORDER BY signup_year, signup_month;

-- 9. Top 10 most active customers
-- Description: Shows top customers by monthly active users and feature usage score
-- Business Insight: Identifies key customers for upsell, rewards, or case studies
SELECT TOP 10
    c.customer_name,
    e.monthly_active_users,
    e.feature_usage_score,
    c.account_manager
FROM dbo.engagement e
JOIN dbo.customer c
    ON e.customer_id = c.customer_id
ORDER BY e.monthly_active_users DESC, e.feature_usage_score DESC;

-- 10. Link CS activity with Retention
-- Description: Aggregates CS touches per account manager and links to average retention and churn risk
-- Business Insight: Evaluates effectiveness of CS activities and prioritizes accounts for engagement
SELECT
    c.account_manager,
    COUNT(DISTINCT ca.customer_id) AS touched_customers,
    AVG(r.retention_rate_6m) AS avg_retention_6m,
    AVG(r.churn_risk_score) AS avg_churn_risk
FROM dbo.cs_activity ca
JOIN dbo.customer c
    ON ca.customer_id = c.customer_id
JOIN dbo.retention_risk r
    ON ca.customer_id = r.customer_id
GROUP BY c.account_manager
ORDER BY avg_retention_6m DESC;