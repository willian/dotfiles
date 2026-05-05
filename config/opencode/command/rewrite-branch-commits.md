---
description: Interactively rewrite commit messages for all commits on current branch
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

- [ ] Run `git log main..HEAD --oneline --reverse` to get list of commits
      (oldest first — position 1 = oldest, matching plan positions)
- [ ] Assign each commit a stable position from its 1-indexed line number in
      that output. Record the hash → position mapping now, using the hash as the
      key — titles may change during review but hashes do not. **Never infer
      position from review order.**
- [ ] Display the list with positions assigned:

  ```
  These N commits will be reviewed for rewriting:
    [1] abc1234 — "Commit title"
    [2] def5678 — "Commit title"
    ...
  ```

- [ ] Ask: "Proceed with reviewing these commits? (yes/no)"
- [ ] If no: exit
- [ ] If yes: proceed

### Step 3: Review and Rewrite Each Commit

For each commit (oldest to newest, matching the numbered list above):

- [ ] Look up this commit's position from the table built in Step 2 (using its
      hash as the key). Display: "**Reviewing commit {n}/{total}: {short-hash}
      (position {position} per git log)**"
- [ ] MUST run `git log -1 --format="%B" {hash}` to read the full commit message
      (title and body). Show the full message to the user.
- [ ] MUST run `git show {hash} -p` and read the full diff before proposing any
      message. Do not rely on the commit title or stat summary alone.
- [ ] If the motivation for the change is not clear from the diff and the
      existing commit message, ask the user before drafting: "I can see what
      changed in {short-hash}, but I'm not sure why. Can you explain the
      motivation?"
- [ ] Follow the three-pass writing process from the style guide:
  - [ ] **Pass 1 (Draft)**: Identify commit type, write title and body
    - Display with "**First pass:**" label
  - [ ] **Pass 2 (Simplify)**: Remove redundancy and repeated information
    - Display with "**Second pass (simplified):**" label
  - [ ] **Pass 3 (Review and Refine)**: Check for quality issues per style guide
    - Display with "**Third pass (refined):**" label
- [ ] Display the proposed improved message
- [ ] Ask: "Action? (accept/skip/abort)"
  - **accept**: Record the new message to apply later; continue to next commit
  - **skip**: Keep the original message; continue to next commit
  - **abort**: Stop immediately without applying any rewrites

### Step 4: Apply Rewrites

If any commits were accepted for rewriting:

1. Save the rewrite plan to `/tmp/rewrite_plan.json` using the Write tool. Each
   entry records the commit's **position** (1-indexed from oldest), its
   **original_title** (the title before rewriting), and the new **message**.
   Position is stable across rewrites because rewording doesn't change commit
   count or order.

   ```json
   [
     {
       "position": 1,
       "original_title": "Old title",
       "message": "Title\n\nBody..."
     },
     {
       "position": 5,
       "original_title": "Old title",
       "message": "Title\n\nBody..."
     }
   ]
   ```

2. Display a before/after summary of all planned rewrites:

   ```
   Position 1 (abc1234):
     Before: Old title
     After:  New title

   Position 5 (def5678):
     Before: Old title
     After:  New title
   ```

   Ask: "Apply these rewrites? (yes/no)"
   - If no: exit without applying
   - If yes: proceed

3. Run the rewrite script in a single Bash call:

   ```bash
   apply-commit-rewrites
   ```

   The script reads `/tmp/rewrite_plan.json`, looks up each commit hash by
   position at runtime, verifies the current title matches `original_title`
   before rewording (aborting with an error if not), and applies all rewrites
   sequentially. It prints a before/after summary when done.

   If the script fails mid-run (e.g., a commit-msg hook rejects the title), fix
   the message in `/tmp/msg_reword.txt`, copy it to `.git/COMMIT_EDITMSG`, run
   `git rebase --continue`, then re-run the script — already-applied rewrites
   are idempotent as long as the plan file is unchanged.

### Step 5: Summary

- [ ] Run `git log main..HEAD --oneline --reverse` to get the final hashes
- [ ] Display summary:
  - Total commits reviewed: N
  - Commits rewritten: N (list each as "{new-hash} {new-title}")
  - Commits skipped: N
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
