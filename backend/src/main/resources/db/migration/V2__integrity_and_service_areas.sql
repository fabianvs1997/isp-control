-- HU-002: preserve installation/customer consistency and prepare geographic segmentation.
-- V1 is intentionally immutable after publication.
ALTER TABLE installations
    ADD CONSTRAINT installations_customer_id_id_unique UNIQUE (customer_id, id);

ALTER TABLE subscriptions
    ADD CONSTRAINT subscriptions_installation_same_customer_fk
    FOREIGN KEY (customer_id, installation_id)
    REFERENCES installations (customer_id, id);

ALTER TABLE installations
    ADD CONSTRAINT installations_location_precision_required
    CHECK (location IS NULL OR location_precision IS NOT NULL);

ALTER TABLE installations
    ADD CONSTRAINT installations_location_valid
    CHECK (location IS NULL OR (
        ST_X(location) BETWEEN -180 AND 180
        AND ST_Y(location) BETWEEN -90 AND 90
    ));

CREATE TABLE service_areas (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(120) NOT NULL UNIQUE,
    boundary geometry(MultiPolygon, 4326) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (ST_IsValid(boundary))
);
CREATE INDEX service_areas_boundary_gix ON service_areas USING GIST (boundary);
CREATE INDEX subscriptions_customer_idx ON subscriptions(customer_id);
CREATE INDEX subscriptions_installation_idx ON subscriptions(installation_id);
CREATE INDEX charges_due_date_idx ON charges(due_date);
CREATE INDEX payments_customer_paid_at_idx ON payments(customer_id, paid_at DESC);
CREATE INDEX payment_allocations_charge_idx ON payment_allocations(charge_id);
