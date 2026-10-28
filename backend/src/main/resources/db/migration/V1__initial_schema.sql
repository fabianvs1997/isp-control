CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE customers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(180) NOT NULL,
    phone VARCHAR(30),
    email VARCHAR(254),
    notes TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE service_plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    monthly_price NUMERIC(12,2) NOT NULL CHECK (monthly_price >= 0),
    download_mbps INTEGER CHECK (download_mbps > 0),
    upload_mbps INTEGER CHECK (upload_mbps > 0),
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE installations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    address TEXT NOT NULL,
    access_technology VARCHAR(16) NOT NULL CHECK (access_technology IN ('FIBER','WIRELESS')),
    status VARCHAR(16) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','INSTALLED','REMOVED')),
    location geometry(Point,4326),
    location_precision VARCHAR(16) CHECK (location_precision IN ('GPS','MANUAL','APPROXIMATE')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX installations_location_gix ON installations USING GIST(location);
CREATE INDEX installations_customer_idx ON installations(customer_id);

CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    installation_id UUID NOT NULL REFERENCES installations(id),
    plan_id UUID NOT NULL REFERENCES service_plans(id),
    agreed_monthly_price NUMERIC(12,2) NOT NULL CHECK (agreed_monthly_price >= 0),
    billing_day SMALLINT NOT NULL CHECK (billing_day BETWEEN 1 AND 28),
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(16) NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE','SUSPENDED','CANCELLED')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE charges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID NOT NULL REFERENCES subscriptions(id),
    period_start DATE NOT NULL,
    due_date DATE NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (subscription_id, period_start)
);

CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL REFERENCES customers(id),
    paid_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    method VARCHAR(30) NOT NULL,
    reference VARCHAR(120),
    voided_at TIMESTAMPTZ
);

CREATE TABLE payment_allocations (
    payment_id UUID NOT NULL REFERENCES payments(id),
    charge_id UUID NOT NULL REFERENCES charges(id),
    amount NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    PRIMARY KEY (payment_id, charge_id)
);

-- Pendiente: usuarios, auditoría y áreas de servicio.
-- Reglas de sumas de pagos se implementarán de manera transaccional en HU-010.
