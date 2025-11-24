---
description: Commit current changes
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Check Repository State

- [ ] Run `git status`, `git diff --cached`, `git diff`, and `git log --oneline -5` in parallel
- [ ] Review all changes and determine if this is a simple or complex change

### Step 2: Draft Commit Message

- [ ] Write title (50 chars max, imperative mood)
- [ ] Write body following style guidelines below
- [ ] Display with "**First pass:**" label

### Step 3: Simplify Message

- [ ] Remove redundant/unnecessary details
- [ ] Check for repeated information across paragraphs
- [ ] Display simplified version with "**Second pass (simplified):**" label

### Step 4: Get Confirmation and Commit

- [ ] Ask: "Proceed with this commit message?"
- [ ] If confirmed: stage files with `git add` and commit using HEREDOC format
- [ ] Run `git status` to verify success

## Commit Message Style

**Structure:**

- Title: 50 characters max, imperative mood (e.g., "Add", "Fix", "Refactor")
- Body: Lines wrapped at 72 characters, explain what and why (not how)

**Content Structure:**

**Complex changes:**

1. Describe the problem or current state that motivated the change
2. Explain what was changed to solve it
3. State the benefits achieved
4. Mention testing coverage briefly if significant

**Simple changes:** State what changed in one sentence, then briefly explain why in one sentence. Prefer brevity over completeness when the change is self-explanatory.

**Writing Guidelines:**

- Use complete sentences with explicit subjects ("This commit adds..." not "Add...")
- Write in active voice with clear actors performing actions
- Prefer concise, direct explanations over detailed descriptions
- Ask "Is this detail necessary for understanding the change?" before including it
- Use backticks for technical terms and code values
- Clear description of benefits when they aren't obvious from the change

**Avoid:**

- Implementation details visible in the diff
- Line/test/file count mentions ("reduced from 34 to 3 lines")
- Subjective terms without value ("modernize", "enhanced", "comprehensive", "systematic")
- Repeating the same information across multiple paragraphs
- Over-explaining benefits that are obvious from the change itself
- References to previous commits unless directly relevant

Keep it professional, factual, and focused on meaningful changes.

**Example:**

Good:

```
Limit file size for image uploads

Large image uploads were failing because of server timeouts. This
commit adds validation to reject files over 5MB and displays an
error message to users when uploads fail.
```

Bad:

```
Improve file upload functionality with enhanced validation

The existing file upload system had issues with large files causing
failures. This commit implements comprehensive validation that checks
file size limits, adds error handling for oversized files, creates
user-friendly error messages, and improves the overall upload
experience by providing better feedback to users.
```

## Key Requirements

- NEVER update git config
- NEVER use interactive git commands (-i flag)
- Use HEREDOC format for commit messages to ensure proper formatting
- Only commit staged/modified files, never create empty commits
- If pre-commit hooks modify files, amend the commit to include them
- Do NOT push unless explicitly requested
- Never include any co-author trailers, AI attribution, or references to Claude Code (or any other model) in commit messages unless explicitly asked to do so
- Write commit messages as if they were written entirely by the human developer
