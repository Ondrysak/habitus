-- First version migration script for PostgreSQL

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS daily_logs CASCADE;
DROP TABLE IF EXISTS goals CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Create the 'users' table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    auth_provider VARCHAR(100),
    auth_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now()
);

-- Create the 'goals' table
-- Represents a habit or goal the user is tracking (e.g., reducing smoking)
CREATE TABLE goals (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    habit_type VARCHAR(100) NOT NULL,      -- e.g. "smoking"
    baseline_usage INT NOT NULL,           -- e.g. cigarettes per day
    baseline_cost DECIMAL(10,2) NOT NULL,  -- cost per pack
    notification_time TIME NULL,           -- time of day for notification
    notification_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    start_date DATE NOT NULL,              -- when tracking started
    achieved BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create the 'daily_logs' table
-- Records the user's daily usage (e.g., number of cigarettes smoked per day)
CREATE TABLE daily_logs (
    id SERIAL PRIMARY KEY,
    goal_id INT NOT NULL,
    log_date DATE NOT NULL,
    units_consumed INT NOT NULL,    -- number of units consumed that day (e.g., cigarettes smoked)
    notes TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now(),
    FOREIGN KEY (goal_id) REFERENCES goals(id) ON DELETE CASCADE
);


