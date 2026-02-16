INSERT INTO stag.customer_success
(
	customer_id,
	customer_name,
	industry,
	account_manager,
	subscription_start_date,
	subscription_end_date,
	subscription_status,
	plan_type,
	monthly_fee,
	user_count,
	last_login_date,
	monthly_active_users,
	feature_usage_score,
	retention_rate_6m,
	retention_rate_12m,
	churn_risk_score,
	last_success_touch_date,
	notes,
	load_date
)
SELECT
	customer_id,
	customer_name,
	industry,
	account_manager,
	
	TRY_CAST(subscription_start_date AS DATE),
	TRY_CAST(subscription_end_date AS DATE),
	subscription_status,
	plan_type,
	
	TRY_CAST(monthly_fee AS DECIMAL(12,2)),
	TRY_CAST(user_count AS INT),
	
	TRY_CAST(last_login_date AS DATE),
	TRY_CAST(monthly_active_users AS INT),
	TRY_CAST(feature_usage_score AS DECIMAL(5,2)),
	
	TRY_CAST(retention_rate_6m AS DECIMAL(5,2)),
	TRY_CAST(retention_rate_12m AS DECIMAL(5,2)),
	TRY_CAST(churn_risk_score AS DECIMAL(4,2)),
	
	TRY_CAST(last_success_touch_date AS DATE),
	notes,

	--- Load date
	CAST(GETDATE() AS DATE) AS load_date

FROM raw.customer_success;
