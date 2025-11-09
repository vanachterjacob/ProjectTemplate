# Pattern Library Index

**Purpose:** Searchable index of reusable AL development patterns

**Total Patterns:** 2 (example patterns included)

---

## How to Use

### Find a Pattern
```bash
/find-pattern [problem-description]
```

Examples:
- `/find-pattern custom ledger posting`
- `/find-pattern api rate limiting`
- `/find-pattern batch processing performance`

### Save a New Pattern
```bash
/save-pattern [pattern-name]
```

After implementing a reusable solution, save it for future projects.

---

## Patterns by Domain

### Posting & Ledgers

#### Custom Ledger Posting with Rollback

**File:** [learned/custom-ledger-posting.pattern.md](learned/custom-ledger-posting.pattern.md)
**Problem:** Atomic posting with full rollback for custom ledger entries
**Domain:** posting, ledgers
**Tags:** posting, ledger, transactions, rollback, ESC, TryFunction
**Reusability:** High
**Source:** ABC Logistics (commission tracking)
**Created:** 2025-11-09

---

### API & Integration

#### API Rate Limiter with Exponential Backoff

**File:** [learned/api-rate-limiter.pattern.md](learned/api-rate-limiter.pattern.md)
**Problem:** Prevent API throttling and handle retry logic gracefully
**Domain:** api, integration
**Tags:** api, integration, rate-limiting, retry, performance, external
**Reusability:** High
**Source:** Example pattern
**Created:** 2025-11-09

---

## Patterns by Tag

### Performance
- [Custom Ledger Posting with Rollback](#custom-ledger-posting-with-rollback) - Temp table staging
- [API Rate Limiter](#api-rate-limiter-with-exponential-backoff) - Throttling

### ESC Compliance
- [Custom Ledger Posting with Rollback](#custom-ledger-posting-with-rollback) - TryFunction pattern

### Transactions
- [Custom Ledger Posting with Rollback](#custom-ledger-posting-with-rollback) - Atomic operations

### External Integration
- [API Rate Limiter](#api-rate-limiter-with-exponential-backoff) - Rate limiting

---

## Pattern Statistics

**By Reusability:**
- High: 2 patterns
- Medium: 0 patterns
- Low: 0 patterns

**By Domain:**
- Posting & Ledgers: 1 pattern
- API & Integration: 1 pattern

**Most Used:**
1. Custom Ledger Posting (1 project)
2. API Rate Limiter (0 projects - example only)

---

## Adding New Patterns

1. Implement a solution in your project
2. Run `/save-pattern [name]` to document it
3. Pattern gets added to this index automatically
4. Find it later with `/find-pattern [keywords]`

---

## Pattern Quality Guidelines

**High-Quality Patterns Include:**
- ✅ Clear problem statement
- ✅ Well-explained solution with code
- ✅ ESC compliance notes
- ✅ Performance characteristics
- ✅ When to use / when not to use
- ✅ Multiple examples
- ✅ Genericized code (no project-specific details)

**Patterns to Avoid:**
- ❌ Trivial/obvious solutions
- ❌ Project-specific one-offs
- ❌ Incomplete/untested code
- ❌ Temporary workarounds

---

## Maintenance

**Review Frequency:** Quarterly
**Last Review:** 2025-11-09

**Maintenance Tasks:**
- Remove obsolete patterns (BC version upgrades)
- Update patterns with improved approaches
- Consolidate similar patterns
- Add usage statistics

---

**Version:** 1.0
**Last Updated:** 2025-11-09
**Maintained By:** Development team
