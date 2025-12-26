---
description: Commit current changes
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Check Repository State

- [ ] Run `git status`, `git diff --cached`, `git diff`, and
      `git log --oneline -5` in parallel
- [ ] Review all changes and determine if this is a simple or complex change

### Step 2: Draft Commit Message

- [ ] Write title (50 chars max, imperative mood)
- [ ] **Verify title is ≤50 characters by counting** - if over, rewrite shorter
- [ ] Write body following style guidelines, wrapped at 72 characters
- [ ] **Verify each body line wraps at 72 characters** - rewrap if needed
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

Follow the guidelines in @/Users/willian/.config/opencode/command/shared/commit-message-style.md

## Key Requirements

- Only commit staged/modified files, never create empty commits
- If pre-commit hooks modify files, amend the commit to include them
- Do NOT push unless explicitly requested
- Never include any co-author trailers, AI attribution, or references to Claude
  Code in commit messages unless explicitly asked to do so
