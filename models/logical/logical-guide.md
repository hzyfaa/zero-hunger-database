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
