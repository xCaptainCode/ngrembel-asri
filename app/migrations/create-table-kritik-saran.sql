-- Active: 1779269040582@@localhost@5432@ngrembel_asri@public
CREATE TABLE kritik_saran (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    type VARCHAR(10) CHECK (type IN ('kritik', 'saran')),
    nama VARCHAR(255),
    kritik_saran TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    response TEXT,
    responded_at TIMESTAMP DEFAULT NOW(),
    is_published BOOLEAN DEFAULT TRUE,
    responded_by UUID
);

SELECT * FROM kritik_saran;