-- FactoryPulse TimescaleDB Schema
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Equipment catalog
CREATE TABLE equipment (
    machine_id VARCHAR(50) PRIMARY KEY,
    type VARCHAR(50),
    location VARCHAR(100),
    install_date DATE
);

-- Sensor readings (will become hypertable)
CREATE TABLE sensor_readings (
    time TIMESTAMPTZ NOT NULL,
    machine_id VARCHAR(50) NOT NULL,
    temperature DOUBLE PRECISION,
    vibration DOUBLE PRECISION,
    pressure DOUBLE PRECISION,
    rpm DOUBLE PRECISION
);
SELECT create_hypertable('sensor_readings', 'time');

-- Features (windowed)
CREATE TABLE features (
    time TIMESTAMPTZ NOT NULL,
    machine_id VARCHAR(50) NOT NULL,
    temp_roll_mean DOUBLE PRECISION,
    vib_roll_std DOUBLE PRECISION,
    rul_label DOUBLE PRECISION
);
SELECT create_hypertable('features', 'time');

-- Predictions
CREATE TABLE predictions (
    time TIMESTAMPTZ NOT NULL,
    machine_id VARCHAR(50) NOT NULL,
    model_name VARCHAR(50),
    stage VARCHAR(20),
    anomaly_score DOUBLE PRECISION,
    rul_days DOUBLE PRECISION
);
SELECT create_hypertable('predictions', 'time');

-- Alerts
CREATE TABLE alerts (
    time TIMESTAMPTZ NOT NULL,
    machine_id VARCHAR(50) NOT NULL,
    severity VARCHAR(20),
    failure_mode VARCHAR(50),
    message TEXT,
    status VARCHAR(20) DEFAULT 'open'
);
SELECT create_hypertable('alerts', 'time');

-- Continuous aggregates for performance
CREATE MATERIALIZED VIEW sensor_1m
WITH (timescaledb.continuous) AS
SELECT time_bucket('1 minute', time) as bucket, machine_id, AVG(temperature) as avg_temp
FROM sensor_readings GROUP BY bucket, machine_id;