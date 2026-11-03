---
name: pr-review
description: Review current branch code changes and generate a review report for each commit
model: claude-opus-5-5
effort: high
---

# PR Review Command

## Behavior

This command reviews each commit on the current branch, then the PR as a whole.
It never checks out other commits: read commit content with `git show`, so the
working tree and branch never change.

Follow these steps in order:

### Step 1: Verify Branch Status

- [ ] Run `git status --porcelain`. If the tree is dirty, tell me and exit
- [ ] Run `git fetch` and compare `git rev-parse HEAD` with
      `git rev-parse @{u}`
- [ ] If the branch is behind its upstream: tell me to run `git pull` and exit
- [ ] Otherwise: proceed

### Step 2: Gather Branch Context

- [ ] Find the base branch with `gh pr view --json baseRefName,number`. If
      there is no PR, use the remote default from
      `git symbolic-ref --short refs/remotes/origin/HEAD`, or `main` if that
      fails
- [ ] Run `git log origin/{base}..HEAD --oneline --reverse` to get the list of
      commits (oldest first - position 1 = oldest, matching plan positions)
- [ ] Display the list with: "These N commits will be reviewed:"
- [ ] Show each commit hash and title
- [ ] Ask: "Proceed with reviewing these commits? (yes/no)"
- [ ] If no: exit
- [ ] If yes: proceed
- [ ] Load the spec: run `gh pr view --json body,comments` and, if a Linear
      ticket is linked, read it with Linear `get_issue`
- [ ] Extract the acceptance criteria, exact user-facing copy, and open
      questions. Keep them for Step 4 and Pass 3
- [ ] Load existing review threads with
      `gh api repos/{owner}/{repo}/pulls/{number}/comments --paginate`. Do not
      repeat a point another reviewer already made, and do not suggest
      something that contradicts an earlier comment without saying so

### Step 3: Review Each Commit

For each commit (oldest to newest):

- [ ] Display: "**Reviewing commit {n}/{total}: {short-hash}**"
- [ ] Run `git diff-tree --no-commit-id --name-only -r {hash}` to get changed
      files
- [ ] Run `git show {hash}` to get the full diff of the commit
- [ ] For each changed file, build a line-reference map from the diff:
  - [ ] Run `git show --format= --find-renames --unified=0 {hash} -- {file}`
        to identify the exact new-file lines changed by the commit
  - [ ] Run `git show --format= --find-renames --unified=80 {hash} -- {file}`
        to inspect nearby context when needed
  - [ ] Run `git show {hash}:{file} | nl -ba` for files that exist at the
        commit to verify the final new-file line number and surrounding code
  - [ ] Treat line numbers in final comments as new-file line numbers at the
        commit, not old-file line numbers from before the commit
- [ ] Run `git log -1 --format="%H%n%s%n%b" {hash}` to get the full commit
      message
- [ ] Review whether the commit message accurately describes the diff
- [ ] Check the commit message against
      @/Users/willian/dotfiles/config/ai/skills/shared/commit-message-style.md
- [ ] Flag commit-message issues when:
  - [ ] The title or body says something not supported by the diff
  - [ ] The message only says what changed but misses why it changed
  - [ ] The title is vague, misleading, too long, or not imperative
  - [ ] The body reads as disconnected facts instead of a narrative
  - [ ] The message includes implementation details already obvious from the
        diff
- [ ] For each file in the commit, analyze the changes for every category in
      the Issue Categories section
- [ ] **Required, never skip:** run the `ponytail:ponytail-review` skill on the
      commit. If the skill is not installed, say so in the final output instead
      of skipping it silently
- [ ] Record findings with specific line numbers
- [ ] Before recording any finding, verify the target line against the
      line-reference map. If the exact line cannot be verified, do not keep the
      line reference
- [ ] Exclude files that have no findings from the report

### Step 4: Review The Whole PR

Per-commit, per-file review misses bugs that span files or commits. After all
commits, review `git diff origin/{base}...HEAD` as one change, reading files
from the working tree at `HEAD`:

- [ ] **Acceptance criteria**: for each criterion, find the code that
      implements it and the test that covers it. A missing or contradicted
      criterion is a blocking finding
- [ ] **Copy**: compare every user-facing string in the diff with the copy in
      the ticket. Flag each difference
- [ ] **Open questions**: for each open question in the ticket, check how the
      code answers it. Flag any that the code leaves unanswered
- [ ] **State timing**: for each user action that reads shared or async state
      (forms, mutations, revalidation), check whether the code reads the state
      when the action starts or when the user submits. Then ask: what happens
      if another user changes it in between, or if the request fails after it
      partly succeeds? Follow the data into files the PR did not change
- [ ] Add each finding to the report of the commit that introduced the code,
      with a line reference verified at that commit

### Step 5: Generate Review Report

For each reviewed commit, refine the findings in the five passes below. Run the
passes internally. Display only the final version of each comment.

#### Pass 1: Draft all comments

