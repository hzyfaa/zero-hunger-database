USE zero_hunger;

CREATE TABLE `country`
(
    `country_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`       text                NOT NULL,
    `iso3_code`  varchar(3)          NOT NULL
);

CREATE TABLE `region`
(
    `region_id`            integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`                 varchar(200)        NOT NULL,
    `administrative_level` integer             NOT NULL,
    `geometry`             text,
    `country_id`           integer             NOT NULL
);

CREATE TABLE `data_source`
(
    `source_id`     integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `dataset_title` text                NOT NULL,
    `publisher`     text                NOT NULL,
    `source_url`    text                NOT NULL,
    `release_date`  date,
    `accessed_at`   timestamp           NOT NULL,
    `methodology`   text                NOT NULL
);

CREATE TABLE `ipc_phase`
(
    `phase_id`     integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `phase_number` integer             NOT NULL,
    `phase_name`   text                NOT NULL,
    `description`  text                NOT NULL,
    CHECK (phase_number BETWEEN 1 AND 5)
);

CREATE TABLE `organization`
(
    `organization_id`   integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`              text                NOT NULL,
    `organization_type` text                NOT NULL,
    `website`           text,
    `contact_email`     text
);

CREATE TABLE `app_user`
(
    `user_id`         integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`            text                NOT NULL,
    `email`           varchar(254)        NOT NULL,
    `role`            text                NOT NULL,
    `account_status`  text                NOT NULL,
    `registered_at`   timestamp           NOT NULL,
    `organization_id` integer             NOT NULL
);

CREATE TABLE `program`
(
    `program_id`      integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`            text                NOT NULL,
    `objective`       text                NOT NULL,
    `status`          text                NOT NULL,
    `start_date`      date                NOT NULL,
    `end_date`        date,
    `organization_id` integer             NOT NULL,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE `commodity`
(
    `commodity_id`     integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`             text                NOT NULL,
    `category`         text                NOT NULL,
    `grade_or_variety` text
);

CREATE TABLE `food_security_assessment`
(
    `assessment_id`       integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `assessment_type`     text                NOT NULL,
    `analysis_date`       date,
    `publication_date`    date,
    `period_start`        date                NOT NULL,
    `period_end`          date                NOT NULL,
    `assessed_population` integer             NOT NULL,
    `population_scope`    text                NOT NULL,
    `updated_at`          timestamp           NOT NULL,
    `region_id`           integer             NOT NULL,
    `source_id`           integer             NOT NULL,
    CHECK (assessed_population > 0),
    CHECK (assessment_type IN ('current', 'projected')),
    CHECK (period_end >= period_start)
);

CREATE TABLE `assessment_phase_result`
(
    `result_id`           integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `affected_population` integer             NOT NULL,
    `assessment_id`       integer             NOT NULL,
    `phase_id`            integer             NOT NULL,
    CHECK (affected_population >= 0)
);

CREATE TABLE `economic_indicator`
(
    `economic_indicator_id`  integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `indicator_type`         text                NOT NULL,
    `value`                  decimal(18, 6)      NOT NULL,
    `unit`                   text                NOT NULL,
    `measurement_definition` text                NOT NULL,
    `period_start`           date                NOT NULL,
    `period_end`             date                NOT NULL,
    `published_at`           timestamp,
    `updated_at`             timestamp           NOT NULL,
    `region_id`              integer             NOT NULL,
    `source_id`              integer             NOT NULL,
    CHECK (period_end >= period_start)
);

CREATE TABLE `climate`
(
    `climate_id`         integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `variable`           text                NOT NULL,
    `value`              decimal(18, 6)      NOT NULL,
    `unit`               text                NOT NULL,
    `measurement_method` text                NOT NULL,
    `period_start`       date                NOT NULL,
    `period_end`         date                NOT NULL,
    `published_at`       timestamp,
    `updated_at`         timestamp           NOT NULL,
    `region_id`          integer             NOT NULL,
    `source_id`          integer             NOT NULL,
    CHECK (period_end >= period_start)
);

CREATE TABLE `nutritional_assessment`
(
    `nutritional_assessment_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `measure_type`              text                NOT NULL,
    `population_group`          text                NOT NULL,
    `threshold_description`     text                NOT NULL,
    `prevalence_pct`            decimal(5, 2)       NOT NULL,
    `assessed_population`       integer,
    `affected_population`       integer,
    `period_start`              date                NOT NULL,
    `period_end`                date                NOT NULL,
    `published_at`              timestamp,
    `updated_at`                timestamp           NOT NULL,
    `region_id`                 integer             NOT NULL,
    `source_id`                 integer             NOT NULL,
    CHECK (prevalence_pct BETWEEN 0 AND 100),
    CHECK (assessed_population IS NULL OR assessed_population >= 0),
    CHECK (affected_population IS NULL OR affected_population >= 0),
    CHECK (period_end >= period_start)
);

CREATE TABLE `hazard`
(
    `hazard_id`      integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`           text                NOT NULL,
    `hazard_type`    text                NOT NULL,
    `start_date`     date                NOT NULL,
    `end_date`       date,
    `event_severity` text                NOT NULL,
    `published_at`   timestamp,
    `updated_at`     timestamp           NOT NULL,
    `source_id`      integer             NOT NULL,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE `price_observation`
(
    `price_observation_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `price`                decimal(14, 4)      NOT NULL,
    `currency`             varchar(3)          NOT NULL,
    `quantity`             decimal(12, 4)      NOT NULL,
    `quantity_unit`        text                NOT NULL,
    `market_basis`         text                NOT NULL,
    `observed_at`          timestamp           NOT NULL,
    `published_at`         timestamp,
    `updated_at`           timestamp           NOT NULL,
    `region_id`            integer             NOT NULL,
    `commodity_id`         integer             NOT NULL,
    `source_id`            integer             NOT NULL,
    CHECK (price >= 0),
    CHECK (quantity > 0)
);

CREATE TABLE `distribution_center`
(
    `distribution_center_id` integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `name`                   text                NOT NULL,
    `center_type`            text                NOT NULL,
    `address`                text,
    `latitude`               decimal(9, 6),
    `longitude`              decimal(9, 6),
    `operating_status`       text                NOT NULL,
    `contact_email`          text,
    `organization_id`        integer             NOT NULL,
    `region_id`              integer             NOT NULL,
    CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
    CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);

CREATE TABLE `contribution_opportunity`
(
    `opportunity_id`       integer PRIMARY KEY NOT NULL AUTO_INCREMENT,
    `opportunity_type`     text                NOT NULL,
    `description`          text                NOT NULL,
    `support_requested`    text                NOT NULL,
    `action_url`           text                NOT NULL,
    `contact_email`        text,
    `status`               text                NOT NULL,
    `opens_at`             timestamp           NOT NULL,
    `closes_at`            timestamp,
    `program_id`           integer             NOT NULL,
    `published_by_user_id` integer             NOT NULL,
    CHECK (closes_at IS NULL OR closes_at >= opens_at)
);

CREATE TABLE `program_region`
(
    `program_id` integer NOT NULL,
    `region_id`  integer NOT NULL,
    PRIMARY KEY (`program_id`, `region_id`)
);

CREATE TABLE `hazard_region`
(
    `hazard_id` integer NOT NULL,
    `region_id` integer NOT NULL,
    PRIMARY KEY (`hazard_id`, `region_id`)
);

-- indexes
CREATE UNIQUE INDEX `country_index_0` ON `country` (`iso3_code`);

CREATE UNIQUE INDEX `region_index_1` ON `region` (`country_id`, `name`, `administrative_level`);

CREATE UNIQUE INDEX `ipc_phase_index_2` ON `ipc_phase` (`phase_number`);

CREATE UNIQUE INDEX `app_user_index_3` ON `app_user` (`email`);

CREATE UNIQUE INDEX `assessment_phase_result_index_4` ON `assessment_phase_result` (`assessment_id`, `phase_id`);

-- table constraints
ALTER TABLE `region`
    ADD CONSTRAINT `R01` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT;

ALTER TABLE `food_security_assessment`
    ADD CONSTRAINT `R02` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `assessment_phase_result`
    ADD CONSTRAINT `R03` FOREIGN KEY (`assessment_id`) REFERENCES `food_security_assessment` (`assessment_id`) ON DELETE RESTRICT;

ALTER TABLE `assessment_phase_result`
    ADD CONSTRAINT `R04` FOREIGN KEY (`phase_id`) REFERENCES `ipc_phase` (`phase_id`) ON DELETE RESTRICT;

ALTER TABLE `economic_indicator`
    ADD CONSTRAINT `R05` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `climate`
    ADD CONSTRAINT `R06` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `nutritional_assessment`
    ADD CONSTRAINT `R07` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `hazard_region`
    ADD CONSTRAINT `R08a` FOREIGN KEY (`hazard_id`) REFERENCES `hazard` (`hazard_id`) ON DELETE RESTRICT;

ALTER TABLE `hazard_region`
    ADD CONSTRAINT `R08b` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `price_observation`
    ADD CONSTRAINT `R09` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `price_observation`
    ADD CONSTRAINT `R10` FOREIGN KEY (`commodity_id`) REFERENCES `commodity` (`commodity_id`) ON DELETE RESTRICT;

ALTER TABLE `program`
    ADD CONSTRAINT `R11` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`organization_id`) ON DELETE RESTRICT;

