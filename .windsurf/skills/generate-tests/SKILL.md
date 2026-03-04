---
name: generate-tests
description: Identify untested code and generate test files by analyzing coverage reports and following project testing conventions
---

# Generate Tests Skill

Use this skill when the user asks to add tests, improve coverage, find untested code, or generate test files.

## Steps

### 1. Detect the testing setup

Identify the project's test framework and conventions by reading config files:
- `package.json` — look for `jest`, `mocha`, `vitest`, `ava` in dependencies or scripts
- `pytest.ini`, `setup.cfg`, `pyproject.toml` — Python test config
- Test directories — `__tests__/`, `tests/`, `test/`, `spec/`

Read [test-patterns.md](test-patterns.md) for guidance on adapting to different project conventions.

### 2. Run the coverage analysis script

```bash
bash .windsurf/skills/generate-tests/find-untested.sh
```

This script runs the existing test suite with coverage enabled and outputs:
- Overall coverage percentages
- List of files with low coverage
- Specific uncovered line ranges

### 3. Prioritize what to test

Focus on files that are:
1. **Critical path** — entry points, API routes, core business logic
2. **Low coverage** — files below the project's coverage threshold
3. **Recently changed** — files modified in recent commits (more likely to have new untested code)

Ask the user if they want to focus on a specific file or area, or if they want a broad sweep.

### 4. Read source files and existing tests

For each file to be tested:
- Read the **source file** to understand exports, functions, and logic
- Read any **existing test file** to understand current coverage and avoid duplication
- Note edge cases: error paths, boundary values, null/empty inputs, async behavior

### 5. Generate test files

Write tests following these principles:
- **Match the project's test style** — use the same assertion library, mocking patterns, and naming conventions already in use
- **One test file per source file** — follow the project's naming convention (e.g., `foo.test.js`, `test_foo.py`)
- **Cover the happy path first**, then edge cases and error paths
- **Use descriptive test names** — `it('returns empty array when no items match filter')` not `it('test 1')`
- **Mock external dependencies** — don't test third-party libraries, databases, or network calls directly
- **Keep tests independent** — no shared mutable state between tests

### 6. Verify the new tests

Run the test suite to confirm the new tests pass:
```bash
# JavaScript
npm test

# Python
python3 -m pytest
```

Then re-run coverage to show improvement:
```bash
bash .windsurf/skills/generate-tests/find-untested.sh
```

Present a before/after coverage comparison to the user.
