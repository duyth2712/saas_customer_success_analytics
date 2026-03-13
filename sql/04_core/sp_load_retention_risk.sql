IF OBJECT_ID('dbo.sp_load_retention_risk', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_retention_risk;
GO

CREATE PROCEDURE dbo.sp_load_retention_risk
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing risk
        UPDATE t
        SET
            retention_rate_6m  = s.retention_rate_6m,
            retention_rate_12m = s.retention_rate_12m,
            churn_risk_score   = s.churn_risk_score
        FROM dbo.retention_risk t
        JOIN val.customer_success_valid s
            ON t.customer_id = s.customer_id;

        -- Insert new risk
        INSERT INTO dbo.retention_risk (customer_id, retention_rate_6m, retention_rate_12m, churn_risk_score)
        SELECT s.customer_id, s.retention_rate_6m, s.retention_rate_12m, s.churn_risk_score
        FROM val.customer_success_valid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.retention_risk t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO