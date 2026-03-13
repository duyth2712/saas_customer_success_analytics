IF OBJECT_ID('dbo.sp_load_customer', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_customer;
GO

CREATE PROCEDURE dbo.sp_load_customer
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        --Update existing customers
        UPDATE c
        SET 
            customer_name   = s.customer_name,
            industry        = s.industry,
            account_manager = s.account_manager,
            user_count      = s.user_count
        FROM dbo.customer c
        JOIN val.customer_success_valid s
            ON c.customer_id = s.customer_id;

		-- Insert new customers
        INSERT INTO dbo.customer (customer_id, customer_name, industry, account_manager, user_count)
        SELECT s.customer_id, s.customer_name, s.industry, s.account_manager, s.user_count
        FROM val.customer_success_valid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.customer c WHERE c.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO