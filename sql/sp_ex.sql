INSERT INTO core.dim_customer
(
    customer_id,
    customer_name,
    industry,
    account_manager,
    user_count
)
SELECT DISTINCT
    customer_id,
    customer_name,
    industry,
    account_manager,
    user_count
FROM stag.v_customer_success_validate
WHERE
    invalid_mandatory_flag = 0
AND invalid_date_flag = 0
AND invalid_usage_flag = 0
AND invalid_retention_flag = 0
AND invalid_domain_flag = 0
AND invalid_numeric_flag = 0;
INSERT INTO core.dim_customer
(
    customer_id,
    customer_name,
    industry,
    account_manager,
    user_count
)
SELECT DISTINCT
    customer_id,
    customer_name,
    industry,
    account_manager,
    user_count
FROM stag.v_customer_success_validate
WHERE
    invalid_mandatory_flag = 0
AND invalid_date_flag = 0
AND invalid_usage_flag = 0
AND invalid_retention_flag = 0
AND invalid_domain_flag = 0
AND invalid_numeric_flag = 0;
INSERT INTO core.fact_engagement
(
    customer_id,
    last_login_date,
    monthly_active_users,
    feature_usage_score
)
SELECT
    customer_id,
    last_login_date,
    monthly_active_users,
    feature_usage_score
FROM stag.v_customer_success_validate
WHERE
    invalid_mandatory_flag = 0
AND invalid_date_flag = 0
AND invalid_usage_flag = 0
AND invalid_retention_flag = 0
AND invalid_domain_flag = 0
AND invalid_numeric_flag = 0;
INSERT INTO core.fact_retention_risk
(
    customer_id,
    retention_rate_6m,
    retention_rate_12m,
    churn_risk_score
)
SELECT
    customer_id,
    retention_rate_6m,
    retention_rate_12m,
    churn_risk_score
FROM stag.v_customer_success_validate
WHERE
    invalid_mandatory_flag = 0
AND invalid_date_flag = 0
AND invalid_usage_flag = 0
AND invalid_retention_flag = 0
AND invalid_domain_flag = 0
AND invalid_numeric_flag = 0;
INSERT INTO core.fact_cs_activity
(
    customer_id,
    last_success_touch_date,
    notes
)
SELECT
    customer_id,
    last_success_touch_date,
    notes
FROM stag.v_customer_success_validate
WHERE
    invalid_mandatory_flag = 0
AND invalid_date_flag = 0
AND invalid_usage_flag = 0
AND invalid_retention_flag = 0
AND invalid_domain_flag = 0
AND invalid_numeric_flag = 0;