- [ ] Write initial feedback for each issue found
- [ ] Keep line numbers as context for yourself, not as part of the comment

#### Pass 2: Apply formatting and prefixes

- [ ] Format each comment with the line reference in parentheses before the
      prefix, as described in the Writing Style section

#### Pass 3: Verify suggestions

For any comment that proposes an alternative approach, code change, or specific
library/feature usage:

- [ ] **Check existence**: Do the referenced classes, modules, methods, or
      constants actually exist in this codebase?
- [ ] **Check validity**: Is the suggestion technically valid given the current
      code context? (e.g., `class_double` requires a real class; mock patterns
      may be intentional)
- [ ] **Check intent**: Does the code use an intentionally unconventional
      pattern? (e.g., anonymous classes, metaprogramming, test doubles)
- [ ] **Check spec**: The suggestion must not contradict the ticket's
      acceptance criteria or copy. Drop or rephrase any that do
- [ ] **Rephrase if uncertain**: If you cannot verify the suggestion is correct,
      rephrase as a genuine question instead of a confident statement:
  - Wrong: "Use `class_double('FakeModel', exists?: true)` instead"
  - Right: "Would `class_double` work here? Not sure if that fits with how the
    test doubles are set up"
- [ ] **Required, never skip:** use the `ponytail` skill to ensure the
      suggestions are as minimal as possible and follow good architecture
      practices

#### Pass 4: Verify line references

For every comment that includes `(Line {n})` or `(Lines {n}-{m})`:

- [ ] **Check file path**: The file path must exactly match a file changed by
      the commit
- [ ] **Check line source**: The line must be a new-file line number at the
      commit, verified with `git show {hash}:{file} | nl -ba`
- [ ] **Check diff presence**: The line must appear in the commit diff as an
      added or modified line, or as nearby diff context that GitHub would show
      for that hunk
- [ ] **Check content match**: The concern must match what is actually on that
      line or line range. Do not use a method name, variable, string, or
      behavior in the comment unless it appears on the referenced line range or
      its immediate surrounding context
- [ ] **Check ranges**: For `(Lines {n}-{m})`, both endpoints must exist in the
      same file at the commit, `n` must be less than `m`, and every line in the
      range must be relevant to the comment
- [ ] **Fix or remove**: If a line reference is wrong, stale, guessed, points to
      the old file, or only loosely related, either move it to the verified
      correct line or remove that finding. Never leave an approximate line
      number in the final report
- [ ] **No unverified detailed findings**: If a concern is real but no exact
      line can be verified, mention it only in the summary without a line
      reference, or omit it

#### Pass 5: Review and refine

- [ ] Check every comment against the Writing Style section
- [ ] Check that each blocking comment has no prefix and each other comment has
      `Non-blocking:` or `Nit:`
- [ ] Check that the commit message note matches the actual diff and follows
      @/Users/willian/dotfiles/config/ai/skills/shared/commit-message-style.md

Create a markdown file named `pr-review-{index}-{short-hash}.md` in the current
directory with this structure. Skip categories with no findings:

```markdown
# PR Review: {commit-hash}

## Commit Info

**Message:** {commit message}
**Files Changed:** {number of files}

## Verdict

{One sentence: either "I'd approve this as-is." or "I'd request changes because there are blocking issues."}

## Summary

{2-3 sentences max. Briefly mention the main concern or say "I did not see anything major, just a few nits." Do NOT repeat the findings below - just the big picture.}

## Commit Message

{Either "Looks good to me." or a short copy-pasteable comment explaining what should change.}

## Detailed Findings

### `{file-path}`

#### Code Issues

- (Line {n}) {blocking comment with failure scenario}

#### Spec

- (Line {n}) {comment}

#### Test Inconsistencies

- (Line {n}) Non-blocking: {concise comment}

#### Guideline Violations

- (Line {n}) Nit: {concise comment}

#### Readability & Maintainability

- (Line {n}) Non-blocking: {concise comment}
- (Lines {n}-{m}) Nit: {concise comment}

#### Performance

- (Line {n}) Non-blocking: {concise comment}

#### Trivial Issues

- (Line {n}) Nit: {concise comment}

#### Typos

- (Line {n}) Nit: `{typo}` -> `{correction}`

---

### `{next-file-path}`

...
```

### Step 6: Output Results

- [ ] Save the review file
- [ ] Display a summary of findings to the user
- [ ] Report the path to the generated review file
- [ ] Move to the next commit or exit when in the last commit

### Step 7: Write Final Summary File

After all commits are reviewed, create a file named `pr-review-summary.md` in
the current directory with this exact structure:

