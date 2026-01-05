---
description: Review branch code changes
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Gather Context

- [ ] Run `git log main..HEAD --oneline --reverse` to get commits from oldest to newest
- [ ] Run `git diff main..HEAD` to understand the full scope of changes in the PR
- [ ] Check if `AGENTS.md` or `CLAUDE.md` exists in the repository root
- [ ] If either file exists, read it to extract project-specific rules and guidelines

### Step 2: Review Each Commit (Oldest to Newest)

Process commits sequentially, starting from the oldest:

For each commit:

1. Run `git show <commit-hash> --stat` to see files changed
2. Run `git show <commit-hash>` to get the full diff
3. Review the changes looking for:
   - [ ] **Trivial issues:** unused imports, dead code, debugging artifacts, console logs, commented-out code
   - [ ] **Test inconsistencies:** missing tests for new functionality, tests that don't match implementation, broken test assertions
   - [ ] **Code issues:** potential bugs, edge cases, error handling gaps, performance concerns
   - [ ] **Typos and grammar:** in commit title, commit description, code comments, variable names, function names, component names, string literals, error messages
   - [ ] **Guideline violations:** any rules from AGENTS.md or CLAUDE.md that are not followed
4. Record findings for this commit before moving to the next

### Step 3: Output Results

Present findings organized by commit (oldest to newest), then by file:

```
## PR Review Results

### `abc1234` - Oldest commit message
- `path/to/file.ts`
  - Line 42: [issue type] Description of the issue
  - Line 87: [issue type] Description of the issue
- `path/to/other.ts`
  - Line 15: [issue type] Description of the issue

### `def5678` - Next commit message
- `src/component.tsx`
  - Line 23: [issue type] Description of the issue

### `ghi9012` - Most recent commit message
No issues found.
```

## Issue Type Labels

Use these labels to categorize findings:

- `[trivial]` - Minor issues like unused code, debug artifacts
- `[test]` - Test-related inconsistencies or gaps
- `[bug]` - Potential bugs or logic errors
- `[typo]` - Spelling or grammar errors
- `[style]` - Code style or formatting issues
- `[perf]` - Performance concerns
- `[guideline]` - Violations of AGENTS.md or CLAUDE.md rules

## Key Requirements

- Review commits one at a time, in chronological order (oldest first)
- If AGENTS.md or CLAUDE.md exists, enforce those rules during review
- Focus on actionable feedback, not stylistic preferences
- Skip files that have no issues within a commit
- Always list each commit in the output, even if no issues are found (state "No issues found")
- Be specific about line numbers and what the issue is
- Prioritize bugs, guideline violations, and test issues over trivial findings
- If no issues are found in any commit, state "No issues found in this PR"
