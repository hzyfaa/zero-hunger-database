# Logical Model

## 1. Contents
This document describes **19 tables, 25 foreign-key constraints, five unique indexes and 18 check constraints**.

## 2. Model artifacts

| Artifact | Purpose |
|---|---|
| logical-model.dbml | Editable model definitions maintained in dbdiagram|
| logical-model.pdf | Visual export of the same model version |

## 3. Translation from conceptual to logical design

The 17 conceptual entities each map to one table. Two association tables resolve existing many-to-many relationships:

- **`program_region`:** One row per program/region pair. A program can serve several regions and a region can receive several programs.
- **`hazard_region`:** One row per hazard/region pair. A hazard can affect several regions and a region can experience several hazards.

**Naming conventions**

- Table and column names use lowercase `snake_case`.
- The conceptual User entity maps to `app_user` to avoid ambiguity with SQL keyword `USER`.
- Each of the 17 entity tables uses an integer as a primary key with `AUTO_INCREMENT`.
- Association tables use composite primary keys. These are composed by their two foreign keys.
- Foreign keys are mandatory in this model.
- Referenced parent records should not be deleted while dependent records exist.
- Auto-generated IDs only distinguish stored rows. They do not, by themselves, prevent duplicate real world observations.
- The phase percentage remains derived rather than independently stored.

## 4. Domains and constraints

### unique identifiers
*Note: the table below excludes primary keys*

| Table | Unique column(s) | Reason |
|---|---|---|
| `country` | `iso3_code` | Prevent multiple country records with the same code. |
| `region` | `country_id`, `name`, `administrative_level` | Current geographic identity. Same level names are not universally unique within a country. |
| `ipc_phase` | `phase_number` | One definition for each phase number. |
| `app_user` | `email` | One registered account per email under MySQL collation's comparison rules. |
| `assessment_phase_result` | `assessment_id`, `phase_id` | One count for each phase within an assessment. |

### data types

| Fields | Type | Rationale |
|---|---|---|
| `region.name` | `VARCHAR(200)` | Bounded text, usable in the full unique index. |
| `app_user.email` | `VARCHAR(254)` | Bounded text, usable in the full unique index. |
| Price | `DECIMAL(14,4)` | Preserves four fractional digits for currency measurements. |
| Price quantity | `DECIMAL(12,4)` | Prices should support fractional quantities. |
| Nutrition prevalence | `DECIMAL(5,2)` | Stores percentages to two decimal places, with a [0, 100] check. |
| Latitude and longitude | `DECIMAL(9,6)` | Six fractional digits, with separate geographic range checks. |
| Economic and climate values | `DECIMAL(18,6)` | Supports fractional indicator values. Validate range and precision against selected datasets. |
| Country and currency codes | `VARCHAR(3)` | Holds three character codes, and the length alone does not validate membership in a code standard. |


- `DATE` fields identify dates or period boundaries. 
- `TIMESTAMP` fields record observation/publication/access/update times where specified. 

*Note: have not yet agreed on a session/import timezone and handling of date only source values before loading data. The schema does not declare automatic timestamp defaults or update behavior.*

- Missing information is represented by `NULL` only where permitted. 
- Missing observations are not zeros. 
- Required fields must be checked against real source availability

*Note: do not fabricate values solely to satisfy `NOT NULL`.*

### Existing CHECK constraints

- IPC phase number is between [1, 5]
- Food-security assessed population is positive. Assessment type is `current` or `projected`.
- Phase result population is nonnegative.
- Measurement period end is on or after its start.
- Program and hazard end dates, *when supplied*, are on or after their start dates.
- Nutrition prevalence is between 0 and 100. Supplied nutrition population counts are nonnegative.
- Price is nonnegative and given quantity is positive.
- Latitude is between −90 and 90. Longitude is between [−180, 180] *when supplied*.
- Opportunity closing time, *when supplied*, is not before opening time.

## 5. Normalization rationale and review

**Target:** Third normal form (3NF).

**Status:** A complete dependency review and team approval has not yet been recorded.

| Form | Design rationale |
|---|---|
| 1NF | | 
| 2NF | |
| 3NF | |
