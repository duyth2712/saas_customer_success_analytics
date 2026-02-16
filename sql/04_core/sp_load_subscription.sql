IF OBJECT_ID('dbo.sp_load_subscription', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_subscription;
GO

CREATE PROCEDURE dbo.sp_load_subscription
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.subscription;

	INSERT INTO dbo.subscription
	(
		customer_id,
		plan_type,
		monthly_fee,
		subscription_start_date,
		subscription_end_date,
		subscription_status
	)
	SELECT
		customer_id,
		plan_type,
		monthly_fee,
		subscription_start_date,
		subscription_end_date,
		subscription_status
	FROM stag.v_customer_success_validate
	WHERE
		invalid_mandatory_flag = 0
	AND invalid_date_flag = 0
	AND invalid_usage_flag = 0
	AND invalid_retention_flag = 0
	AND invalid_domain_flag = 0
	AND invalid_numeric_flag = 0;
END;
GO
