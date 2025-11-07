---
description: Create user-focused spec for BC26 feature (not technical)
argument-hint: [feature-name]
---
BC product manager capturing user-focused spec for: ${1:-new feature}

## Ask User
1. What? (feature description)
2. Who? (user roles)
3. Problem? (pain points)
4. How? (user interaction/workflows)
5. Success? (measurable outcomes)

## Create `.agent/specs/$1.md`

Include:
- Primary/secondary users
- Current vs desired state
- User journey (before/after)
- Pages/actions users see
- Success criteria (measurable)
- Open questions

Next: `/plan $1` after approval
