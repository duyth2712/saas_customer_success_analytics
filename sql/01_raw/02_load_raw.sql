-- =============================================
-- Description:	Load data into raw tables
-- =============================================

-- File path
--DECLARE @FilePath NVARCHAR(4000) = N'C:\GIT\saas_cs_analytics\data\b2b-saas-usage-retention.csv';
DECLARE @FilePath NVARCHAR(4000) = N'C:\GIT\saas_cs_analytics\data\b2b-saas-usage-retention-p2.csv';
DECLARE @sql NVARCHAR(MAX);

-- Clear temp table
TRUNCATE TABLE raw.CustomerSuccessLoad;

-- Load CSV into temp table
SET @sql = N'
BULK INSERT raw.CustomerSuccessLoad
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

-- Create batch id
INSERT INTO raw.LoadRun(source_file) VALUES (@FilePath);
DECLARE @batch_id BIGINT = SCOPE_IDENTITY();
	
-- Insert data into raw table
INSERT INTO raw.CustomerSuccess
(
  batch_id,customer_id, customer_name, industry, account_manager,
  subscription_start_date, subscription_end_date, subscription_status, plan_type,
  monthly_fee, user_count, last_login_date, monthly_active_users,
  feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
  last_success_touch_date, notes
)
SELECT
  @batch_id,customer_id, customer_name, industry, account_manager,
  subscription_start_date, subscription_end_date, subscription_status, plan_type,
  monthly_fee, user_count, last_login_date, monthly_active_users,
  feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
  last_success_touch_date, notes
FROM raw.CustomerSuccessLoad;
GO