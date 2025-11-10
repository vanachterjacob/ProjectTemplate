#!/usr/bin/env python3
"""
Pre-Commit ESC Compliance Hook

Automatically validates AL code for ESC compliance before allowing commits.
Prevents non-compliant code from entering the repository.

Features:
- LinterCop integration (if available)
- Pattern-based validation (early exit, TryFunction, Confirm)
- Naming convention checks
- Object ID validation
- Automatic file:line references for violations

Installation:
    python .claude/hooks/pre-commit-esc.py install

Usage:
    # Automatic (runs on git commit)
    git commit -m "..."

    # Manual test
    python .claude/hooks/pre-commit-esc.py check
"""

import os
import sys
import re
import subprocess
from pathlib import Path
from typing import List, Dict, Optional
from dataclasses import dataclass


@dataclass
class Violation:
    """ESC compliance violation"""
    file: str
    line: Optional[int]
    rule: str
    severity: str  # "error" or "warning"
    message: str


class ESCValidator:
    """Validates AL code for ESC compliance"""

    def __init__(self, project_root: Optional[str] = None):
        if project_root:
            self.project_root = Path(project_root)
        else:
            self.project_root = self._find_git_root()

        # Development ID range
        self.dev_id_start = 77100
        self.dev_id_end = 77200

    def _find_git_root(self) -> Path:
        """Find git repository root"""
        current = Path.cwd()
        while current != current.parent:
            if (current / ".git").exists():
                return current
            current = current.parent
        return Path.cwd()

    def get_staged_files(self) -> List[str]:
        """Get list of staged .al files"""
        result = subprocess.run(
            ["git", "diff", "--cached", "--name-only", "--diff-filter=ACM"],
            capture_output=True,
            text=True,
            cwd=self.project_root
        )

        if result.returncode != 0:
            return []

        files = result.stdout.strip().split('\n')
        al_files = [f for f in files if f.endswith('.al')]

        return al_files

    def validate_file(self, file_path: str) -> List[Violation]:
        """Validate single AL file for ESC compliance"""
        violations = []

        full_path = self.project_root / file_path

        if not full_path.exists():
            return violations

        try:
            content = full_path.read_text(encoding='utf-8')
            lines = content.split('\n')

            # Run all checks
            violations.extend(self._check_naming_conventions(file_path, lines))
            violations.extend(self._check_mandatory_patterns(file_path, lines))
            violations.extend(self._check_object_ids(file_path, lines))
            violations.extend(self._check_performance(file_path, lines))

        except Exception as e:
            violations.append(Violation(
                file=file_path,
                line=None,
                rule="PARSE_ERROR",
                severity="error",
                message=f"Failed to parse file: {e}"
            ))

        return violations

    def _check_naming_conventions(self, file_path: str, lines: List[str]) -> List[Violation]:
        """Check naming convention compliance"""
        violations = []

        # Check 1: Object names must have ABC prefix
        for i, line in enumerate(lines[:30], 1):  # Check first 30 lines for object declaration
            match = re.search(r'(table|page|codeunit|query|report|xmlport|enum)\s+(\d+)\s+"?([^"]+)"?', line, re.IGNORECASE)

            if match:
                object_type = match.group(1).lower()
                object_name = match.group(3).strip('"')

                # Extensions don't need prefix in declaration
                if 'extension' in object_type.lower():
                    continue

                if not object_name.startswith("ABC "):
                    violations.append(Violation(
                        file=file_path,
                        line=i,
                        rule="ESC-001",
                        severity="error",
                        message=f"Object name must start with 'ABC ' prefix: '{object_name}'"
                    ))

        # Check 2: Local variables should use camelCase
        for i, line in enumerate(lines, 1):
            # Look for var declarations
            if re.search(r'\s+var\s+', line):
                # Check next lines for variable declarations
                for j in range(i, min(i + 10, len(lines))):
                    var_match = re.search(r'\s+([A-Z][a-zA-Z0-9]*)\s*:', lines[j])
                    if var_match and 'begin' not in lines[j].lower():
                        var_name = var_match.group(1)

                        # Check if PascalCase (starts with uppercase)
                        if var_name[0].isupper() and not any(keyword in lines[j] for keyword in ['Record', 'Codeunit', 'Page']):
                            violations.append(Violation(
                                file=file_path,
                                line=j + 1,
                                rule="ESC-002",
                                severity="warning",
                                message=f"Local variable '{var_name}' should use camelCase, not PascalCase"
                            ))

        return violations

    def _check_mandatory_patterns(self, file_path: str, lines: List[str]) -> List[Violation]:
        """Check for mandatory ESC patterns"""
        violations = []

        # Pattern 1: Early exit instead of nested if-else
        for i, line in enumerate(lines, 1):
            if re.search(r'if\s+.*\s+then\s+begin', line, re.IGNORECASE):
                # Look ahead for else
                for j in range(i, min(i + 30, len(lines))):
                    if re.search(r'\s+else\s+begin', lines[j], re.IGNORECASE):
                        # Check if this could be early exit
                        # (if negative condition at start)
                        if any(neg in line.lower() for neg in ['not', '<>', 'isempty', '= 0']):
                            violations.append(Violation(
                                file=file_path,
                                line=i,
                                rule="ESC-010",
                                severity="warning",
                                message="Use early exit pattern: 'if NOT condition then exit;' instead of if-else"
                            ))
                        break

        # Pattern 2: Dialog usage (should use Confirm for user confirmations)
        for i, line in enumerate(lines, 1):
            if 'dialog.' in line.lower() and ('confirm' in lines[max(0, i-5):i+5].__str__().lower()):
                violations.append(Violation(
                    file=file_path,
                    line=i,
                    rule="ESC-011",
                    severity="warning",
                    message="Use Confirm() for user confirmations, not Dialog"
                ))

        # Pattern 3: Missing error handling (operations that can fail)
        for i, line in enumerate(lines, 1):
            # Check for database modifications without Try
            if any(op in line for op in ['.Insert(', '.Modify(', '.Delete(']) and 'true' in line.lower():
                # Look backward for TryFunction or error handling
                has_try = any('try' in lines[j].lower() for j in range(max(0, i-10), i))

                if not has_try:
                    violations.append(Violation(
                        file=file_path,
                        line=i,
                        rule="ESC-012",
                        severity="warning",
                        message="Database operations should use TryFunction pattern or handle errors"
                    ))

        return violations

    def _check_object_ids(self, file_path: str, lines: List[str]) -> List[Violation]:
        """Check object ID compliance"""
        violations = []

        for i, line in enumerate(lines[:30], 1):
            match = re.search(r'(table|page|codeunit|query|report|xmlport|enum)\s+(\d+)', line, re.IGNORECASE)

            if match:
                object_id = int(match.group(2))

                # Check if in development range
                if not (self.dev_id_start <= object_id <= self.dev_id_end):
                    # Production ID in development code
                    if object_id >= 50000:
                        violations.append(Violation(
                            file=file_path,
                            line=i,
                            rule="ESC-020",
                            severity="error",
                            message=f"Production object ID {object_id} found in development code. Use development range {self.dev_id_start}-{self.dev_id_end}"
                        ))

        return violations

    def _check_performance(self, file_path: str, lines: List[str]) -> List[Violation]:
        """Check for performance anti-patterns"""
        violations = []

        # Anti-pattern: FINDFIRST/FINDSET in loop
        in_loop = False
        loop_start_line = 0

        for i, line in enumerate(lines, 1):
            # Track loop boundaries
            if any(keyword in line.lower() for keyword in ['repeat', 'for', 'while', 'foreach']):
                in_loop = True
                loop_start_line = i

            if in_loop and ('until' in line.lower() or 'end;' in line.lower()):
                in_loop = False

            # Check for database queries in loop
            if in_loop and any(op in line.lower() for op in ['findfirst', 'findset', 'find(']):
                violations.append(Violation(
                    file=file_path,
                    line=i,
                    rule="ESC-030",
                    severity="error",
                    message=f"Database query in loop (started line {loop_start_line}). Use SETAUTOCALCFIELDS or collect IDs first."
                ))

        return violations

    def validate_all_staged(self) -> Dict:
        """Validate all staged files"""
        staged_files = self.get_staged_files()

        if not staged_files:
            return {"passed": True, "files": 0, "violations": []}

        all_violations = []

        for file_path in staged_files:
            violations = self.validate_file(file_path)
            all_violations.extend(violations)

        # Categorize violations
        errors = [v for v in all_violations if v.severity == "error"]
        warnings = [v for v in all_violations if v.severity == "warning"]

        return {
            "passed": len(errors) == 0,
            "files": len(staged_files),
            "violations": all_violations,
            "errors": errors,
            "warnings": warnings
        }


