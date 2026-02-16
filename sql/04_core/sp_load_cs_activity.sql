IF OBJECT_ID('dbo.sp_load_cs_activity', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_cs_activity;
GO

CREATE PROCEDURE dbo.sp_load_cs_activity
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.cs_activity;

    INSERT INTO dbo.cs_activity
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
END;
GO
