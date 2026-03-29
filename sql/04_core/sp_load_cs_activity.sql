-- =============================================
-- Description:	Load data into the CsActivity table
-- =============================================

-- DDL for Stored Procedure sp_load_CsActivity
IF OBJECT_ID('dbo.sp_load_CsActivity', 'P') IS NOT NULL
    DROP PROCEDURE dbo.sp_load_CsActivity;
GO

CREATE PROCEDURE dbo.sp_load_CsActivity
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Update existing CS Activity
        UPDATE t
        SET
            last_success_touch_date = s.last_success_touch_date, 
            notes                   = s.notes
        FROM dbo.CsActivity t
        JOIN val.customer_success_valid s
            ON t.customer_id = s.customer_id;

        -- Insert new CS Activity
        INSERT INTO dbo.CsActivity (customer_id, last_success_touch_date, notes)
        SELECT s.customer_id, s.last_success_touch_date, s.notes
        FROM val.customer_success_valid s
        WHERE NOT EXISTS (SELECT 1 FROM dbo.CsActivity t WHERE t.customer_id = s.customer_id);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO