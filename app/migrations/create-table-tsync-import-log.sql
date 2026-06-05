CREATE TABLE IF NOT EXISTS tsync_import_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (),
    import_type VARCHAR(50) NOT NULL,
    file_name VARCHAR(255) NOT NULL,
    total_rows INTEGER NOT NULL DEFAULT 0,
    inserted_rows INTEGER NOT NULL DEFAULT 0,
    skipped_duplicate INTEGER NOT NULL DEFAULT 0,
    skipped_error INTEGER NOT NULL DEFAULT 0,
    error_summary TEXT,
    imported_by VARCHAR(255),
    created_at TIMESTAMP DEFAULT NOW()
);

COMMENT ON TABLE tsync_import_log IS 'Audit trail untuk impor data sinkronisasi (CSV point member, dll.)';
