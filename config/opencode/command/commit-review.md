---
description: Review and propose rewrite for current commit message
agent: build
---

## Behavior

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
- [ ] Analyze all file changes to understand what was done and why
- [ ] Identify if this is a simple or complex change

### Step 3: Draft Improved Commit Message

- [ ] Write title (50 chars max, imperative mood)
- [ ] **Verify title is ≤50 characters by counting** - if over, rewrite shorter
- [ ] Write body following style guidelines, wrapped at 72 characters
- [ ] **Verify each body line wraps at 72 characters** - rewrap if needed
- [ ] Display with "**First pass:**" label

### Step 4: Simplify Message

- [ ] Remove redundant/unnecessary details
- [ ] Check for repeated information across paragraphs
- [ ] Display simplified version with "**Second pass (simplified):**" label

### Step 5: Save Review to File

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
