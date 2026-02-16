IF OBJECT_ID('dbo.sp_load_customer', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_customer;
GO

CREATE PROCEDURE dbo.sp_load_customer
AS
BEGIN
    SET NOCOUNT ON;

    TRUNCATE TABLE dbo.customer;

    INSERT INTO dbo.customer
    (
        customer_id,
        customer_name,
        industry,
        account_manager,
        user_count,
        snapshot_date,
        load_date
    )
    SELECT DISTINCT
        customer_id,
        customer_name,
        industry,
        account_manager,
        user_count,
        CAST(load_date AS DATE) AS snapshot_date,
        GETDATE()               AS load_date
    FROM stag.v_customer_success_validate
    WHERE invalid_mandatory_flag = 0
      AND invalid_date_flag = 0
      AND invalid_usage_flag = 0
      AND invalid_retention_flag = 0
      AND invalid_domain_flag = 0
      AND invalid_numeric_flag = 0;
END;
GO
