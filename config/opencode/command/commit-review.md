---
description: Review and propose rewrite for current commit message
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Read Current Commit Information

- [ ] Run `git log -1 --format="%H%n%s%n%b"` to get the commit hash, title, and body
- [ ] Run `git diff-tree --no-commit-id --name-status -r HEAD` to get all files changed, added, or deleted
- [ ] Run `git show --stat HEAD` to get a summary of changes
- [ ] Run `git show HEAD` to read the full diff of the commit

### Step 2: Analyze the Commit

- [ ] Review the current commit title and description
- [ ] Analyze all file changes to understand what was done and why
- [ ] Identify if this is a simple or complex change

### Step 3: Draft Improved Commit Message

- [ ] Write title (50 chars max, imperative mood)
- [ ] Verify title is exactly 50 characters or less (count characters if unsure)
- [ ] If title exceeds 50 characters, rewrite it shorter - prioritize brevity over completeness
- [ ] Write body following style guidelines below
- [ ] Display with "**First pass:**" label

### Step 4: Simplify Message

- [ ] Remove redundant/unnecessary details
- [ ] Check for repeated information across paragraphs
- [ ] Display simplified version with "**Second pass (simplified):**" label

### Step 5: Save Review to File

- [ ] Extract the commit hash (short form, 7 characters)
- [ ] Create a markdown file named `{commit-hash}-reviewed.md` in the current directory
- [ ] Include in the file:
  - Original commit title and description
  - List of files changed (added/modified/deleted)
  - Proposed new title and description
  - Brief explanation of why the changes were suggested

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

## Output File Format

The review file should follow this structure:

```markdown
# Commit Review: {commit-hash}

## Original Commit Message

**Title:** {original title}

**Description:**
{original description or "No description provided"}

## Files Changed

- `A` {file path} (added)
- `M` {file path} (modified)
- `D` {file path} (deleted)

## Proposed Commit Message

**Title:** {proposed title}

**Description:**
{proposed description}

## Review Notes

{Brief explanation of why the changes were suggested, what was improved}
```

## Key Requirements

- NEVER update git config
- NEVER use interactive git commands (-i flag)
- NEVER modify the actual commit - only create the review file
- Use HEREDOC format for commit messages to ensure proper formatting
- Always use the short commit hash (7 characters) for the filename
- Include all changed files in the review
- If the original commit message is already well-written, acknowledge this in the review notes
- Write commit messages as if they were written entirely by the human developer
- Title MUST be 50 characters or fewer - if a draft title exceeds this, shorten it by:
  1. Removing articles (a, an, the) where grammatically acceptable
  2. Using shorter synonyms (e.g., "Add" instead of "Implement")
  3. Removing scope qualifiers if the change is obvious from context