ALTER TABLE `program_region`
    ADD CONSTRAINT `R12a` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE RESTRICT;

ALTER TABLE `program_region`
    ADD CONSTRAINT `R12b` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `distribution_center`
    ADD CONSTRAINT `R13` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`organization_id`) ON DELETE RESTRICT;

ALTER TABLE `distribution_center`
    ADD CONSTRAINT `R14` FOREIGN KEY (`region_id`) REFERENCES `region` (`region_id`) ON DELETE RESTRICT;

ALTER TABLE `contribution_opportunity`
    ADD CONSTRAINT `R15` FOREIGN KEY (`program_id`) REFERENCES `program` (`program_id`) ON DELETE RESTRICT;

ALTER TABLE `app_user`
    ADD CONSTRAINT `R16` FOREIGN KEY (`organization_id`) REFERENCES `organization` (`organization_id`) ON DELETE RESTRICT;

ALTER TABLE `contribution_opportunity`
    ADD CONSTRAINT `R17` FOREIGN KEY (`published_by_user_id`) REFERENCES `app_user` (`user_id`) ON DELETE RESTRICT;

ALTER TABLE `food_security_assessment`
    ADD CONSTRAINT `R18` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;

ALTER TABLE `economic_indicator`
    ADD CONSTRAINT `R19` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;

ALTER TABLE `climate`
    ADD CONSTRAINT `R20` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;

ALTER TABLE `nutritional_assessment`
    ADD CONSTRAINT `R21` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;

ALTER TABLE `hazard`
    ADD CONSTRAINT `R22` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;

ALTER TABLE `price_observation`
    ADD CONSTRAINT `R23` FOREIGN KEY (`source_id`) REFERENCES `data_source` (`source_id`) ON DELETE RESTRICT;