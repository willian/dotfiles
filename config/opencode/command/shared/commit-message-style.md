# Commit Message Style Guide

## Structure

- Title: 50 characters max
- Body: Explain what and why (not how)

## Core Principle

Every commit message must make sense to someone reading it in isolation, with
enough context about where, what, and why. A reader should understand the change
without needing to look at the diff or other commits.

## Title Guidelines

- Use imperative mood ("Add feature" not "Added feature" or "Adds feature")
- The title should give the reader the most useful information within 50
  characters
- Choose between describing the change or the problem based on clarity:
  - If the change itself is clear and makes the problem/solution obvious,
    describe the change
    - "Make file extension validation case-insensitive"
  - If the change is complex or non-obvious, describe what was fixed instead
    - "Fix memory leak in WebSocket connection handler"
  - Note: Even for bug fixes, prefer describing the change if it's clearer than
    using "Fix"
- Clarify frontend vs backend when there's potential for confusion
  - Ambiguous: "Add user preferences validation"
  - Clear: "Add frontend validation for user preferences"
  - Not needed: "Add React component for user profile" (obviously frontend)
  - Not needed: "Add API endpoint for user preferences" (obviously backend)

## Determining Commit Type

Before writing the commit message, identify the primary purpose:

- **Bug fix** - Fixes incorrect behavior
- **Feature** - Adds new functionality
- **Enhancement** - Improves existing functionality
- **Refactor** - Restructures code without changing behavior
- **Performance** - Improves speed or resource usage
- **Test** - Adds or modifies tests
- **Documentation** - Updates docs, comments, or README
- **Dependency** - Adds, updates, or removes dependencies
- **Configuration** - Changes to build, CI/CD, or tooling
- **Cleanup** - Removes dead code or deprecated features

**Required:** When writing a commit message, explicitly state the commit type
you've identified before drafting the message.

## Content Structure

The commit type determines the appropriate structure for your body:

**Note:** For simple, self-explanatory changes of any type, a brief explanation
of what changed and why is sufficient instead of following the full structure
below.

**Bug fixes:**

1. Describe the situation before and the impact of the bug
2. Explain why it happened (root cause)
3. Describe how the fix addresses it

**Features:**

1. State what was added
2. Explain why it was needed (the problem or motivation)
3. If multiple features/capabilities, use bullet points

**Enhancements:**

1. Describe the improvement and its benefit

**Refactors:**

1. Explain the motivation
2. Describe the approach taken

**Performance:**

1. State the problem
2. Describe the improvement

**Documentation:**

1. Explain what was unclear or missing
2. Describe what's now clarified

**Dependencies:**

1. State what dependency changed (added/updated/removed)
2. Explain why (new feature need, security patch, deprecation, etc.)

**Configuration:**

1. Describe what's being configured
2. Explain the purpose or problem it solves

**Cleanup:**

1. Describe what's being removed
2. Explain why it's no longer needed

**Tests:**

1. Describe what's being tested
2. If adding missing tests, briefly explain why they're important

## Bullet Points vs Prose

- **Use bullet points** when listing multiple features, changes, or items that
  are parallel in nature
- **Use prose paragraphs** when describing a narrative (problem, solution,
  benefit) or explaining causation
- When using bullets, ensure the intro text combined with each bullet forms a
  grammatically correct sentence

## Writing Process

Follow this multi-pass approach to craft quality commit messages:

### Pass 1: Draft

1. Identify the commit type (see above)
2. Write the title (50 chars max, verify by counting)
3. Write the body following the appropriate content structure for the commit
   type

### Pass 2: Simplify

1. Remove redundant or unnecessary details
2. Check for repeated information across paragraphs
3. Ask: "Is each detail necessary for understanding?"

### Pass 3: Review and Refine

Check for common quality issues:

- **Grammar**: Every sentence must be grammatically complete with a subject and
  verb. Sentence fragments are not acceptable. Use proper subject-verb
  agreement, punctuation, and sentence structure.
- **Sentence complexity**: Check if any sentence expresses more than two ideas.
  If a sentence has multiple subordinate clauses (using "when", "because",
  "while", "causing", "resulting in"), it likely expresses too many ideas and
  should be split into separate sentences for clarity.
- **Run-on sentences**: Check for multiple independent clauses joined by commas.
  These should be split into separate sentences.
