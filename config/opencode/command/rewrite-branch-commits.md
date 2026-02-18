---
description: Interactively rewrite commit messages for all commits on current branch
agent: build
---

## Behavior

This command rewrites commit messages for all commits on your current branch
that differ from main. It uses an interactive process with multiple confirmation
points.

**Important:** This command rewrites git history. Only use on branches that
haven't been pushed, or that you're comfortable force-pushing.

Follow these steps in order:

### Step 1: Verify Rebase Status

- [ ] Ask: "Have you rebased from main? This ensures we rewrite the correct
      commits. (yes/no)"
- [ ] If no: instruct to run `git rebase main` first and exit
- [ ] If yes: proceed

### Step 2: Identify Commits to Rewrite

- [ ] Run `git log main..HEAD --oneline` to get list of commits
- [ ] Display the list with: "These N commits will be reviewed for rewriting:"
- [ ] Show each commit hash and title
- [ ] Ask: "Proceed with reviewing these commits? (yes/no)"
- [ ] If no: exit
- [ ] If yes: proceed

### Step 3: Review and Rewrite Each Commit

For each commit (oldest to newest):

- [ ] Check out the commit temporarily: `git checkout {hash}`
- [ ] Display: "**Reviewing commit {n}/{total}: {short-hash}**"
- [ ] Show original commit message (title and body)
- [ ] Analyze changes using the commit-review process:
  - Read files changed and diff
  - Follow the three-pass writing process from the style guide
  - Generate improved commit message
- [ ] Display the proposed improved message
- [ ] Ask: "Action? (accept/skip/abort)"
  - **accept**: Use the improved message
  - **skip**: Keep the original message
  - **abort**: Stop the rewrite process and return to original branch
- [ ] Return to original branch: `git switch -`

### Step 4: Apply Rewrites

If any commits were accepted for rewriting:

- [ ] Use `git rebase -i main` with the exec command to reword accepted commits
- [ ] For each accepted commit, amend with the improved message using HEREDOC
      format

### Step 5: Summary

- [ ] Display summary:
  - Total commits reviewed: N
  - Commits rewritten: N
  - Commits skipped: N
- [ ] Run `git log main..HEAD --oneline` to show final state
- [ ] Remind: "Branch history has been rewritten. Use
      `git push --force-with-lease` if already pushed."

## Commit Message Style

Follow the guidelines in @/Users/willian/.config/opencode/command/shared/commit-message-style.md

## Key Requirements

- NEVER proceed without explicit user confirmation at each step
- NEVER force-push automatically - only remind the user
- If user aborts, return to original branch state
- Always use HEREDOC format for commit messages
- Display clear progress indicators (commit n/total)
