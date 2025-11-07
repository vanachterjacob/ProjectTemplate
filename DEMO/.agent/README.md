# .agent/ Directory

This directory contains AI-generated documentation for the BC26 project.

## Structure

- **specs/** - User-focused feature specifications (created by `/specify`)
- **plans/** - Technical architecture plans (created by `/plan`)
- **tasks/** - Task breakdowns for implementation (created by `/tasks`)

## Usage

Documentation files are automatically created and updated by Claude Code slash commands:

1. `/specify [feature-name]` - Creates user-focused specification
2. `/plan [spec-name]` - Creates technical plan from specification
3. `/tasks [plan-name] [phase]` - Breaks plan into tasks
4. `/implement [task-file] [task-id|next]` - Implements tasks sequentially
5. `/update_doc [init|update]` - Maintains this documentation structure

## Git

This directory is tracked in git to share AI context across the team.
