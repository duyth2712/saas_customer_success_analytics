--  DDL for Table customer
IF NOT EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'customer' AND schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
CREATE TABLE dbo.customer (
    customer_id NVARCHAR(50) NOT NULL,
    customer_name NVARCHAR(255),
    industry NVARCHAR(100),
    account_manager NVARCHAR(100),
    user_count INT,

	 CONSTRAINT PK_customer PRIMARY KEY (customer_id)
);

--  DDL for Table subscription
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'subscription' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.subscription;
CREATE TABLE dbo.subscription (
    customer_id NVARCHAR(50) NOT NULL,             
    plan_type NVARCHAR(50),
    monthly_fee DECIMAL(12,2),
    subscription_start_date DATE,
    subscription_end_date DATE,
    subscription_status NVARCHAR(50),

	CONSTRAINT PK_subscription PRIMARY KEY (customer_id),
    CONSTRAINT FK_subscription_customer FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id)
);

--  DDL for Table engagement
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'engagement' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.engagement;
CREATE TABLE dbo.engagement (
    customer_id NVARCHAR(50) NOT NULL,
    last_login_date DATE,
    monthly_active_users INT,
    feature_usage_score DECIMAL(5,2),

	CONSTRAINT PK_engagement PRIMARY KEY (customer_id),
    CONSTRAINT FK_engagement_customer FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id)
);

--  DDL for Table retention_risk
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'retention_risk' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.retention_risk;
CREATE TABLE dbo.retention_risk (
    customer_id NVARCHAR(50) NOT NULL,
    retention_rate_6m DECIMAL(5,2),
    retention_rate_12m DECIMAL(5,2),
    churn_risk_score DECIMAL(4,2),

	CONSTRAINT PK_retention_risk PRIMARY KEY (customer_id),
    CONSTRAINT FK_retention_risk_customer FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id)

);

--  DDL for Table cs_activity
IF EXISTS ( SELECT 1 FROM sys.tables WHERE name = 'cs_activity' and schema_id = (SELECT schema_id FROM sys.schemas WHERE name='dbo'))
	DROP TABLE dbo.cs_activity;
CREATE TABLE dbo.cs_activity (
    customer_id NVARCHAR(50) NOT NULL,
    last_success_touch_date DATE,
    notes NVARCHAR(MAX),

	CONSTRAINT PK_cs_activity PRIMARY KEY (customer_id),
    CONSTRAINT FK_cs_activity_customer FOREIGN KEY (customer_id) REFERENCES dbo.customer(customer_id)
);

