# BC27 Jobs & Projects Events - Project Management Integration Points

Event reference for Jobs (Projects) module in Business Central 27. Extend job planning, WIP calculation, resource allocation, and project costing.

**Module**: Jobs & Projects
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Job Planning Events

### OnBeforeCreateJobPlanningLine
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before creating job planning line
- **Cancellable**: Yes
- **Parameters**: `var JobPlanningLine: Record "Job Planning Line"`, `var Handled: Boolean`
- **Uses**: Auto-populate planning details, apply resource rates, validate budget limits, calculate estimates
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

### OnAfterCreateJobPlanningLine
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: After job planning line created
- **Parameters**: `var JobPlanningLine: Record "Job Planning Line"`
- **Uses**: Create resource reservations, update project timeline, trigger capacity planning, sync with project management tools
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

### OnBeforeModifyJobPlanningLine
- **Publisher**: Table 1003 "Job Planning Line"
- **When**: Before job planning line modification
- **Parameters**: `var Rec: Record "Job Planning Line"`, `var xRec: Record "Job Planning Line"`
- **Uses**: Validate budget impact, check approval requirements, log planning changes, recalculate dependencies
- **Source**: [JobPlanningLine.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobPlanningLine.Table.al)

---

## Job Posting Events

### OnBeforePostJobJnlLine
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before job journal line posting
- **Cancellable**: Yes
- **Parameters**: `var JobJournalLine: Record "Job Journal Line"`, `var Handled: Boolean`
- **Uses**: Validate project codes, check budget availability, verify resource assignments, apply cost markup
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforePostJobJnlLine', '', false, false)]
local procedure ValidateBudget(var JobJournalLine: Record "Job Journal Line"; var Handled: Boolean)
var
    Job: Record Job;
begin
    Job.Get(JobJournalLine."Job No.");
    if Job."ABC Budget Exceeded" then begin
        Error('Job %1 budget exceeded. Posting not allowed.', Job."No.");
        Handled := true;
    end;
end;
```

### OnAfterPostJobJnlLine
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: After job ledger entry created
- **Parameters**: `var JobJournalLine: Record "Job Journal Line"`, `JobLedgerEntryNo: Integer`
- **Uses**: Update project actuals, recalculate WIP, update earned value, sync with time tracking systems
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

---

## WIP & Revenue Recognition Events

### OnBeforeCalculateWIP
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before WIP calculation for job
- **Cancellable**: Yes
- **Parameters**: `var Job: Record Job`, `var Handled: Boolean`
- **Uses**: Apply custom WIP methods, validate completion percentage, adjust recognition criteria, handle milestone-based recognition
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

### OnAfterCalculateWIP
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: After WIP calculation completed
- **Parameters**: `var Job: Record Job`, `var WIPEntry: Record "Job WIP Entry"`
- **Uses**: Post WIP entries to G/L, generate WIP reports, update project financials, trigger revenue recognition
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

### OnBeforeRecognizeRevenue
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before revenue recognition posting
- **Cancellable**: Yes
- **Parameters**: `var Job: Record Job`, `var Handled: Boolean`
- **Uses**: Validate revenue recognition criteria, apply recognition method, check invoice status, calculate deferred revenue
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

---

## Job Task & Budget Events

### OnBeforeCreateJobTask
- **Publisher**: Table 1001 "Job Task"
- **When**: Before job task creation
- **Parameters**: `var Rec: Record "Job Task"`, `var xRec: Record "Job Task"`
- **Uses**: Auto-populate task attributes, apply WBS numbering, set default budgets, create task dependencies
- **Source**: [JobTask.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobTask.Table.al)

### OnAfterModifyJobTask
- **Publisher**: Table 1001 "Job Task"
- **When**: After job task modified
- **Parameters**: `var Rec: Record "Job Task"`, `var xRec: Record "Job Task"`
- **Uses**: Recalculate project schedule, update critical path, adjust resource allocations, notify project team
- **Source**: [JobTask.Table.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobTask.Table.al)

### OnBeforeUpdateJobBudget
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before job budget update
- **Cancellable**: Yes
- **Parameters**: `var Job: Record Job`, `BudgetAmount: Decimal`, `var Handled: Boolean`
- **Uses**: Validate budget changes, require approval for increases, log budget history, check contract limits
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

---

## Resource & Cost Events

### OnBeforeAllocateJobResource
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before resource allocation to job
- **Cancellable**: Yes
- **Parameters**: `var Job: Record Job`, `ResourceNo: Code[20]`, `var Handled: Boolean`
- **Uses**: Check resource availability, verify skill requirements, validate cost rates, apply allocation rules
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

### OnAfterCalculateJobCost
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: After job cost calculation
- **Parameters**: `var Job: Record Job`, `var TotalCost: Decimal`
- **Uses**: Apply markup, add indirect costs, calculate profit margin, update project P&L
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

---

## Job Completion Events

### OnBeforeCompleteJob
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: Before marking job as complete
- **Cancellable**: Yes
- **Parameters**: `var Job: Record Job`, `var Handled: Boolean`
- **Uses**: Validate all tasks completed, check for open purchase orders, verify final invoicing, ensure WIP is zero
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Line", 'OnBeforeCompleteJob', '', false, false)]
local procedure ValidateJobCompletion(var Job: Record Job; var Handled: Boolean)
var
    JobPlanningLine: Record "Job Planning Line";
begin
    JobPlanningLine.SetRange("Job No.", Job."No.");
    JobPlanningLine.SetFilter("Remaining Qty.", '<>0');
    if not JobPlanningLine.IsEmpty then begin
        Error('Cannot complete job %1. Tasks with remaining quantities exist.', Job."No.");
        Handled := true;
    end;
end;
```

### OnAfterCompleteJob
- **Publisher**: Codeunit 1000 "Job Jnl.-Post Line"
- **When**: After job completed
- **Parameters**: `var Job: Record Job`
- **Uses**: Archive project data, generate completion reports, calculate final profitability, update KPIs, notify stakeholders
- **Source**: [JobJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/Jobs/Jobs/JobJnlPostLine.Codeunit.al)

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Jobs Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#jobs)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 15+ jobs events from Planning, Posting, WIP, Budgeting, and Resource Allocation
**Version**: 1.0
**Last Updated**: 2025-11-08
