---
description: Review current branch code changes and generate a review report for each commit
agent: build
---

# PR Review Command

## Behavior

This command review each commit from the current branch.

Follow these steps in order:

### Step 1: Verify Branch Status

- [ ] Ask: "Have you pulled latest changes from this branch? (yes/no)"
- [ ] If no: instruct to run `git pull` first and exit
- [ ] If yes: proceed

### Step 2: Gather Branch Context

- [ ] Run `git log main..HEAD --oneline` to get list of commits
- [ ] Display the list with: "These N commits will be reviewed:"
- [ ] Show each commit hash and title
- [ ] Ask: "Proceed with reviewing these commits? (yes/no)"
- [ ] If no: exit
- [ ] If yes: proceed

### Step 3: Gather Each Commit Context And Review

For each commit (oldest to newest):

- [ ] Check out the commit temporarily: `git checkout {hash}`
- [ ] Display: "**Reviewing commit {n}/{total}: {short-hash}**"
- [ ] Run `git diff-tree --no-commit-id --name-only -r HEAD` to get changed
      files
- [ ] Run `git show HEAD` to get the full diff of the commit
- [ ] For each file in the commit:
  - [ ] Analyze the changes looking for:
    - [ ] **Readability & Maintainability:** unclear variable/function
          names, overly complex logic, missing or misleading comments, poor
          code structure, violation of DRY principle, magic numbers/strings,
          inconsistent naming conventions
    - [ ] **Performance issues:** inefficient algorithms, unnecessary
          iterations, memory leaks, redundant computations, N+1 queries,
          blocking operations, missing memoization opportunities
    - [ ] **Typos:** spelling errors in variable names, function names,
          comments, string literals, error messages, documentation
    - [ ] **Trivial issues:** unused imports, dead code, debugging
          artifacts, console logs, commented-out code
    - [ ] **Code issues:** potential bugs, edge cases, error handling gaps
    - [ ] **Test inconsistencies:** missing tests for new functionality,
          tests that don't match implementation, broken test assertions
    - [ ] **Guideline violations:** any rules from AGENTS.md or CLAUDE.md
          that are not followed
  - [ ] Record findings with specific line numbers

### Step 4: Generate Review Report

For each reviewed commit: create a markdown file named
`pr-review-{index}-{short-hash}.md` in the current directory with this
structure:

```markdown
# PR Review: {commit-hash}

## Commit Information

**Message:** {commit message}
**Files Changed:** {number of files}

## Review Summary

| Category                      | Issues Found |
| ----------------------------- | ------------ |
| Readability & Maintainability | {count}      |
| Performance                   | {count}      |
| Typos                         | {count}      |
| Trivial Issues                | {count}      |
| Code Issues                   | {count}      |
| Test Inconsistencies          | {count}      |
| Guideline Violations          | {count}      |

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

### Step 5: Output Results

- [ ] Save the review file
- [ ] Display a summary of findings to the user
- [ ] Report the path to the generated review file
- [ ] Move to the next commit or exit when in the last commit

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

## Guidelines

Follow the guidelines in `AGENTS.md` or `CLAUDE.md` if they exists in the project.

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

Review comments must sound natural and human-written, as if they were written
entirely by the human developer, suitable for direct copy-paste into GitHub PR
reviews.

**Do:**

- Write conversationally: "This could be simplified by..." or
  "Consider renaming this to..."
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
