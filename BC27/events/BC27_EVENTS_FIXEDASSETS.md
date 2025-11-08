# BC27 Fixed Assets Events - Asset Management Integration Points

Event reference for Fixed Assets module in Business Central 27. Extend depreciation, acquisition, disposal, and maintenance functionality.

**Module**: Fixed Assets
**Version**: 1.0
**BC Version**: 27
**Last Updated**: 2025-11-08

---

## Depreciation Events

### OnBeforePostFixedAssetDepreciation
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: Before depreciation posting
- **Cancellable**: Yes
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `var Handled: Boolean`
- **Uses**: Custom depreciation rules, validate depreciation book, apply accelerated methods, skip certain assets
- **Source**: [FAJnlPostLine.Codeunit.al](https://github.com/StefanMaron/MSDyn365BC.Code.History/blob/be-27/BaseApp/Source/Base%20Application/FixedAssets/Posting/FAJnlPostLine.Codeunit.al)

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforePostFixedAssetDepreciation', '', false, false)]
local procedure CustomDepreciationRule(var FAJournalLine: Record "FA Journal Line"; var Handled: Boolean)
begin
    if FAJournalLine."ABC Custom Depreciation" then begin
        ABCDepreciation.CalculateCustomMethod(FAJournalLine);
        Handled := true;
    end;
end;
```

### OnAfterPostFixedAssetDepreciation
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: After depreciation entry posted
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `FALedgerEntryNo: Integer`
- **Uses**: Update asset valuation reports, trigger tax reporting, sync to external systems, calculate tax deductions

### OnBeforeCalculateDepreciation
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: Before depreciation amount calculation
- **Cancellable**: Yes
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `DepreciationBook: Record "Depreciation Book"`, `var Amount: Decimal`, `var Handled: Boolean`
- **Uses**: Apply custom depreciation formula, handle partial periods, consider asset impairment, apply bonus depreciation

### OnAfterCalculateDepreciation
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: After depreciation calculated
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `var Amount: Decimal`
- **Uses**: Apply ceiling/floor limits, round to accounting standards, log depreciation calculations

---

## Acquisition Events

### OnBeforePostAcquisition
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: Before fixed asset acquisition posting
- **Cancellable**: Yes
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `var Handled: Boolean`
- **Uses**: Validate acquisition cost, check budget approval, verify vendor invoice, apply acquisition date rules

### OnAfterPostAcquisition
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: After acquisition posted
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `FALedgerEntryNo: Integer`
- **Uses**: Create insurance records, schedule maintenance, update asset register, trigger tax reporting

### OnBeforeCreateFixedAsset
- **Publisher**: Codeunit 5600 "FA Insert G/L Account"
- **When**: Before fixed asset master record creation
- **Cancellable**: Yes
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `var Handled: Boolean`
- **Uses**: Auto-assign asset numbers, populate default depreciation books, set location/department, create barcode tags

### OnAfterCreateFixedAsset
- **Publisher**: Codeunit 5600 "FA Insert G/L Account"
- **When**: After fixed asset created
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`
- **Uses**: Create related FA depreciation books, assign to responsible employee, update asset inventory, trigger insurance quote

---

## Disposal Events

### OnBeforePostDisposal
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: Before fixed asset disposal posting
- **Cancellable**: Yes
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `var Handled: Boolean`
- **Uses**: Validate disposal authorization, calculate gain/loss, verify all depreciation posted, check liens/encumbrances

**Example**:
```al
[EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforePostDisposal', '', false, false)]
local procedure ValidateDisposalAuth(var FAJournalLine: Record "FA Journal Line"; var Handled: Boolean)
var
    FixedAsset: Record "Fixed Asset";
begin
    FixedAsset.Get(FAJournalLine."FA No.");
    if FixedAsset."ABC Disposal Requires Approval" and (FAJournalLine."ABC Approval Status" <> FAJournalLine."ABC Approval Status"::Approved) then begin
        Error('Disposal of asset %1 requires approval', FAJournalLine."FA No.");
        Handled := true;
    end;
end;
```

### OnAfterPostDisposal
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: After disposal posted
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `FALedgerEntryNo: Integer`
- **Uses**: Close insurance policies, archive asset history, update disposal reports, trigger gain/loss tax reporting

### OnCalculateDisposalGainLoss
- **Publisher**: Codeunit 5610 "FA Jnl.-Post Line"
- **When**: Calculating disposal gain or loss
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `DisposalAmount: Decimal`, `var GainLoss: Decimal`
- **Uses**: Apply custom gain/loss calculation, consider accumulated depreciation, handle trade-ins, apply tax treatment

---

## Maintenance Events

### OnBeforePostMaintenance
- **Publisher**: Codeunit 5635 "FA Jnl.-Post Line"
- **When**: Before maintenance cost posting
- **Cancellable**: Yes
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `var Handled: Boolean`
- **Uses**: Validate maintenance type, check maintenance budget, verify vendor invoice, apply capitalization rules

### OnAfterPostMaintenance
- **Publisher**: Codeunit 5635 "FA Jnl.-Post Line"
- **When**: After maintenance posted
- **Parameters**: `var FAJournalLine: Record "FA Journal Line"`, `MaintenanceLedgerEntryNo: Integer`
- **Uses**: Update maintenance schedule, track asset downtime, calculate total maintenance cost, trigger warranty claims

### OnBeforeScheduleMaintenance
- **Publisher**: Codeunit 5641 "FA Maintenance"
- **When**: Before scheduling maintenance
- **Cancellable**: Yes
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `MaintenanceCode: Code[10]`, `var Handled: Boolean`
- **Uses**: Apply preventive maintenance rules, check asset availability, optimize maintenance timing, coordinate with production schedule

---

## Transfer & Reclassification Events

### OnBeforeTransferFixedAsset
- **Publisher**: Codeunit 5623 "FA Jnl.-Transfer"
- **When**: Before transferring asset between locations/departments
- **Cancellable**: Yes
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `NewLocationCode: Code[10]`, `var Handled: Boolean`
- **Uses**: Validate transfer authorization, update location master data, adjust depreciation books, notify receiving location

### OnAfterTransferFixedAsset
- **Publisher**: Codeunit 5623 "FA Jnl.-Transfer"
- **When**: After asset transfer completed
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `OldLocationCode: Code[10]`
- **Uses**: Update asset register, adjust insurance coverage, notify stakeholders, update reporting hierarchies

### OnBeforeReclassifyFixedAsset
- **Publisher**: Codeunit 5623 "FA Jnl.-Transfer"
- **When**: Before reclassifying asset (FA class change)
- **Cancellable**: Yes
- **Parameters**: `var FixedAsset: Record "Fixed Asset"`, `NewFAClassCode: Code[10]`, `var Handled: Boolean`
- **Uses**: Validate reclassification rules, adjust depreciation method, recalculate useful life, update tax classification

---

## Event Subscriber Template

```al
codeunit 77105 "ABC Fixed Assets Subscribers"
{
    // Custom Depreciation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforeCalculateDepreciation', '', false, false)]
    local procedure ApplyCustomDepreciation(var FixedAsset: Record "Fixed Asset"; DepreciationBook: Record "Depreciation Book"; var Amount: Decimal; var Handled: Boolean)
    var
        ABCDepreciation: Codeunit "ABC Custom Depreciation";
    begin
        if FixedAsset."ABC Use Custom Method" then begin
            Amount := ABCDepreciation.Calculate(FixedAsset, DepreciationBook);
            Handled := true;
        end;
    end;

    // Disposal Validation
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnBeforePostDisposal', '', false, false)]
    local procedure ValidateDisposal(var FAJournalLine: Record "FA Journal Line"; var Handled: Boolean)
    begin
        if FAJournalLine."ABC Requires Disposal Approval" then
            ABCApprovalMgmt.CheckDisposalApproval(FAJournalLine);
    end;

    // Acquisition Notification
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"FA Jnl.-Post Line", 'OnAfterPostAcquisition', '', false, false)]
    local procedure NotifyAcquisition(var FAJournalLine: Record "FA Journal Line"; FALedgerEntryNo: Integer)
    begin
        ABCNotification.SendAssetAcquisition(FAJournalLine."FA No.", FAJournalLine.Amount);
    end;
}
```

---

## Best Practices

### 1. **Depreciation**
- Always validate depreciation books before posting
- Consider partial period depreciation
- Handle leap years correctly
- Log all depreciation calculations

### 2. **Disposal**
- Require approval for high-value assets
- Calculate gain/loss accurately
- Ensure all depreciation is posted first
- Archive asset history before disposal

### 3. **Acquisition**
- Validate acquisition date (not future)
- Check budget availability
- Set up depreciation books immediately
- Consider capitalization thresholds

### 4. **Maintenance**
- Track maintenance history
- Apply capitalization vs expense rules correctly
- Schedule preventive maintenance
- Monitor total cost of ownership

---

## Additional Resources

- **Main Event Catalog**: [BC27_EVENT_CATALOG.md](../BC27_EVENT_CATALOG.md)
- **Event Index**: [BC27_EVENT_INDEX.md](../BC27_EVENT_INDEX.md)
- **Fixed Assets Module**: [BC27_MODULES_OVERVIEW.md](../BC27_MODULES_OVERVIEW.md#fixed-assets)
- **Source Repository**: [BC27 GitHub](https://github.com/StefanMaron/MSDyn365BC.Code.History/tree/be-27)

---

**Coverage**: 15+ fixed assets events from Depreciation, Acquisition, Disposal, Maintenance, and Transfers
**Version**: 1.0
**Last Updated**: 2025-11-08
