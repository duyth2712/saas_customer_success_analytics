
IF OBJECT_ID('dbo.sp_load_retention_risk', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_retention_risk;
GO

CREATE PROCEDURE dbo.sp_load_retention_risk
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.retention_risk;

	INSERT INTO dbo.retention_risk
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
END;
GO
