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
