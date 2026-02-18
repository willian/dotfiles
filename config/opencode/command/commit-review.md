---
description: Review and propose rewrite for current commit message
agent: build
---

## Behavior

This command reviews an existing commit and writes a review file. For creating a
new commit from staged changes, use the `commit` command instead.

Follow these steps in order:

### Step 1: Read Current Commit Information

- [ ] Run `git log -1 --format="%H%n%s%n%b"` to get the commit hash, title, and
      body
- [ ] Run `git diff-tree --no-commit-id --name-status -r HEAD` to get all files
      changed, added, or deleted
- [ ] Run `git show --stat HEAD` to get a summary of changes
- [ ] Run `git show HEAD` to read the full diff of the commit

### Step 2: Analyze the Commit

- [ ] Review the current commit title and description
- [ ] Analyze all file changes thoroughly to understand what was done and why

### Step 3: Draft Improved Commit Message

Follow the three-pass writing process from the style guide:

- [ ] **Pass 1 (Draft)**: Identify commit type, write title and body
  - Display with "**First pass:**" label
- [ ] **Pass 2 (Simplify)**: Remove redundancy and repeated information
  - Display with "**Second pass (simplified):**" label
- [ ] **Pass 3 (Review and Refine)**: Check for quality issues per style guide
  - Use the refined version for the proposed commit message

### Step 4: Save Review to File

- [ ] Extract the commit hash (short form, 7 characters)
- [ ] Create a markdown file named `{commit-hash}-reviewed.md` in the current
      directory
- [ ] Include in the file:
  - Original commit title and description
  - List of files changed (added/modified/deleted)
  - Proposed new title and description
  - Brief explanation of why the changes were suggested

## Commit Message Style

Follow the guidelines in @/Users/willian/.config/opencode/command/shared/commit-message-style.md

## Output File Format

The review file should follow this structure:

```markdown
# Commit Review: {commit-hash}

## Original Commit Message

**Title:** {original title}

**Description:** {original description or "No description provided"}

## Files Changed

- `A` {file path} (added)
- `M` {file path} (modified)
- `D` {file path} (deleted)

## Proposed Commit Message

**Title:** {proposed title}

**Description:** {proposed description}

## Review Notes

{Brief explanation of why the changes were suggested, what was improved}
```

## Key Requirements

- NEVER modify the actual commit - only create the review file
- Always use the short commit hash (7 characters) for the filename
- Include all changed files in the review
- If the original commit message is already well-written, acknowledge this in
  the review notes
