IF OBJECT_ID('stag.v_customer_success_validate', 'V') IS NOT NULL
    DROP VIEW stag.v_customer_success_validate;
GO
CREATE VIEW stag.v_customer_success_validate
AS
SELECT
    cs.customer_id,
    cs.customer_name,
    cs.industry,
    cs.account_manager,

    cs.subscription_start_date,
    cs.subscription_end_date,
    cs.subscription_status,
    cs.plan_type,
    cs.monthly_fee,
    cs.user_count,

    cs.last_login_date,
    cs.monthly_active_users,
    cs.feature_usage_score,

    cs.retention_rate_6m,
    cs.retention_rate_12m,
    cs.churn_risk_score,

    cs.last_success_touch_date,
    cs.notes,
    cs.load_date,

    /* =========================
       1. Mandatory field check
       ========================= */
    CAST(
        CASE
            WHEN cs.customer_id IS NULL
              OR cs.customer_name IS NULL
              OR cs.plan_type IS NULL
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_mandatory_flag,

    /* =========================
       2. Date logic validation
       ========================= */
    CAST(
        CASE
            WHEN cs.subscription_start_date IS NULL
              OR (cs.subscription_end_date IS NOT NULL
                  AND cs.subscription_end_date < cs.subscription_start_date)
              OR (cs.last_login_date > CAST(GETDATE() AS DATE))
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_date_flag,

    /* =========================
       3. Usage & engagement logic
       ========================= */
    CAST(
        CASE
            WHEN cs.monthly_active_users > cs.user_count
              OR cs.feature_usage_score < 0
              OR cs.feature_usage_score > 1000
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_usage_flag,

    /* =========================
       4. Retention & churn logic
       ========================= */
    CAST(
        CASE
            WHEN cs.retention_rate_6m < 0
              OR cs.retention_rate_6m > 100
              OR cs.retention_rate_12m < 0
              OR cs.retention_rate_12m > 100
              OR cs.retention_rate_12m > cs.retention_rate_6m
              OR cs.churn_risk_score NOT BETWEEN 1 AND 10
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_retention_flag,

    /* =========================
       5. Domain / enum check
       ========================= */
    CAST(
        CASE
            WHEN cs.subscription_status NOT IN ('active', 'trial', 'expired', 'cancelled', 'paused')
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_domain_flag,

    /* =========================
       6. Numeric sanity check
       ========================= */
    CAST(
        CASE
            WHEN cs.monthly_fee < 0
              OR cs.user_count < 0
            THEN 1 ELSE 0
        END
    AS BIT) AS invalid_numeric_flag

FROM stag.customer_success cs;

SELECT *
FROM stag.v_customer_success_validate
WHERE invalid_domain_flag = 1;

SELECT
    COUNT(*) AS total_rows,
    SUM(CAST(invalid_mandatory_flag AS INT)) AS invalid_mandatory_cnt,
    SUM(CAST(invalid_date_flag AS INT))      AS invalid_date_cnt,
    SUM(CAST(invalid_usage_flag AS INT))     AS invalid_usage_cnt,
    SUM(CAST(invalid_retention_flag AS INT)) AS invalid_retention_cnt,
    SUM(CAST(invalid_domain_flag AS INT))    AS invalid_domain_cnt,
    SUM(CAST(invalid_numeric_flag AS INT))   AS invalid_numeric_cnt
FROM stag.v_customer_success_validate;