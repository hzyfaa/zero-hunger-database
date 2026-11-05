CREATE DATABASE food_security;
USE food_security;

-- 1. Country
CREATE TABLE country (
country_id INT PRIMARY KEY, 
name VARCHAR(200) NOT NULL UNIQUE,
iso3_code CHAR(3) NOT NULL UNIQUE
) ;

-- 2. Region (R01)
CREATE TABLE region (
region_id INT PRIMARY KEY,
country_id INT NOT NULL,
name VARCHAR(200) NOT NULL,
administrative_level INT NOT NULL,
geometry VARCHAR(20) NULL,
UNIQUE (country_id, administrative_level, name),
FOREIGN KEY (country_id) REFERENCES country (country_id),
CHECK (administrative_level BETWEEN 0 AND 5)
);

-- 6. Data Source
CREATE TABLE data_source (
Source_id INT PRIMARY KEY,
dataset_title VARCHAR(500) NOT NULL, 
publisher VARCHAR(200) NOT NULL,
source_url VARCHAR (2048),
release_date DATE,
accessed_at DATETIME,
methodoLogy VARCHAR(20)
);

-- 16. IPC Phase
CREATE TABLE ipc_phase (
phase_id INT PRIMARY KEY,
phase_number INT NOT NULL UNIQUE,
phase_name VARCHAR(100) NOT NULL UNIQUE, 
description TEXT,
CHECK (phasenumber BETWEEN 1 AND 5)
) ;

-- 3. Food Security Assessment (R02, R18) 
CREATE TABLE food_security_assessment (
assessment_id INT PRIMARY KEY,
region_id INT NOT NULL,
source_id INT NOT NULL,
assessment_type VARCHAR(20) NOT NULL,
analysis_date DATE NOT NULL,
publication_date DATE,
period_start DATE NOT NULL,
period_end DATE NOT NULL,
assessed_population INT NOT NULL,
population_scope VARCHAR (500) NOT NULL,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
UNIQUE (region_id, source_id, assessment_type, period_start, period_end),
FOREIGN KEY (region_id) REFERENCES region (region_id),
FOREIGN KEY (source_id) REFERENCES data_source (source_id),
CHECK (period_end >= period_start),
CHECK (publiction_dalysis_date >= analysis_date),
CHECK (assessed_population> 0)
) ;

-- 17. Assessment Phase Result (R03, R04) 
CREATE TABLE assessment_phase_result (
result_id INT PRIMARY KEY,
assessment_id INT NOT NULL,
phase_id INT NOT NULL,
affected_population INT NOT NULL, 
UNIQUE (assessment_id, phase_id),
FOREIGN KEY (assessment_id) REFERENCES food_security_assessment (assessment_id) ON DELETE CASCADE, 
FOREIGN KEY (phase_id) REFERENCES ipc_phase (phase_id),
CHECK (affected_population >= 0)
);

-- 8. Economic Indicator (R05, R19) 
CREATE TABLE economic_indicator (
economic_indicator_id INT AUTO_INCREMENT PRIMARY KEY, 
region_id INT NOT NULL,
source_id INT NOT NULL,
indicator_type VARCHAR (100) NOT NULL,
value DECIMAL (20,6) NOT NULL,
unit VARCHAR (50) NOT NULL,
measurement_definition VARCHAR(50) NOT NULL,
period_start DATE NOT NULL,
period_end DATE NOT NULL,
published_at DATETIME,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
INDEX (indicator_type, period_start, period_end),
FOREIGN KEY (region_id) REFERENCES region (region_id),
FOREIGN KEY (source_id) REFERENCES data_source (source_id),
CHECK (period_end>= period_start)
);


-- 10. Climate (R06, R20) 
CREATE TABLE climate ( 
climate_id INT PRIMARY KEY,
regionid INT NOT NULL,
source_id INT NOT NULL,
variable VARCHAR(100) NOT NULL,
value DECIMAL(20,6) NOT NULL,
unit VARCHAR (50) NOT NULL,
measurement_method VARCHAR(50),
period_start DATE NOT NULL,
period_end DATE NOT NULL,
published_at DATETIME,
updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (region_id) REFERENCES region (region_id),
FOREIGN KEY (source_id) REFERENCES data_source (source_id),
CHECK (period_end >= period_start)
);

-- 11. Nutritional Assessment (R07, R21) 
CREATE TABLE nutritional_assessment (
nutritional_assessment_id INT AUTO_INCREMENT PRIMARY KEY, 
region_id INT NOT NULL,
source_id INT NOT NULL,
measure_type VARCHAR(100) NOT NULL,
population_group VARCHAR (200) NOT NULL,
threshold_description VARCHAR(50),
prevalence_pct DECIMAL (5,2),
assessed_population INT,
affected_population INT,
period_start DATE NOT NULL,
period_end DATE
NOT NULL, 
published_at DATETIME,
updated_at
DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (region_id) REFERENCES region (region_id),
FOREIGN KEY (source_id) REFERENCES data_source (source_id),
CHECK (period_end >= period_start),
CHECK (prevalence_pct BETWEEN 0 AND 100),
CHECK (assessed_population > 0), CHECK (affected_population >= 0),
CHECK (affected_population= assessed_population)
);

