-- =============================================
-- Description:	Create the validation schema and validation data storage tables
-- =============================================

-- Create val schema
IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = 'val')
BEGIN
    EXEC('CREATE SCHEMA val');
END;
GO
-- DDL for val.CustomerSuccessValid table
IF OBJECT_ID('val.CustomerSuccessValid', 'U') IS NOT NULL
    DROP TABLE val.CustomerSuccessValid;
GO
CREATE TABLE val.CustomerSuccessValid
(
    batch_id             BIGINT        NOT NULL,
    load_dttm           DATETIME2(0)   NOT NULL,

    customer_id             VARCHAR(50)    NOT NULL,
    customer_name           VARCHAR(255)   NULL,
    industry                VARCHAR(100)   NULL,
    account_manager         VARCHAR(100)   NULL,

    subscription_start_date DATE           NULL,
    subscription_end_date   DATE           NULL,
    subscription_status     VARCHAR(20)    NULL,
    plan_type               VARCHAR(20)    NULL,

    monthly_fee             DECIMAL(12,2)  NULL,
    user_count              INT            NULL,
    last_login_date         DATE           NULL,
    monthly_active_users    INT            NULL,

    feature_usage_score     DECIMAL(5,2)   NULL,
    retention_rate_6m       DECIMAL(5,2)   NULL,
    retention_rate_12m      DECIMAL(5,2)   NULL,
    churn_risk_score        DECIMAL(4,2)   NULL,

    last_success_touch_date DATE           NULL,
    notes                   NVARCHAR(MAX)  NULL

	CONSTRAINT PK_val_customer_success_valid
        PRIMARY KEY (batch_id, customer_id)
);
GO
-- DDL for val.CustomerSuccessReject table
IF OBJECT_ID('val.CustomerSuccessReject', 'U') IS NOT NULL
    DROP TABLE val.CustomerSuccessReject;
GO
CREATE TABLE val.CustomerSuccessReject
(
    batch_id            BIGINT        NOT NULL,
    load_dttm          DATETIME2(0)   NOT NULL,

    customer_id             VARCHAR(50)    NOT NULL,
    customer_name           VARCHAR(255)   NULL,
    industry                VARCHAR(100)   NULL,
    account_manager         VARCHAR(100)   NULL,

    subscription_start_date DATE           NULL,
    subscription_end_date   DATE           NULL,
    subscription_status     VARCHAR(20)    NULL,
    plan_type               VARCHAR(20)    NULL,

    monthly_fee             DECIMAL(12,2)  NULL,
    user_count              INT            NULL,
    last_login_date         DATE           NULL,
    monthly_active_users    INT            NULL,

    feature_usage_score     DECIMAL(5,2)   NULL,
    retention_rate_6m       DECIMAL(5,2)   NULL,
    retention_rate_12m      DECIMAL(5,2)   NULL,
    churn_risk_score        DECIMAL(4,2)   NULL,

    last_success_touch_date DATE           NULL,
    notes                   NVARCHAR(MAX)  NULL,

    dq_is_valid             BIT            NOT NULL,
    dq_issue                NVARCHAR(1000) NOT NULL

	CONSTRAINT PK_val_customer_success_reject
        PRIMARY KEY (batch_id, customer_id, load_dttm)

);
GO

-- Create indexes on validation tables for faster querying
CREATE INDEX IX_val_customer_success_valid_customer_id
ON val.CustomerSuccessValid(customer_id);
GO

CREATE INDEX IX_val_customer_success_reject_customer_id
ON val.CustomerSuccessReject(customer_id);
GO

CREATE INDEX IX_val_customer_success_valid_load
ON val.CustomerSuccessValid(batch_id, load_dttm);
GO

CREATE INDEX IX_val_customer_success_reject_load
ON val.CustomerSuccessReject(batch_id, load_dttm);
GO