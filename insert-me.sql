CREATE TABLE IF NOT EXISTS k3_steamRewards (
    identifier VARCHAR(255) PRIMARY KEY NOT NULL,
    last_claimed VARCHAR(10) NOT NULL,
    CHECK (last_claimed LIKE '__.__.____') -- DD.MM.YYYY
);