```markdown
# PR Review Summary

## Overall Verdict

{ "I'd approve this." or "I'd request changes." Request changes when any
acceptance criterion is broken, even if every per-commit verdict approves. }

## Rationale

{ 2-3 sentences explaining why. If approving: "I did not find anything blocking, just a couple nits." If requesting changes: "I found X blocking issues that I think we should fix before merge." }

## Blocking Findings

{ Omit this section when there are none. }

- `{file-path}:{line}` ({short-hash}): {one-line summary}

## Per-Commit Status

| Commit       | Verdict                             |
| ------------ | ----------------------------------- |
| {short-hash} | {I'd approve / I'd request changes} |
| {short-hash} | {I'd approve / I'd request changes} |
```

### Step 8: Humanize All Comments

This step is required. Do not finish without it.

- [ ] Re-read every generated `pr-review-*.md` file, including
      `pr-review-summary.md`
- [ ] Rewrite every feedback comment, summary, verdict, and rationale so it
      sounds as human and natural as possible, per the Writing Style section
- [ ] Keep line references, prefixes, and meaning unchanged
- [ ] Save the updated files
- [ ] End the final output with this checklist, filled in truthfully:
  - `Ponytail review: ran on N/N commits`
  - `Humanize pass: done on N files`

## Issue Categories

### Code Issues

- Potential bugs or logic errors
- Unhandled edge cases
- Missing error handling
- Race conditions or async issues

### Spec

- Acceptance criteria not implemented or contradicted
- User-facing copy that differs from the ticket
- Open questions the code leaves unanswered

### Test Inconsistencies

- Missing tests for new functionality
- Tests that don't match implementation
- Broken or incomplete test assertions
- Test coverage gaps for critical paths

### Guideline Violations

- Rules from `AGENTS.md` or `CLAUDE.md` that are not followed

### Readability & Maintainability

- Unclear or misleading names
- Functions doing too many things
- Deep nesting or complex conditionals
- Duplicated code
- Inconsistent code style
- Missing, misleading, or outdated comments
- Magic numbers or strings
- Poor separation of concerns

### Performance

- O(n^2) or worse algorithms where better exists
- Unnecessary database queries or API calls, N+1 queries
- Missing caching or memoization opportunities
- Blocking operations that could be async
- Large memory allocations
- Redundant re-renders (React/frontend)

### Trivial Issues

- Unused imports or variables
- Dead code or unreachable branches
- Debugging artifacts (console.log, debugger, print statements)
- Commented-out code blocks

### Typos

- Misspelled variable/function/class names
- Typos in comments and documentation
- Spelling errors in user-facing strings
- Incorrect technical terms

## Key Requirements

- Follow the guidelines in `AGENTS.md` or `CLAUDE.md` if they exist in the
  project
- Use the short commit hash (7 characters) for the filename
- Only include detailed findings with verified line references. Never guess or
  approximate a line number
- For each issue, explain why it's a problem and suggest a fix
- Prioritize impactful issues over minor nitpicks
- If no issues are found in any file, state "I did not find any issues in this
  PR"
- NEVER modify any code - only generate the review report
- Sort files alphabetically by path in the report
- Sort issues by line number (ascending) within each category

## Writing Style

Every comment, summary, verdict, rationale, and commit-message note must follow
@/Users/willian/dotfiles/config/ai/skills/shared/writing-voice.md. The rules
below add what is specific to review comments.

**Line context:**

- Do not repeat what the referenced line already shows. Use the line reference
  as context and focus the comment on the concern:
  - Bad: "`def some_method_name` is doing too much..."
  - Good: "This method is doing a bit too much..."

**Length:**

- Non-blocking and nit comments: one or two sentences max
- Blocking comments: one or two sentences, plus a short concrete failure
  scenario (inputs or steps, then the wrong result) when the bug is not obvious

**Prefixes:**

- Format: `(Line {n}) {prefix}: {comment}` or `(Lines {n}-{m}) ...`
- Use `Non-blocking:` for suggestions that are nice-to-haves
- Use `Nit:` for trivial/minor things (typos, formatting, etc.)
- No prefix only for actual bugs or blocking issues
- Line references go in parentheses before the prefix, not inside the comment

**Examples:**

Good (Non-blocking):

- "(Line 42) Non-blocking: I think this can run on every render. Could we wrap it in `useMemo`?"
- "(Lines 15-18) Non-blocking: This looks very close to `validateInput()`. Could we reuse that instead?"

Good (Nit):

- "(Line 7) Nit: `reponse` -> `response`"
- "(Line 23) Nit: I think this `console.log` was left here by accident."

Good (blocking, no prefix):

- "(Line 31) I think this can throw when `user` is null, like during logout. Could we guard this case?"
- "(Line 58) I think Save can overwrite someone else's note here. If I open Add on Sourcing, you add a Sourcing note, and a revalidate pulls yours in, my Save sends a PATCH to your note. Could we keep the note id from when the form opens?"

Bad (line reference inside comment):

- "Nit: Lines 10-14, the comment for 'ID stability' got mangled..."

Bad (robotic):

- "[TYPO] Variable 'reponse' is misspelled. Should be 'response'."
- "[PERF] Inefficient: Loop executes on each render cycle without memoization."
- "It is recommended that the developer consider refactoring this function."
