-- ===============================================
-- Orchestrator: Load tất cả core tables (UPSERT)
-- Gọi tuần tự 5 SP từng bảng
-- ===============================================
IF OBJECT_ID('dbo.sp_load_core_all', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_core_all;
GO

CREATE PROCEDURE dbo.sp_load_core_all
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Load customer
        EXEC dbo.sp_load_customer;

        -- Load subscription
        EXEC dbo.sp_load_subscription;

        -- Load engagement
        EXEC dbo.sp_load_engagement;

        -- Load retention_risk
        EXEC dbo.sp_load_retention_risk;

        -- Load cs_activity
        EXEC dbo.sp_load_cs_activity;

    END TRY
    BEGIN CATCH
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO