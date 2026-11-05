# Conceptual model
## Contents
The diagram contains 12 pages, 17 entities, 23 relationships, attributes and business rules. Page 1 is the entity index. Pages 2-7 show focused relationship diagrams; pages 8-12 expand each entity to show attributes. Repeated entity numbers represent the same entity, not new entities. The [p. #] labels in the index point to the attribute pages.

| Pages | Content |
|---|---|
| 1 | Entity index and navigation |
| 2 | Geography and food-security assessments: R01 - R04 |
| 3 | Regional conditions: R05 - R08 |
| 4 | Food prices: R09 - R10 |
| 5 | Assistance coverage and facilities: R11 - R14 |
| 6 | Contribution publishing: R11, R15 - R17 |
| 7 | Primary-source relationships: R18 - R23 |
| 8 | Country, Region, Food Security Assessment, Organization attributes |
| 9 | Program, Data Source, Contribution Opportunity, Economic Indicator attributes |
| 10 | Hazard, Climate, Nutritional Assessment, Commodity attributes |
| 11 | Price Observation, Distribution Center, User, IPC Phase attributes |
| 12 | Assessment Phase Result attributes, notation reference and examples |


**Color groups related information but carries no additional meaning.*\*

Relationships retain explicit minimum/maximum counts for precise reference. In our model, `0..*` is shown as `N` with optional participation for the 'other' entity, and `1..*` as `N` with *mandatory participation*. Participation should not be inferred solely from cardinality.

Each entity has its own proposed identifier. No weak-entity or identifying-relationship symbols are introduced.

## Expanding proposed entities

**IPC Phase** stores reusable phase definitions. This avoids repeatedly storing phase names and facilitates consistent filtering.

**Assessment Phase Result** Assessment Phase Result records the affected population in one phase for one Food Security Assessment. One region can have people in several phases at the same time. Assigning only one severity label to the region would not provide the distribution needed for the proposal’s phase 3+ percentage query.

The relationship is: Food Security Assessment `1` -- produces -- `1..*` Assessment Phase Result. IPC Phase `1` -- classifies -- `0..*` Assessment Phase Result. There must be at most one result for each assessment/phase pair. Completed assessments should contain a complete, applicable phase distribution, including explicitly reported zero values; an absent result must not automatically mean zero.

Illustration:
* A regional assessment covers 1,000 people.
* Its phase 3, 4 and 5 counts are 300, 250 and 150, respectively
* The phase 3+ percentage is `(300 + 250 + 150) / 1,000 * 100 = 70%`.

## Practical details about existing entities

1. **User publishes Contribution Opportunity (R17).** This gives the registered organization representative a concrete function. The publishing user’s Organization must match the Organization operating the opportunity’s Program. That rule applies to publishing and editing. User role and account status identify whether the representative is authorized. Public visitors can browse without an account.
2. **Economic Indicator supports more than inflation.** Each record has an indicator type, value, unit, measurement definition and period. A poverty-rate record can therefore support the poverty query. Compare like definitions and units. Reusable indicator metadata may later warrant a separate definition table during normalization.
3. **Measurements distinguish observation time from publication/update time.** A measurement’s date or period describes the conditions measured. For instance, publication/release dates and update timestamps describe the information’s availability and maintenance. Separate time period entities are not needed for the current requirements.
4. **Price Observation includes currency and quantity basis.** A price is meaningful only with its currency, quantity, unit, commodity and regional/market context. The model does not imply currency conversion or that these are directly comparable.
5. **Contribution Opportunity includes support_requested and an action/contact method.** This describes how the public can help without introducing a separately maintained Support Need entity. It is not a stock inventory or a structured commodity-demand planning module.
6. **Food Security Assessment includes assessed_population and population_scope.** These define the denominator and population behind its phase results. The Assessment Phase Result percentage is derived from its affected population and that denominator. We do not maintain a separate conflicting percentage.

Forecast, Conflict Event, and Conflict Exposure are not included because they are not necessary for the proposal’s features and would add additional data and validation requirements.

As for Nutrient, Hazard Exposure, and Time Period, we can introduce them later if actual requirements justify them.

## Entity catalogue

The first attribute shown for each entity is its proposed identifier.

### 1. Country

A monitored country; groups regions for national navigation.

**Attributes:** `country_id`, `name`, `iso3_code`.

### 2. Region

A geographic area within one country; anchors regional information and assistance.

**Attributes:** `region_id`, `name`, `administrative_level`, `geometry`.

### 3. Food Security Assessment

One dated regional assessment; provides the context and denominator for phase results.

**Attributes:** `assessment_id`, `assessment_type`, `analysis_date`, `publication_date`, `period_start`, `period_end`, `assessed_population`, `population_scope`, `updated_at`.

### 4. Organization

An aid organization that operates programs/facilities and has authorized representatives.

**Attributes:** `organization_id`, `name`, `organization_type`, `website`, `contact_email`.

### 5. Program

An assistance initiative run by one organization and serving one or more regions.

**Attributes:** `program_id`, `name`, `objective`, `status`, `start_date`, `end_date`.

### 6. Data Source

An identifiable dataset or publication release; establishes provenance for reported records.

**Attributes:** `source_id`, `dataset_title`, `publisher`, `source_url`, `release_date`, `accessed_at`, `methodology`.

### 7. Contribution Opportunity

A donation or volunteering opportunity offered by a program and published by an authorized user.

**Attributes:** `opportunity_id`, `opportunity_type`, `description`, `support_requested`, `action_url`, `contact_email`, `status`, `opens_at`, `closes_at`.

### 8. Economic Indicator

One regional economic measurement, such as poverty rate or inflation, for a specified period.

**Attributes:** `economic_indicator_id`, `indicator_type`, `value`, `unit`, `measurement_definition`, `period_start`, `period_end`, `published_at`, `updated_at`.

### 9. Hazard

A natural hazard event affecting one or more regions.

**Attributes:** `hazard_id`, `name`, `hazard_type`, `start_date`, `end_date`, `event_severity`, `published_at`, `updated_at`.

### 10. Climate

One regional climate observation, such as rainfall, for a specified period.

**Attributes:** `climate_id`, `variable`, `value`, `unit`, `measurement_method`, `period_start`, `period_end`, `published_at`, `updated_at`.

### 11. Nutritional Assessment

A dated measurement of nutritional adequacy for a defined population and measure.

**Attributes:** `nutritional_assessment_id`, `measure_type`, `population_group`, `threshold_description`, `prevalence_pct`, `assessed_population`, `affected_population`, `period_start`, `period_end`, `published_at`, `updated_at`.

### 12. Commodity

A food product whose prices are monitored; identifies comparable products.

**Attributes:** `commodity_id`, `name`, `category`, `grade_or_variety`.

### 13. Price Observation

One dated regional price for a commodity, expressed in a currency and quantity unit.

**Attributes:** `price_observation_id`, `price`, `currency`, `quantity`, `quantity_unit`, `market_basis`, `observed_at`, `published_at`, `updated_at`.

### 14. Distribution Center

A facility managed by one organization and located in one region.

**Attributes:** `distribution_center_id`, `name`, `center_type`, `address`, `latitude`, `longitude`, `operating_status`, `contact_email`.

### 15. User

An authorized organization representative who publishes and manages their organization records.

**Attributes:** `user_id`, `name`, `email`, `role`, `account_status`, `registered_at`.

### 16. IPC Phase

A reusable phase definition used to classify assessment results. Added to support consistent phase comparisons.

**Attributes:** `phase_id`, `phase_number`, `phase_name`, `description`.

### 17. Assessment Phase Result

The population in one IPC phase within one assessment. Added to support phase distributions and phase 3+ queries.

**Attributes:** `result_id`, `affected_population`, `percentage [derived]`.

## Complete relationship index

For the multiplicity columns below, **A per B** means how many A records relate to one B; **B per A** means how many B records relate to one A. These agree with the labels at the A and B ends of the diagram.

| ID | Entity A | Relationship | Entity B | A per B | B per A |
|---|---|---|---|---|---|
| R01 | Country | contains | Region | 1 | 0..* |
| R02 | Region | has assessments | Food Security Assessment | 1 | 0..* |
| R03 | Food Security Assessment | produces | Assessment Phase Result | 1 | 1..* |
| R04 | IPC Phase | classifies | Assessment Phase Result | 1 | 0..* |
| R05 | Region | has indicators | Economic Indicator | 1 | 0..* |
| R06 | Region | has observations | Climate | 1 | 0..* |
| R07 | Region | has nutrition data | Nutritional Assessment | 1 | 0..* |
| R08 | Region | affected by | Hazard | 1..* | 0..* |
| R09 | Region | has prices | Price Observation | 1 | 0..* |
| R10 | Commodity | priced in | Price Observation | 1 | 0..* |
| R11 | Organization | operates | Program | 1 | 0..* |
| R12 | Region | served by | Program | 1..* | 0..* |
| R13 | Organization | manages | Distribution Center | 1 | 0..* |
| R14 | Region | contains facilities | Distribution Center | 1 | 0..* |
| R15 | Program | offers | Contribution Opportunity | 1 | 0..* |
| R16 | Organization | has representatives | User | 1 | 0..* |
| R17 | User | publishes | Contribution Opportunity | 1 | 0..* |
| R18 | Data Source | documents | Food Security Assessment | 1 | 0..* |
| R19 | Data Source | documents | Economic Indicator | 1 | 0..* |
| R20 | Data Source | documents | Climate | 1 | 0..* |
| R21 | Data Source | documents | Nutritional Assessment | 1 | 0..* |
| R22 | Data Source | documents | Hazard | 1 | 0..* |
| R23 | Data Source | documents | Price Observation | 1 | 0..* |


### Relationship rules

- **R01:** Each region belongs to one country; a country may have no recorded regions.
- **R02:** Each assessment pertains to one region.
- **R03:** Each completed assessment has phase results; with each result belonging to one assessment.
- **R04:** Each phase result uses one IPC phase; phases are reused across assessments.
- **R05:** Each economic measurement pertains to one region.
- **R06:** Each climate observation pertains to one region.
- **R07:** Each nutritional assessment pertains to one region and a defined population.
- **R08:** A hazard affects one or more regions; a region may experience many hazards.
- **R09:** Each price observation concerns one region.
- **R10:** Each price observation describes one commodity.
- **R11:** Each program has one responsible organization.
- **R12:** A program serves one or more regions; a region may be served by many programs.
- **R13:** Each distribution center has one responsible organization.
- **R14:** Each distribution center is located in one region.
- **R15:** Each opportunity belongs to one program.
- **R16:** Each registered user represents one organization.
- **R17:** Each opportunity has one publishing user that represents the program's organization.
- **R18:** Each Food Security Assessment record cites one primary source release.
- **R19:** Each Economic Indicator record cites one primary source release.
- **R20:** Each Climate record cites one primary source release.
- **R21:** Each Nutritional Assessment record cites one primary source release.
- **R22:** Each Hazard record cites one primary source release.
- **R23:** Each Price Observation record cites one primary source release.


## Supported queries (primary)

| Proposal query | Data and relationship flow | Condition |
|---|---|---|
| Which organizations have active programs in a region? | Region -- R12 -- Program -- R11 -- Organization | Filter program status and dates; use distinct organizations when several programs qualify. |
| What percentage of a region's population faces food insecurity? | Region -- R02 -- Food Security Assessment -- R03 -- Assessment Phase Result -- R04 -- IPC Phase | Define the threshold first. If using phase 3+, sum the relevant counts and divide by assessed_population. Label a subset denominator accurately; it is not automatically the entire region. |
| Which region has the highest percentage in IPC phase 3 or above? | The same assessment/result/phase path | Use comparable periods, population coverage and assessment types, and select one relevant assessment version per region. |
| Which regions have the highest poverty rates in a specified period? | Region -- R05 -- Economic Indicator | Filter indicator_type to poverty rate and match measurement definition, unit and period before ranking. |
| How has food insecurity changed in a selected region? | Region -- R02 -- dated assessments -- R03 -- phase results | Compare equivalent measures over time; distinguish current assessments from projections and avoid counting multiple releases as separate periods. |
