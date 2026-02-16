DECLARE @FilePath NVARCHAR(4000) = N'C:\GIT\saas_cs_analytics\data\b2b-saas-usage-retention.csv';
DECLARE @sql NVARCHAR(MAX);

TRUNCATE TABLE raw.customer_success_load;

SET @sql = N'
BULK INSERT raw.customer_success_load
FROM ' + QUOTENAME(@FilePath,'''') + N'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = '','',
    ROWTERMINATOR = ''0x0a'',
    CODEPAGE = ''65001'',
    TABLOCK,
    KEEPNULLS
);';

EXEC sys.sp_executesql @sql;

INSERT INTO raw.customer_success
(
  customer_id, customer_name, industry, account_manager,
  subscription_start_date, subscription_end_date, subscription_status, plan_type,
  monthly_fee, user_count, last_login_date, monthly_active_users,
  feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
  last_success_touch_date, notes
)
SELECT
  customer_id, customer_name, industry, account_manager,
  subscription_start_date, subscription_end_date, subscription_status, plan_type,
  monthly_fee, user_count, last_login_date, monthly_active_users,
  feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
  last_success_touch_date, notes
FROM raw.customer_success_load;
GO