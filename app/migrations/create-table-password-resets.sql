CREATE TABLE password_resets (
    id          SERIAL PRIMARY KEY,
    email       VARCHAR(255)  NOT NULL,
    token       VARCHAR(255)  NOT NULL UNIQUE,
    expired_at  TIMESTAMP     NOT NULL,
    is_used     BOOLEAN       NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP     NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_password_resets_token ON password_resets(token);
CREATE INDEX idx_password_resets_email ON password_resets(email);

SELECT * FROM password_resets;
SELECT * FROM members;