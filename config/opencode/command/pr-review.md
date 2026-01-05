---
description: Review current commit code changes and generate a review report
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Gather Context

- [ ] Run `git log -1 --format="%H %s"` to get the current commit hash and message
- [ ] Run `git diff-tree --no-commit-id --name-only -r HEAD` to get all changed files
- [ ] Run `git show HEAD` to get the full diff of the commit
- [ ] Check if `AGENTS.md` or `CLAUDE.md` exists in the repository root
- [ ] If either file exists, read it to extract project-specific rules and guidelines

### Step 2: Review Each Changed File

For each file in the commit:

1. Analyze the changes looking for:
   - [ ] **Readability & Maintainability:** unclear variable/function names, overly complex logic, missing or misleading comments, poor code structure, violation of DRY principle, magic numbers/strings, inconsistent naming conventions
   - [ ] **Performance issues:** inefficient algorithms, unnecessary iterations, memory leaks, redundant computations, N+1 queries, blocking operations, missing memoization opportunities
   - [ ] **Typos:** spelling errors in variable names, function names, comments, string literals, error messages, documentation
   - [ ] **Trivial issues:** unused imports, dead code, debugging artifacts, console logs, commented-out code
   - [ ] **Code issues:** potential bugs, edge cases, error handling gaps
   - [ ] **Test inconsistencies:** missing tests for new functionality, tests that don't match implementation, broken test assertions
   - [ ] **Guideline violations:** any rules from AGENTS.md or CLAUDE.md that are not followed
2. Record findings with specific line numbers

### Step 3: Generate Review Report

Create a markdown file named `{commit-hash}-pr-review.md` in the current directory with the following structure:

```markdown
# PR Review: {commit-hash}

## Commit Information

**Message:** {commit message}
**Files Changed:** {number of files}

## Review Summary

| Category | Issues Found |
|----------|--------------|
| Readability & Maintainability | {count} |
| Performance | {count} |
| Typos | {count} |
| Trivial Issues | {count} |
| Code Issues | {count} |
| Test Inconsistencies | {count} |
| Guideline Violations | {count} |

## Detailed Findings

### `{file-path}`

#### Readability & Maintainability
- Line {n}: {description of issue}
- Line {n}: {description of issue}

#### Performance
- Line {n}: {description of issue}

#### Typos
- Line {n}: `{typo}` should be `{correction}`

---

### `{next-file-path}`
...

## Recommendations

{Overall recommendations for improving the code quality}
```

### Step 4: Output Results

- [ ] Save the review file
- [ ] Display a summary of findings to the user
- [ ] Report the path to the generated review file

## Issue Categories

### Readability & Maintainability
- Unclear or misleading names
- Functions doing too many things
- Deep nesting or complex conditionals
- Missing error handling
- Duplicated code
- Inconsistent code style
- Missing or outdated comments
- Poor separation of concerns

### Performance
- O(n^2) or worse algorithms where better exists
- Unnecessary database queries or API calls
- Missing caching opportunities
- Synchronous operations that could be async
- Large memory allocations
- Inefficient string concatenation
- Redundant re-renders (React/frontend)

### Typos
- Misspelled variable/function/class names
- Typos in comments and documentation
- Spelling errors in user-facing strings
- Incorrect technical terms

### Trivial Issues
- Unused imports or variables
- Dead code or unreachable branches
- Debugging artifacts (console.log, debugger, print statements)
- Commented-out code blocks

### Code Issues
- Potential bugs or logic errors
- Unhandled edge cases
- Missing error handling
- Race conditions or async issues

### Test Inconsistencies
- Missing tests for new functionality
- Tests that don't match implementation
- Broken or incomplete test assertions
- Test coverage gaps for critical paths

## Key Requirements

- Use the short commit hash (7 characters) for the filename
- Be specific about line numbers and provide actionable feedback
- For each issue, explain WHY it's a problem and suggest a fix
- Skip categories that have no issues for a file
- If a file has no issues at all, include it with "No issues found"
- Prioritize impactful issues over minor nitpicks
- If no issues are found in any file, state "No issues found in this PR"
- NEVER modify any code - only generate the review report
- **Sort files alphabetically by path in the report**
- **Sort issues by line number (ascending) within each category**

## Writing Style

Review comments must sound natural and human-written, suitable for direct copy-paste into GitHub PR reviews.

**Do:**
- Write conversationally: "This could be simplified by..." or "Consider renaming this to..."
- Be direct but friendly: "Looks like there's a typo here" not "TYPO DETECTED"
- Explain the why briefly: "This might cause issues if the array is empty"
- Suggest fixes naturally: "Maybe extract this into a helper function?"

**Don't:**
- Use robotic language: "ISSUE:", "VIOLATION:", "ERROR:"
- Be overly formal: "It is recommended that the developer consider..."
- Use templates: "[TYPE] [SEVERITY] [DESCRIPTION]"
- Sound accusatory: "You failed to handle..." or "This is wrong"

**Examples:**

Good:
- "Looks like `reponse` should be `response`"
- "This loop runs on every render - might be worth wrapping in useMemo"
- "We're not handling the case where `user` is null here"
- "This duplicates the logic in `validateInput()` - could we reuse that?"

Bad:
- "[TYPO] Variable 'reponse' is misspelled. Should be 'response'."
- "[PERF] Inefficient: Loop executes on each render cycle without memoization."
- "[BUG] Null check missing for user object."
- "[DRY] Code duplication detected with validateInput function."
