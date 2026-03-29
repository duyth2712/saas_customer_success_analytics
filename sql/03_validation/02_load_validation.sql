-- =============================================
-- Description: Validate data in staging tables and load into validation tables
-- =============================================

-- Truncate validation tables before loading new data
TRUNCATE TABLE val.CustomerSuccessValid;
TRUNCATE TABLE val.CustomerSuccessReject;
GO

-- Get the latest batch_id from staging.CustomerSuccess
IF OBJECT_ID('tempdb..#dq','U') IS NOT NULL
    DROP TABLE #dq;
-- Perform data validation and separate valid and invalid records
SELECT
    s.batch_id,
    s.load_dttm,

    s.customer_id,
    s.customer_name,
    s.industry,
    s.account_manager,

    s.subscription_start_date,
    s.subscription_end_date,
    s.subscription_status,
    s.plan_type,

    s.monthly_fee,
    s.user_count,
    s.last_login_date,
    s.monthly_active_users,

    s.feature_usage_score,
    s.retention_rate_6m,
    s.retention_rate_12m,
    s.churn_risk_score,

    s.last_success_touch_date,
    s.notes,

    CASE
        WHEN NULLIF(LTRIM(RTRIM(s.customer_id)), '') IS NULL THEN 0
        WHEN s.subscription_start_date IS NOT NULL
             AND s.subscription_end_date IS NOT NULL
             AND s.subscription_end_date < s.subscription_start_date THEN 0
        WHEN s.monthly_fee IS NOT NULL AND s.monthly_fee < 0 THEN 0
        WHEN s.user_count IS NOT NULL AND s.user_count < 0 THEN 0
        WHEN s.monthly_active_users IS NOT NULL AND s.monthly_active_users < 0 THEN 0
        WHEN s.monthly_active_users IS NOT NULL AND s.user_count IS NOT NULL
             AND s.monthly_active_users > s.user_count THEN 0
        WHEN s.feature_usage_score IS NOT NULL AND (s.feature_usage_score < 0 OR s.feature_usage_score > 100) THEN 0
        WHEN s.retention_rate_6m IS NOT NULL AND (s.retention_rate_6m < 0 OR s.retention_rate_6m > 100) THEN 0
        WHEN s.retention_rate_12m IS NOT NULL AND (s.retention_rate_12m < 0 OR s.retention_rate_12m > 100) THEN 0
        WHEN s.churn_risk_score IS NOT NULL AND (s.churn_risk_score < 0 OR s.churn_risk_score > 1) THEN 0
        ELSE 1
    END AS dq_is_valid,

    NULLIF(LTRIM(RTRIM(CONCAT(
        CASE WHEN NULLIF(LTRIM(RTRIM(s.customer_id)), '') IS NULL THEN 'missing_customer_id; ' ELSE '' END,
        CASE WHEN s.subscription_start_date IS NOT NULL AND s.subscription_end_date IS NOT NULL AND s.subscription_end_date < s.subscription_start_date THEN 'end_before_start; ' ELSE '' END,
        CASE WHEN s.monthly_fee IS NOT NULL AND s.monthly_fee < 0 THEN 'negative_monthly_fee; ' ELSE '' END,
        CASE WHEN s.user_count IS NOT NULL AND s.user_count < 0 THEN 'negative_user_count; ' ELSE '' END,
        CASE WHEN s.monthly_active_users IS NOT NULL AND s.monthly_active_users < 0 THEN 'negative_mau; ' ELSE '' END,
        CASE WHEN s.monthly_active_users IS NOT NULL AND s.user_count IS NOT NULL AND s.monthly_active_users > s.user_count THEN 'mau_gt_users; ' ELSE '' END,
        CASE WHEN s.feature_usage_score IS NOT NULL AND (s.feature_usage_score < 0 OR s.feature_usage_score > 100) THEN 'feature_usage_out_of_range; ' ELSE '' END,
        CASE WHEN s.retention_rate_6m IS NOT NULL AND (s.retention_rate_6m < 0 OR s.retention_rate_6m > 100) THEN 'retention_6m_out_of_range; ' ELSE '' END,
        CASE WHEN s.retention_rate_12m IS NOT NULL AND (s.retention_rate_12m < 0 OR s.retention_rate_12m > 100) THEN 'retention_12m_out_of_range; ' ELSE '' END,
        CASE WHEN s.churn_risk_score IS NOT NULL AND (s.churn_risk_score < 0 OR s.churn_risk_score > 1) THEN 'churn_risk_out_of_range; ' ELSE '' END
    ))), '') AS dq_issue
INTO #dq
FROM stag.CustomerSuccess s;

-- Insert valid records into val.CustomerSuccessValid and invalid records into val.CustomerSuccessReject
INSERT INTO val.CustomerSuccessValid
(
    batch_id, load_dttm,
    customer_id, customer_name, industry, account_manager,
    subscription_start_date, subscription_end_date, subscription_status, plan_type,
    monthly_fee, user_count, last_login_date, monthly_active_users,
    feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
    last_success_touch_date, notes
)
SELECT
    batch_id, load_dttm,
    customer_id, customer_name, industry, account_manager,
    subscription_start_date, subscription_end_date, subscription_status, plan_type,
    monthly_fee, user_count, last_login_date, monthly_active_users,
    feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
    last_success_touch_date, notes
FROM #dq
WHERE dq_is_valid = 1;

INSERT INTO val.CustomerSuccessReject
(
    batch_id, load_dttm,
    customer_id, customer_name, industry, account_manager,
    subscription_start_date, subscription_end_date, subscription_status, plan_type,
    monthly_fee, user_count, last_login_date, monthly_active_users,
    feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
    last_success_touch_date, notes,
    dq_is_valid, dq_issue
)
SELECT
    batch_id, load_dttm,
    customer_id, customer_name, industry, account_manager,
    subscription_start_date, subscription_end_date, subscription_status, plan_type,
    monthly_fee, user_count, last_login_date, monthly_active_users,
    feature_usage_score, retention_rate_6m, retention_rate_12m, churn_risk_score,
    last_success_touch_date, notes,
    dq_is_valid, 
	COALESCE(dq_issue, N'unknown_issue') AS dq_issue
FROM #dq
WHERE dq_is_valid = 0;

DROP TABLE #dq;
GO