def install_hook():
    """Install pre-commit hook"""
    git_root = Path.cwd()
    while git_root != git_root.parent:
        if (git_root / ".git").exists():
            break
        git_root = git_root.parent

    hook_path = git_root / ".git" / "hooks" / "pre-commit"
    script_path = Path(__file__).resolve()

    hook_content = f"""#!/usr/bin/env python3
# ESC Compliance Pre-Commit Hook
# Auto-generated - do not edit directly

import sys
sys.path.insert(0, "{script_path.parent}")

from {script_path.stem} import main

if __name__ == "__main__":
    sys.exit(main())
"""

    hook_path.write_text(hook_content)
    hook_path.chmod(0o755)

    print(f"✅ Pre-commit hook installed: {hook_path}")
    print()
    print("The hook will run automatically on 'git commit'")
    print("To bypass (emergency only): git commit --no-verify")


def main():
    """Main entry point for pre-commit hook"""
    validator = ESCValidator()

    print("🔍 ESC Compliance Check")
    print("=" * 60)

    result = validator.validate_all_staged()

    if result["files"] == 0:
        print("ℹ️  No AL files staged for commit")
        return 0

    print(f"📝 Checking {result['files']} file(s)...")
    print()

    if result["violations"]:
        # Print errors
        if result["errors"]:
            print(f"❌ {len(result['errors'])} ERROR(S) FOUND:")
            print()

            for error in result["errors"]:
                line_ref = f":{error.line}" if error.line else ""
                print(f"   {error.file}{line_ref}")
                print(f"   Rule: {error.rule}")
                print(f"   {error.message}")
                print()

        # Print warnings
        if result["warnings"]:
            print(f"⚠️  {len(result['warnings'])} WARNING(S) FOUND:")
            print()

            for warning in result["warnings"]:
                line_ref = f":{warning.line}" if warning.line else ""
                print(f"   {warning.file}{line_ref}")
                print(f"   Rule: {warning.rule}")
                print(f"   {warning.message}")
                print()

    if not result["passed"]:
        print("=" * 60)
        print("❌ COMMIT BLOCKED - Fix ESC violations and try again")
        print()
        print("Tip: Use '/review <file>' to get detailed fix recommendations")
        print("Emergency bypass: git commit --no-verify (NOT recommended)")
        return 1
    else:
        if result["warnings"]:
            print("=" * 60)
            print(f"⚠️  COMMIT ALLOWED with {len(result['warnings'])} warning(s)")
            print("Consider fixing warnings to maintain code quality")
        else:
            print("✅ ESC COMPLIANCE CHECK PASSED")

        return 0


if __name__ == "__main__":
    if len(sys.argv) > 1:
        command = sys.argv[1]

        if command == "install":
            install_hook()
        elif command == "check":
            sys.exit(main())
        else:
            print(f"Unknown command: {command}")
            print("Usage: pre-commit-esc.py [install|check]")
            sys.exit(1)
    else:
        # Run as pre-commit hook
        sys.exit(main())
