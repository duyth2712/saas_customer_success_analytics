CREATE PROC dq.sp_log_customer_success_dq
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO dq.dq_issue
    (
        source_schema,
        source_table,
        source_view,
        customer_id,
        issue_type,
        issue_flag,
        issue_description,
        detected_date
    )
    SELECT
        'stag',
        'customer_success',
        'v_customer_success_validate',
        customer_id,
        issue_type,
        issue_flag,
        issue_description,
        CAST(load_date AS DATE)
    FROM
    (
        SELECT customer_id, load_date,
               'mandatory' AS issue_type,
               'invalid_mandatory_flag' AS issue_flag,
               'Missing mandatory field' AS issue_description
        FROM stag.v_customer_success_validate
        WHERE invalid_mandatory_flag = 1

        UNION ALL
        SELECT customer_id, load_date,
               'date',
               'invalid_date_flag',
               'Invalid date logic'
        FROM stag.v_customer_success_validate
        WHERE invalid_date_flag = 1

        UNION ALL
        SELECT customer_id, load_date,
               'usage',
               'invalid_usage_flag',
               'Invalid usage metrics'
        FROM stag.v_customer_success_validate
        WHERE invalid_usage_flag = 1

        UNION ALL
        SELECT customer_id, load_date,
               'retention',
               'invalid_retention_flag',
               'Invalid retention or churn value'
        FROM stag.v_customer_success_validate
        WHERE invalid_retention_flag = 1
    ) x;
END;

-- EXEC dq.sp_log_customer_success_dq;