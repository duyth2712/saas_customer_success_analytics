IF OBJECT_ID('dbo.sp_load_dbo_all', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_dbo_all;
GO

CREATE PROCEDURE dbo.sp_load_dbo_all
AS
BEGIN
    EXEC dbo.sp_load_customer;
    EXEC dbo.sp_load_subscription;
    EXEC dbo.sp_load_engagement;
    EXEC dbo.sp_load_retention_risk;
    EXEC dbo.sp_load_cs_activity;
END;