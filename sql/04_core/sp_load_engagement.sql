IF OBJECT_ID('dbo.sp_load_engagement', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_engagement;
GO

CREATE PROCEDURE dbo.sp_load_engagement
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.engagement;

    INSERT INTO dbo.engagement
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
END;
GO
