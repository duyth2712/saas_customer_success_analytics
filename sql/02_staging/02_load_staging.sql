DECLARE @batch_id BIGINT =
(
    SELECT MAX(batch_id) FROM raw.load_run
);

DELETE FROM stag.customer_success
WHERE batch_id = @batch_id

--TRUNCATE TABLE stag.customer_success;
--GO

INSERT INTO stag.customer_success
(	
	batch_id,
    load_dttm,
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
	notes
)
SELECT
	r.batch_id,
    lr.load_dttm,

    r.customer_id,
    r.customer_name,
    r.industry,
    r.account_manager,

    TRY_CAST(r.subscription_start_date AS DATE),
    TRY_CAST(r.subscription_end_date   AS DATE),

    r.subscription_status,
    r.plan_type,

    TRY_CAST(NULLIF(r.monthly_fee,'') AS DECIMAL(12,2)),
    TRY_CAST(NULLIF(r.user_count,'') AS INT),

    TRY_CAST(r.last_login_date AS DATE),
    TRY_CAST(NULLIF(r.monthly_active_users,'') AS INT),

    TRY_CAST(NULLIF(r.feature_usage_score,'') AS DECIMAL(5,2)),
    TRY_CAST(NULLIF(r.retention_rate_6m,'')   AS DECIMAL(5,2)),
    TRY_CAST(NULLIF(r.retention_rate_12m,'')  AS DECIMAL(5,2)),
    TRY_CAST(NULLIF(r.churn_risk_score,'')    AS DECIMAL(4,2)),

    TRY_CAST(r.last_success_touch_date AS DATE),
    r.notes

FROM raw.customer_success r
JOIN raw.load_run lr
  ON lr.batch_id = r.batch_id
WHERE r.batch_id = @batch_id;
GO
