# Zero Hunger — Data Source Plan

### Note
*We have identified some official sources for the major monitoring categories. Our next step is to verify geographic and temporal compatibility and import a small, traceable sample. Operational records will be curated or clearly simulated for the prototype.*

## Sources and database coverage

| Source | What we would obtain and store | Access and practical considerations |
|---|---|---|
| **IPC — [Population Tracking Tool](https://www.ipcinfo.org/ipc-country-analysis/population-tracking-tool/en/)** and [API documentation](https://docs.api.ipcinfo.org/) | Regional assessment periods, assessed populations and populations by IPC phase → **Food Security Assessment, IPC Phase, Assessment Phase Result, Data Source**. Supports phase 3+ comparisons and trends. | Public download tool provides historical population data. |
| **geoBoundaries — [official API guide](https://www.geoboundaries.org/api.html)** | Country/subnational names and boundary geometry → **Country, Region**. Supports selecting regions on a map. | API returns metadata and links to boundary files. Select the release, country and administrative level explicitly. Keep attribution and boundary-version information in the import notes. Boundaries must match the assessment geography; a county is not automatically equivalent to an IPC analysis area. |
| **WFP — [Kenya food-price dashboard](https://dataviz.vam.wfp.org/eastern-africa/kenya/economic/prices)**; [Kenya dataset on HDX](https://data.humdata.org/dataset/wfp-food-prices-for-kenya) | Food product, market, date, price, currency and quantity unit → **Commodity, Price Observation, Region, Data Source**. | Prefer a downloadable snapshot. The WFP dashboard was located; the HDX dataset page blocked automated access during this review, so the actual CSV download and columns still need manual verification. Map markets to regions and retain market identity and retail/wholesale basis in `market_basis`. |
| **World Bank — [Kenya monthly food-price estimates](https://microdata.worldbank.org/index.php/catalog/6167)** | Alternative product-and-market price series → **Commodity, Price Observation, Data Source**. | Catalog provides download access and methodology. These series combine observed inputs with estimation; label imported values as estimates in source methodology and market basis. Do not silently mix these with directly observed prices. Use as a fallback if WFP access is inconvenient. |
| **Kenya National Bureau of Statistics — [Kenya Poverty Report 2022](https://www.knbs.or.ke/reports/kenya-poverty-report-2022/)**; [official PDF](https://www.knbs.or.ke/wp-content/uploads/2024/10/The-Kenya-Poverty-Report-2022.pdf) | County poverty measures → **Economic Indicator, Region, Data Source**. Supports comparisons of contextual economic conditions. | Start with selected published county tables, transcribed to CSV and checked by a second member. Store the measure definition, unit and reference year. Overall poverty and food poverty are different indicators. The report is historical, not a current/live measurement. |
| **KNBS / DHS — [Kenya DHS 2022](https://www.knbs.or.ke/reports/kdhs-2022/)**; [full report](https://dhsprogram.com/pubs/pdf/FR380/FR380.pdf) | Published nutrition measures, such as child wasting or stunting → **Nutritional Assessment, Region, Data Source**. | Use public summary tables with appropriate geographic coverage. Preserve age group, measure and threshold. Survey sample counts are not regional population totals; leave affected population null when no valid population estimate is provided. Raw survey microdata are unnecessary for the first import. |
| **NASA POWER — [daily API documentation](https://power.larc.nasa.gov/docs/services/api/temporal/daily/)** | Climate variables, dates and units → **Climate, Region, Data Source**. | API supports machine-readable output. A grid/point observation is not a county average. If initially using a representative point, record that explicitly in `measurement_method`; otherwise aggregate spatial data using a documented method. Preserve units and missing-value codes during cleaning. |
| **GDACS — [official API explorer](https://www.gdacs.org/gdacsapi/swagger/index.html)** | Hazard events, dates, event types and severity → **Hazard, Hazard Region, Data Source**. | Select a small set of relevant events. Link to regions using documented event footprints or reports, rather than assuming every region in the country was affected. Coverage is selective, so absence of a record does not prove absence of hazards. |
| **WFP — [Kenya country page and linked strategic plan](https://www.wfp.org/countries/kenya)** | Organization and documented program descriptions → **Organization, Program**; program-region links only where coverage is explicitly documented. | Suitable for a small, manually curated set of public records. A country-level plan alone does not establish a specific distribution center, local volunteering opportunity or county-level program presence. |

## Information supplied

| Information | Current population plan |
|---|---|
| Registered organization representatives (**User / `app_user`**) | Application-created records. (simulated) |
| **Contribution Opportunity** | Submitted by an authorized organization representative. (simulated) |
| **Distribution Center** | Curated public facility records where available. (simulated) |
| **Program Region / Hazard Region** | Linking records created from verified geographic coverage, not independent datasets. |
| **Data Source** | One record per identifiable release/import source, with publisher, URL, release date where available, retrieval date and methodology. |

## Goals

1. Select two or three compatible regions and one assessment period. Add a second comparable period only after the first import works.
2. Download and preserve the original files; record retrieval date, release/version, attribution and permitted use. Webpage review is not the same as downloading or validating the data.
3. Build a small geographic crosswalk. Do not map national figures into every region or combine overlapping administrative levels.
4. Import IPC assessments and phase results first. Keep current and projected assessments separate, and use one release per comparison.
5. Add one supporting indicator and one commodity series. Other categories can follow once this core path works.
6. Retain missing values as unknown, not zero. Record source dates separately from measurement dates and database update dates.
