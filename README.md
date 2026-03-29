# SaaS Customer Success Analytics Platform

<div align="center">

**A comprehensive analytics solution for SaaS companies to track customer health, retention, and engagement metrics.**

[Tính năng](#tính-năng) • [Kiến trúc](#kiến-trúc) • [Sử dụng](#sử-dụng) • [Cấu trúc dữ liệu](#cấu-trúc-dữ-liệu)

</div>

## 📋 Giới thiệu

Dự án này cung cấp một nền tảng phân tích hoàn chỉnh giúp các công ty SaaS:
- 📊 Theo dõi các chỉ số chính (KPIs) như MRR, churn rate, retention
- 👥 Quản lý sức khỏe khách hàng và rủi ro mất khách
- 📈 Phân tích mức độ sử dụng tính năng và tương tác
- 💼 Hỗ trợ quyết định chiến lược CS (Customer Success)

---

## 🎯 Tính năng

| Tính năng | Mô tả |
|-----------|-------|
| **Churn Rate Analysis** | Tính toán tỷ lệ mất khách theo tháng |
| **MRR Tracking** | Theo dõi doanh thu định kỳ hàng tháng theo loại gói |
| **Engagement Metrics** | Phân tích mức độ sử dụng tính năng và user hoạt động |
| **Retention Analysis** | Đánh giá tỷ lệ giữ chân khách 6 tháng/12 tháng |
| **Churn Risk Scoring** | Xác định khách hàng có rủi ro cao |
| **Customer Activity Tracking** | Ghi lại hoạt động CS và thời gian liên hệ gần nhất |

---

## 🏗️ Kiến trúc

```
Dữ liệu thô
    ↓
[01_raw] - Tạo và nạp dữ liệu thô
    ↓
[02_staging] - Làm sạch và chuẩn hóa
    ↓
[03_validation] - Kiểm tra chất lượng dữ liệu
    ↓
[04_core] - Xây dựng DimDate và bảng lõi
    ↓
[05_analytic] - Truy vấn phân tích và BI
    ↓
Dashboard & Insights
```

### 📂 Cấu trúc thư mục

```
saas_cs_analytics/
├── sql/
│   ├── 01_raw/              # Bảng dữ liệu thô từ nguồn
│   ├── 02_staging/          # Dữ liệu được làm sạch và chuẩn hóa
│   ├── 03_validation/       # Kiểm tra chất lượng dữ liệu
│   ├── 04_core/             # Bảng lõi và stored procedures
│   │   ├── 01_create_core.sql
│   │   ├── 02_create_DimDate.sql
│   │   ├── 03_sp_load_core_all.sql
│   │   └── sp_load_*.sql    # Stored procedures chuyên biệt
│   └── 05_analytic/         # Truy vấn phân tích chính
├── data/                    # CSV dữ liệu mẫu
├── dashboard/               # Cấu hình theme cho BI tools
└── README.md               # Tài liệu này
```

---

## 🚀 Sử dụng

### Yêu cầu
- **SQL Server** 2016 hoặc cao hơn
- **Quyền truy cập**: Admin/Developer trên database
- **BI Tool** (Power BI, Tableau) - Tùy chọn

### Bước 1: Thiết lập cơ sở dữ liệu

```sql
-- Chạy các script này theo thứ tự:

-- 1. Tạo bảng thô
sql/01_raw/01_create_raw.sql
sql/01_raw/02_load_raw.sql

-- 2. Tạo tầng staging
sql/02_staging/01_create_staging.sql
sql/02_staging/02_load_staging.sql

-- 3. Validation
sql/03_validation/01_create_validation_table.sql
sql/03_validation/02_load_validation.sql

-- 4. Tạo tầng core (trung tâm dữ liệu)
sql/04_core/01_create_core.sql
sql/04_core/02_create_DimDate.sql
sql/04_core/03_sp_load_core_all.sql
```

### Bước 2: Chạy Stored Procedures

```sql
-- Nạp dữ liệu toàn bộ
EXEC sp_load_core_all;

-- Hoặc nạp từng phần
EXEC sp_load_customer;
EXEC sp_load_subscription;
EXEC sp_load_engagement;
EXEC sp_load_cs_activity;
EXEC sp_load_retention_risk;
```

### Bước 3: Chạy truy vấn phân tích

```sql
-- Tất cả truy vấn phân tích nằm trong:
sql/05_analytic/01_analytics.sql

-- Các truy vấn chính:
-- 1. Active Customers & MRR by plan_type
-- 2. Churn Rate by month
-- 3. Engagement & Feature Usage
-- ... và nhiều hơn nữa
```

---

## 📊 Cấu trúc dữ liệu

### Bảng chính

#### `subscription`
Thông tin gói dịch vụ của khách hàng
```
customer_id, customer_name, plan_type, monthly_fee, 
subscription_status, subscription_start_date, subscription_end_date
```

#### `engagement`
Mức độ tương tác và sử dụng của khách
```
customer_id, feature_usage_score, monthly_active_users,
last_login_date
```

#### `retention_risk`
Đánh giá rủi ro mất khách
```
customer_id, churn_risk_score, retention_rate_6m, retention_rate_12m
```

#### `cs_activity`
Hoạt động hỗ trợ khách hàng
```
customer_id, last_success_touch_date, account_manager
```

---

## 📈 Các chỉ số chính (KPIs)

| KPI | Công thức | Ý nghĩa |
|-----|-----------|---------|
| **MRR** | Sum(monthly_fee) | Doanh thu định kỳ hàng tháng |
| **Churn Rate** | (Cancelled / Total) × 100% | % khách hủy dịch vụ |
| **MAU** | Count(active_users) | Người dùng hoạt động hàng tháng |
| **Feature Score** | Avg(feature_usage_score) | Mức độ sử dụng tính năng trung bình |
| **Retention Rate** | (Remaining / Starting) × 100% | % khách giữ lại |

---

## 🔄 Quy trình ELT

### Extract (Trích xuất)
- Dữ liệu từ các hệ thống khác nhau
- Lưu trữ ở bảng `01_raw`

### Load (Nạp)
- Làm sạch và chuẩn hóa dữ liệu
- Chuyển vào bảng `02_staging` → `03_validation` → `04_core`

### Transform (Biến đổi)
- Tính toán KPIs trong tầng `05_analytic`
- Sử dụng Stored Procedures để tự động hóa

---

## 🛠️ Stored Procedures

| Procedure | Mục đích |
|-----------|---------|
| `sp_load_core_all` | Nạp tất cả tầng core |
| `sp_load_customer` | Cập nhật thông tin khách hàng |
| `sp_load_subscription` | Cập nhật dữ liệu gói |
| `sp_load_engagement` | Tính toán chỉ số tương tác |
| `sp_load_cs_activity` | Ghi lại hoạt động CS |
| `sp_load_retention_risk` | Đánh giá rủi ro mất khách |

---

## 📱 Dashboard

Cấu hình theme Power BI/Tableau:
- **File**: `dashboard/SaaS_Theme.json`
