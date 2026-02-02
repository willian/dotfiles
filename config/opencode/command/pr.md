---
description: Generate PR title and description
agent: build
---

## Behavior

Follow these steps in order:

### Step 1: Gather Branch Context

- [ ] Run the following commands in parallel:
  - `git branch --show-current` to get current branch name
  - `git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d: -f2 | tr -d ' '` to detect default branch
- [ ] If default branch detection fails, try `main`, then `master`, then `develop`
- [ ] Run the following commands in parallel (using detected base branch):
  - `git log <base>..HEAD --oneline` to see all commits on this branch
  - `git diff <base>...HEAD --stat` for file change summary
  - `git diff <base>...HEAD` to see full diff
- [ ] Check if `AGENTS.md` or `CLAUDE.md` exists and read for project-specific guidelines

### Step 2: Analyze Changes

- [ ] Review all commits to understand the scope and purpose of the PR
- [ ] Analyze the full diff to understand what changed
- [ ] Determine if this is a simple or complex PR:
  - **Simple:** Single concern, few files, straightforward change
  - **Complex:** Multiple concerns, many files, or significant refactoring
- [ ] Identify the core problem being solved and benefits achieved

### Step 3: Draft PR Title and Description

- [ ] Write title (50 chars max, imperative mood)
- [ ] **Verify title is ≤50 characters by counting** - if over, rewrite shorter
- [ ] Write description following the content structure below
- [ ] Display with "**First pass:**" label

### Step 4: Simplify

- [ ] Remove redundant/unnecessary details
- [ ] Check for repeated information across paragraphs
- [ ] Display simplified version with "**Second pass (simplified):**" label

### Step 5: Output for User

- [ ] Display the final PR title and description in a clean, copy-paste ready format
- [ ] Display the `gh pr create` command with the title and description using HEREDOC format
- [ ] Ask: "Would you like me to create this PR now?"
- [ ] If confirmed: execute the `gh pr create` command and report the PR URL

## PR Title Style

Same as commit message titles:

- **50 characters max** (hard limit)
- Imperative mood (e.g., "Add", "Fix", "Refactor")
- No period at the end
- Capitalize the first letter

## PR Description Style

**Complex PRs:**

1. Describe the problem or current state that motivated the change
2. Explain what was changed to solve it
3. State the benefits achieved
4. Mention testing coverage briefly if significant

**Simple PRs:** State what changed in one sentence, then briefly explain why in
one sentence. Prefer brevity over completeness when the change is
self-explanatory.

## Writing Guidelines

- Use complete sentences with explicit subjects
- Write in active voice with clear actors performing actions
- Prefer concise, direct explanations over detailed descriptions
- Ask "Is this detail necessary for understanding the PR?" before including it
- Use backticks for technical terms and code values
- Use markdown formatting where it improves readability (lists, code blocks)

## Avoid

- Implementation details visible in the diff
- Line/test/file count mentions ("reduced from 34 to 3 lines")
- Subjective terms without value ("modernize", "enhanced", "comprehensive",
  "systematic")
- Repeating the same information across multiple paragraphs
- Over-explaining benefits that are obvious from the change itself
- References to commits unless directly relevant
- AI attribution, co-author trailers, or references to Claude Code

## Verification (REQUIRED)

Before finalizing any PR title:

1. **Count the title characters** - MUST be ≤50. If over, shorten by:
   - Removing articles (a, an, the) where grammatically acceptable
   - Using shorter synonyms (e.g., "Add" instead of "Implement")
   - Removing scope qualifiers if the change is obvious from context

## Output Format

Display the final output as:

```
## PR Title

{title}

## PR Description

{description}

## Command

gh pr create --title "{title}" --body "$(cat <<'EOF'
{description}
EOF
)"
```

## Key Requirements

- NEVER push commits - only generate PR content or create the PR via `gh`
- Analyze ALL commits on the branch, not just the latest one
- If the branch has no commits ahead of base, inform the user and exit
- If there are uncommitted changes, warn the user but continue with committed changes
- Write PR content as if it were written entirely by the human developer
