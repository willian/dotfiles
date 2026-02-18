---
description: Commit current changes
agent: build
---

## Behavior

This command creates a new commit from staged/modified files. For reviewing an
existing commit, use the `commit-review` command instead.

Follow these steps in order:

### Step 1: Gather Changes

- [ ] Run `git status`, `git diff --cached`, `git diff`, and
      `git log --oneline -5` in parallel
- [ ] Review all changes thoroughly to understand what was done and why

### Step 2: Draft Commit Message

Follow the three-pass writing process from the style guide:

- [ ] **Pass 1 (Draft)**: Identify commit type, write title and body
  - Display with "**First pass:**" label
- [ ] **Pass 2 (Simplify)**: Remove redundancy and repeated information
  - Display with "**Second pass (simplified):**" label
- [ ] **Pass 3 (Review and Refine)**: Check for quality issues per style guide
  - If issues found, display with "**Final (refined):**" label

### Step 3: Get Confirmation and Commit

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
