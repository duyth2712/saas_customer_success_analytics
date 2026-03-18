IF OBJECT_ID('dbo.sp_load_customer', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_customer;
GO

CREATE PROCEDURE dbo.sp_load_customer
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        --Update existing Customers
        UPDATE c
        SET 
            customer_name   = s.customer_name,
            industry        = s.industry,
            account_manager = s.account_manager,
            user_count      = s.user_count
        FROM dbo.Customer c
        JOIN val.CustomerSuccessValid s
            ON c.customer_id = s.customer_id;

		-- Insert new Customers
        INSERT INTO dbo.Customer (customer_id, customer_name, industry, account_manager, user_count)
        SELECT s.customer_id, s.customer_name, s.industry, s.account_manager, s.user_count
        FROM val.CustomerSuccessValid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Customer c WHERE c.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
EXEC dbo.sp_load_customer;