IF OBJECT_ID('dbo.sp_load_cs_activity', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_cs_activity;
GO

CREATE PROCEDURE dbo.sp_load_cs_activity
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing CS activity
        UPDATE t
        SET
            last_success_touch_date = s.last_success_touch_date, 
            notes                   = s.notes
        FROM dbo.cs_activity t
        JOIN val.customer_success_valid s
            ON t.customer_id = s.customer_id;

        -- Insert new CS activity
        INSERT INTO dbo.cs_activity (customer_id, last_success_touch_date, notes)
        SELECT s.customer_id, s.last_success_touch_date, s.notes
        FROM val.customer_success_valid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.cs_activity t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO