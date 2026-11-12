# Data Sources and Schema Mapping

*Note: Kenya has relevant official assessment, poverty and nutrition publications, alongside market and environmental sources. We can use Kenya as a small sample dataset.*

The mappings are design guidance, not a claim that every provider's raw column names match our schema.

## 1. Source index

### 1 — IPC food-security assessments and phase definitions

**Publisher:** Integrated Food Security Phase Classification (IPC).

- [Population Tracking Tool](https://www.ipcinfo.org/ipc-country-analysis/population-tracking-tool/en/)
- [Kenya country analyses](https://www.ipcinfo.org/ipc-country-analysis/en/?country=KEN)
- [Public API documentation](https://docs.api.ipcinfo.org/)
- [Acute food-insecurity reference table](https://www.ipcinfo.org/ipc-manual-interactive/ipc-acute-food-insecurity-protocols/function-2-classify-severity-and-identify-key-drivers/protocol-22-compare-evidence-against-the-ipc-acute-food-insecurity-reference-table/en/)

**Provides:** Source provides published analysis periods, population estimates and distributions across IPC phases. The tracking tool supports historical downloads while country analyses provide interpretation and coverage.

**Tables:** `food_security_assessment`, `assessment_phase_result`, `ipc_phase`, `data_source`. Geographic names directly map to `region`.

### 2 - geoBoundaries administrative geography

**Publisher:** geoBoundaries (geoLab @ William & Mary)

- [Official API and archival documentation](https://www.geoboundaries.org/api.html)

**Provides:** Country and administrative boundary metadata, names, administrative levels and links to spatial files.

**Tables:** `country`, `region`.

**Mapping:** Country metadata maps to `country.name` and `iso3_code`.

**Limitation:** Boundaries may differ from IPC analysis areas. Geography tables have no `source_id`.

### 3 — World Food Programme (WFP) food prices through Humanitarian Data Exchange (HDX)

**Publisher:** WFP, distributed through United Nations Office for the Coordination of Humanitarian Affairs's (OCHA) Humanitarian Data Exchange.

- [Kenya food-price dataset](https://data.humdata.org/dataset/wfp-food-prices-for-kenya)
- [Official OCHA pipeline documentation](https://github.com/OCHA-DAP/hdx-scraper-wfp-foodprices)
- [HDX HAPI food-price usage guide](https://hdx-hapi.readthedocs.io/en/latest/data_usage_guides/food_security_nutrition_and_poverty/)

**Provides:** Market/product price records and contextual information needed to interpret them. OCHA documents the WFP-to-HDX processing pipeline.

**Tables:** `commodity`, `price_observation`, `data_source`. Market locations map to existing `region` rows.
