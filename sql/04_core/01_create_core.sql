-- =============================================
-- Description:	Create core tables in the dbo schema for customer success analytics
-- =============================================

--  DDL for Table Customer
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'Customer' AND schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
CREATE TABLE dbo.Customer (
    customer_id NVARCHAR(50) NOT NULL,
    customer_name NVARCHAR(255),
    industry NVARCHAR(100),
    account_manager NVARCHAR(100),
    user_count INT,

	 CONSTRAINT PK_Customer PRIMARY KEY (customer_id)
);

--  DDL for Table Subscription
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'Subscription' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.Subscription;
CREATE TABLE dbo.Subscription (
    customer_id NVARCHAR(50) NOT NULL,             
    plan_type NVARCHAR(50),
    monthly_fee DECIMAL(12,2),
    subscription_start_date DATE,
    subscription_end_date DATE,
    subscription_status NVARCHAR(50),

	CONSTRAINT PK_Subscription PRIMARY KEY (customer_id),
    CONSTRAINT FK_Subscription_Customer FOREIGN KEY (customer_id) REFERENCES dbo.Customer(customer_id)
);

--  DDL for Table Engagement
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'Engagement' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.Engagement;
CREATE TABLE dbo.Engagement (
    customer_id NVARCHAR(50) NOT NULL,
    last_login_date DATE,
    monthly_active_users INT,
    feature_usage_score DECIMAL(5,2),

	CONSTRAINT PK_Engagement PRIMARY KEY (customer_id),
    CONSTRAINT FK_Engagement_Customer FOREIGN KEY (customer_id) REFERENCES dbo.Customer(customer_id)
);

--  DDL for Table RetentionRisk
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'RetentionRisk' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.RetentionRisk;
CREATE TABLE dbo.RetentionRisk (
    customer_id NVARCHAR(50) NOT NULL,
    retention_rate_6m DECIMAL(5,2),
    retention_rate_12m DECIMAL(5,2),
    churn_risk_score DECIMAL(4,2),

	CONSTRAINT PK_RetentionRisk PRIMARY KEY (customer_id),
    CONSTRAINT FK_RetentionRisk_Customer FOREIGN KEY (customer_id) REFERENCES dbo.Customer(customer_id)

);

--  DDL for Table CsActivity
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'CsActivity' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.CsActivity;
CREATE TABLE dbo.CsActivity (
    customer_id NVARCHAR(50) NOT NULL,
    last_success_touch_date DATE,
    notes NVARCHAR(MAX),

	CONSTRAINT PK_CsActivity PRIMARY KEY (customer_id),
    CONSTRAINT FK_CsActivity_Customer FOREIGN KEY (customer_id) REFERENCES dbo.Customer(customer_id)
);

