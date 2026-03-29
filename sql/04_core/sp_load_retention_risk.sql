-- =============================================
-- Description:	Load data into the RetentionRisk table
-- =============================================

-- DDL for Stored Procedure sp_load_RetentionRisk
IF OBJECT_ID('dbo.sp_load_retention_risk', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_retention_risk;
GO

CREATE PROCEDURE dbo.sp_load_retention_risk
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing Retention Risk
        UPDATE t
        SET
            retention_rate_6m  = s.retention_rate_6m,
            retention_rate_12m = s.retention_rate_12m,
            churn_risk_score   = s.churn_risk_score
        FROM dbo.RetentionRisk t
        JOIN val.CustomerSuccessValid s
            ON t.customer_id = s.customer_id;

        -- Insert new Retention Risk
        INSERT INTO dbo.RetentionRisk (customer_id, retention_rate_6m, retention_rate_12m, churn_risk_score)
        SELECT s.customer_id, s.retention_rate_6m, s.retention_rate_12m, s.churn_risk_score
        FROM val.CustomerSuccessValid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.RetentionRisk t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
