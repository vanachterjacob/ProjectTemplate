# Customer Project Configuration

## Customer Details
- **Name**: [CUSTOMER_NAME]
- **Prefix**: [XXX]
- **ID Range**: [77100-77200] (development) → [PRODUCTION_RANGE] (assigned by Object Ninja)
- **BC Version**: Business Central 27 (SaaS)

## Project Settings

### Object Naming
- **Prefix**: [XXX] (all objects, variables, functions)
- **Example**: [XXX]CustomerExt, [XXX]SalesOrderPage

### ID Assignment
- **Development**: Use dummy IDs (77100-77200)
- **Production**: Object Ninja assigns from customer range
- **NEVER**: Manually assign production IDs

### Publisher Info
- **Publisher**: [PUBLISHER_NAME]
- **App Name**: [XXX] [Customer] Extension
- **Version**: 1.0.0.0

## Development Standards

### Code Style
- **Indentation**: 4 spaces (AL default)
- **Line Length**: Max 120 characters
- **Comments**: English only
- **Naming**: PascalCase for objects, camelCase for local variables

### Git Workflow
- **Main Branch**: main
- **Feature Branches**: feature/[XXX]-[feature-name]
- **Commit Format**: `[XXX] feat: description` or `[XXX] fix: description`

### Testing Requirements
- Unit tests for all business logic
- Integration tests for posting routines
- Manual testing checklist for UI changes

## Project Contacts
- **Product Owner**: [NAME]
- **Tech Lead**: [NAME]
- **DevOps**: [NAME]

## Special Requirements
[Add customer-specific requirements here]
- Example: "Always log to Application Insights"
- Example: "Integration with SAP required"
- Example: "Multi-language support (EN, FR, DE)"

## Notes
[Add any customer-specific notes, preferences, or constraints]
