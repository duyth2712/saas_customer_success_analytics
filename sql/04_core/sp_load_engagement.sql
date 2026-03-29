-- =============================================
-- Description:	Load data into the Engagement table
-- =============================================

-- DDL for Stored Procedure sp_load_Engagement
IF OBJECT_ID('dbo.sp_load_engagement', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_engagement;
GO

CREATE PROCEDURE dbo.sp_load_engagement
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing Engagement
        UPDATE t
        SET
            last_login_date      = s.last_login_date,     
            monthly_active_users = s.monthly_active_users,
            feature_usage_score  = s.feature_usage_score
        FROM dbo.Engagement t
        JOIN val.CustomerSuccessValid s
            ON t.customer_id = s.customer_id;

        -- Insert new Engagement
        INSERT INTO dbo.Engagement (customer_id, last_login_date, monthly_active_users, feature_usage_score)
        SELECT s.customer_id, s.last_login_date, s.monthly_active_users, s.feature_usage_score
        FROM val.CustomerSuccessValid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Engagement t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO