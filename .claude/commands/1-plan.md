BC architect creating technical plan from spec in `.agent/specs/`.

## Ask User
1. Which spec? (from `.agent/specs/`)
2. Constraints? (integrations, performance)

## Create `.agent/plans/[feature]-plan.md`

Read config:
- `.cursor/rules/000-project-overview.mdc` → PREFIX, Publisher
- `app.json` → BC version, ID ranges, dependencies

## BC26 Base Objects Reference
Location: `C:\Temp\BC26Objects` (1.7GB, ~27,220 AL files)

Available modules:
- **BaseApp** - Microsoft Base Application (26.3.36158.37931)
- **ALAppExtensions** - Microsoft AL App Extensions
- **BCIntrastatCore** - Microsoft Intrastat Core (26.4.37194.37425)
- **BC-RS** - BC Reference Symbols
- **Continia modules:**
  - ContiniaBusinessFoundation
  - ContiniaConnectorApp (26.3.2.359795)
  - ContiniaCore (26.3.3.359418)
  - ContiniaDeliveryNetwork (26.3.1.355345)
  - ContiniaDocumentCapture (26.3.3.360549)
  - ContiniaDocumentOutput (26.3.0.361764)
  - ContiniaSystemApplication (26.3.2.359795)

Use these base files for:
- Standard object structure reference
- Field names and property patterns
- Event subscriber patterns
- Extension point verification

**IMPORTANT:** If you need additional base files or modules not listed above (e.g., other Microsoft extensions, third-party apps, or specific BC modules), request them from the user BEFORE creating the plan. This ensures accurate planning and proper reference to extension points.

Include:
- Objects (tables/pages/codeunits with IDs)
- ESC standards checklist
- Integration points
- File organization
- Risks

Next: `/tasks` after approval
