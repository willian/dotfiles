# Commit Message Style Guide

## Structure

- Title: 50 characters max, imperative mood (e.g., "Add", "Fix", "Refactor")
- Body: Lines wrapped at 72 characters, explain what and why (not how)

## Content Structure

**Complex changes:**

1. Describe the problem or current state that motivated the change
2. Explain what was changed to solve it
3. State the benefits achieved
4. Mention testing coverage briefly if significant

**Simple changes:** State what changed in one sentence, then briefly explain why
in one sentence. Prefer brevity over completeness when the change is
self-explanatory.

## Writing Guidelines

- Use complete sentences with explicit subjects ("This commit adds..." not
  "Add...")
- Write in active voice with clear actors performing actions
- Prefer concise, direct explanations over detailed descriptions
- Ask "Is this detail necessary for understanding the change?" before including
  it
- Use backticks for technical terms and code values
- Clear description of benefits when they aren't obvious from the change

## Avoid

- Implementation details visible in the diff
- Line/test/file count mentions ("reduced from 34 to 3 lines")
- Subjective terms without value ("modernize", "enhanced", "comprehensive",
  "systematic")
- Repeating the same information across multiple paragraphs
- Over-explaining benefits that are obvious from the change itself
- References to previous commits unless directly relevant

Keep it professional, factual, and focused on meaningful changes.

## Example

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

## Hard Limits (NON-NEGOTIABLE)

- Title: **MUST** be ≤50 characters. Count characters if uncertain.
- Body: Lines **MUST** wrap at 72 characters. Break at natural word boundaries.

If a draft exceeds these limits, you MUST rewrite it before displaying. Never
show the user a message that violates these limits.

## Verification (REQUIRED)

Before finalizing any commit message:

1. **Count the title characters** - MUST be ≤50. If over, shorten by:

   - Removing articles (a, an, the) where grammatically acceptable
   - Using shorter synonyms (e.g., "Add" instead of "Implement")
   - Removing scope qualifiers if the change is obvious from context

2. **Check each body line wraps at 72 characters** - If over, rewrap the
   paragraph at natural word boundaries.

## Common Requirements

- NEVER update git config
- NEVER use interactive git commands (-i flag)
- Use HEREDOC format for commit messages to ensure proper formatting
- Write commit messages as if they were written entirely by the human developer