- **Active voice**: Write in active voice with clear actors performing actions.
  In bullet points, describe what code/components DO (present tense), not what
  was added/created (past tense).
- **Unclear references**: The first mention of any subject should be specific
  enough to identify it without surrounding context (e.g., "the system tests for
  resume parsing" not "the system tests"). After establishing the subject,
  pronouns and generic terms are fine.
- **Unnecessary "This commit"**: Avoid "This commit" when you can start with the
  subject being changed ("The hook...", "The guide..."). Use "This commit" only
  when needed for clarity, such as when establishing what's being added before
  you can refer to it, or when the alternative creates awkward phrasing or
  run-on sentences.
- **Vague or subjective language**: Avoid subjective terms without concrete
  benefits ("improve", "better", "comprehensive", "enhance", "modernize") and
  vague verbs ("adjust", "update" when more specific terms apply)
- **Concise explanations**: Prefer concise, direct explanations over detailed
  descriptions.
- **Backticks for technical terms**: Use backticks around component names,
  function names, class names, file names, variable names, and other code
  identifiers (e.g., `UserProfile` component, `validateInput` function,
  `constants.ts` file)
- **Implementation details**: Don't narrate code mechanics visible in the diff
  (e.g., chains of method calls). Name a specific method or class only when it's
  the subject, not a step in a walkthrough.
- **Repetition**: Check for repeated information across paragraphs
- **Over-explanation**: Don't over-explain benefits that are obvious from the
  change itself
- **Forward references**: Don't reference other commits unless directly relevant
- **Title clarity**: Title should focus on "what/why" rather than "how"
- **Isolation context**: Would someone understand this without viewing the diff?

If issues are found, refine the message to address them.

## Examples

### Bug Fix (narrative structure)

```
Fix memory leak in WebSocket connection handler

The application was leaking memory when WebSocket connections closed
unexpectedly. Event listeners were registered on connection open but
never removed on connection close, causing references to accumulate.

This commit removes event listeners in the cleanup function and adds
a guard to prevent duplicate listener registration.
```

### Feature (with bullet points)

```
Add dark mode support to dashboard

Users requested a dark mode option to reduce eye strain during
evening work sessions. This commit adds a theme toggle that:
- Switches between light and dark color schemes
- Persists user preference in localStorage
- Applies appropriate styles to all dashboard components
- Includes smooth transition animations between themes
```

### Simple Change (Dependency)

```
Update Node.js version requirement to 18+

Node 16 reaches end-of-life next month. This updates our minimum
version requirement to ensure security patches remain available.
```

### Enhancement

```
Add keyboard shortcuts for dashboard navigation

Users frequently navigate between dashboard sections using the
mouse, which slows down their workflow. This commit adds keyboard
shortcuts (Cmd+1 through Cmd+5) for quick navigation to each
section, improving efficiency for power users.
```

### What Not to Do

```
Improve file upload system with better validation

The upload system had various issues that needed fixing, so this
commit comprehensively enhances the validation logic by implementing
case-insensitive MIME type checking, which modernizes the codebase
and improves user experience since files with uppercase extensions
were being rejected before.
```

_Issues: Subjective terms ("improve", "better", "comprehensively", "enhances",
"modernizes"), run-on sentence, vague about what actually changed, over-explains
obvious benefits._

**Better version:**

```
Make file extension validation case-insensitive

The file upload was rejecting valid PDFs when the file extension
was uppercase. The MIME type check was case-sensitive, causing
validation to fail for files like "document.PDF". This commit makes
the extension check case-insensitive.
```

## Hard Limits (NON-NEGOTIABLE)

- Title: **MUST** be ≤50 characters. Count characters if uncertain.

If the title exceeds this limit, you MUST rewrite it before displaying. Never
show the user a message that violates this limit.

## Verification (REQUIRED)

Before finalizing any commit message:

1. **Count the title characters** - MUST be ≤50. If over, shorten by:
   - Removing articles (a, an, the) where grammatically acceptable
   - Using shorter synonyms (e.g., "Add" instead of "Implement")
   - Removing scope qualifiers if the change is obvious from context

## Common Requirements

- NEVER update git config
- NEVER use interactive git commands (-i flag)
- Use HEREDOC format for commit messages to ensure proper formatting
- Write commit messages as if they were written entirely by the human developer
- NEVER add `Co-Authored-By: Claude` or any AI attribution - commit messages
  must have no mention of AI assistance whatsoever
