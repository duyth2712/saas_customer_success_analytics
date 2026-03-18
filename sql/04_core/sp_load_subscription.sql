IF OBJECT_ID('dbo.sp_load_subscription', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_subscription;
GO

CREATE PROCEDURE dbo.sp_load_subscription
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing Subscriptions
        UPDATE t
        SET
            plan_type               = s.plan_type,
            monthly_fee             = s.monthly_fee,
            subscription_start_date = s.subscription_start_date,
            subscription_end_date   = s.subscription_end_date,
            subscription_status     = s.subscription_status
        FROM dbo.Subscription t
        JOIN val.CustomerSuccessValid s
            ON t.customer_id = s.customer_id;

        -- Insert new Subscriptions
        INSERT INTO dbo.Subscription (customer_id, plan_type, monthly_fee, subscription_start_date, subscription_end_date, subscription_status)
        SELECT s.customer_id, s.plan_type, s.monthly_fee, s.subscription_start_date, s.subscription_end_date, s.subscription_status
        FROM val.CustomerSuccessValid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.Subscription t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO
