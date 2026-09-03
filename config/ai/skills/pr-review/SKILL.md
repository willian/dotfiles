---
name: pr-review
description: Review current branch code changes and generate a review report for each commit
model: opus-4-7
effort: high
---

# PR Review Command

## Behavior

This command review each commit from the current branch.

Follow these steps in order:

### Step 1: Verify Branch Status

- [ ] Ask: "Have you pulled latest changes from this branch? (yes/no)"
- [ ] If no: instruct to run `git pull` first and exit
- [ ] If yes: proceed

### Step 2: Gather Branch Context

- [ ] Run `git log main..HEAD --oneline --reverse` to get list of commits
      (oldest first - position 1 = oldest, matching plan positions)
- [ ] Display the list with: "These N commits will be reviewed:"
- [ ] Show each commit hash and title
- [ ] Ask: "Proceed with reviewing these commits? (yes/no)"
- [ ] If no: exit
- [ ] If yes: proceed

### Step 3: Gather Each Commit Context And Review

For each commit (oldest to newest):

- [ ] Check out the commit temporarily: `git checkout {hash}`
- [ ] Display: "**Reviewing commit {n}/{total}: {short-hash}**"
- [ ] Run `git diff-tree --no-commit-id --name-only -r HEAD` to get changed files
- [ ] Run `git show HEAD` to get the full diff of the commit
- [ ] For each changed file, build a line-reference map from the diff:
  - [ ] Run `git show --format= --find-renames --unified=0 HEAD -- {file}` to
        identify the exact new-file lines changed by the commit
  - [ ] Run `git show --format= --find-renames --unified=80 HEAD -- {file}` to
        inspect nearby context when needed
  - [ ] Run `nl -ba {file}` for files that exist at `HEAD` to verify the final
        new-file line number and surrounding code
  - [ ] Treat line numbers in final comments as new-file line numbers at `HEAD`,
        not old-file line numbers from before the commit
- [ ] Run `git log -1 --format="%H%n%s%n%b"` to get the full commit message
- [ ] Review whether the commit message accurately describes the diff
- [ ] Check the commit message against
      `config/ai/skills/shared/commit-message-style.md`
- [ ] Flag commit-message issues when:
  - [ ] The title or body says something not supported by the diff
  - [ ] The message only says what changed but misses why it changed
  - [ ] The title is vague, misleading, too long, or not imperative
  - [ ] The body reads as disconnected facts instead of a narrative
  - [ ] The message includes implementation details already obvious from the diff
- [ ] For each file in the commit:
  - [ ] Analyze the changes looking for:
    - [ ] **Readability & Maintainability:** unclear variable/function
          names, overly complex logic, missing or misleading comments, poor
          code structure, violation of DRY principle, magic numbers/strings,
          inconsistent naming conventions
    - [ ] **Performance issues:** inefficient algorithms, unnecessary
          iterations, memory leaks, redundant computations, N+1 queries,
          blocking operations, missing memoization opportunities
    - [ ] **Typos:** spelling errors in variable names, function names,
          comments, string literals, error messages, documentation
    - [ ] **Trivial issues:** unused imports, dead code, debugging
          artifacts, console logs, commented-out code
    - [ ] **Code issues:** potential bugs, edge cases, error handling gaps
    - [ ] **Test inconsistencies:** missing tests for new functionality,
          tests that don't match implementation, broken test assertions
    - [ ] **Guideline violations:** any rules from AGENTS.md or CLAUDE.md
          that are not followed
  - [ ] Record findings with specific line numbers, add findings to the next
        line instead of in front of the line number
  - [ ] Before recording any finding, verify the target line against the
        line-reference map. If the exact line cannot be verified, do not keep
        the line reference.

### Step 4: Generate Review Report

#### Output Voice Contract

All final report text must read like a human PR comment written by me to the PR
author.

- [ ] Use first person where natural: "I think...", "I'd prefer...",
      "I'm not sure..."
- [ ] Use direct but friendly phrasing addressed to the author
- [ ] Every summary, rationale, verdict, commit-message note, and finding must
      be copy-pasteable into a PR comment without editing
- [ ] Avoid robotic review labels inside the prose
- [ ] Do not describe the code line when the line already provides that context:
  - Bad: "`def some_method_name` is doing too much..."
  - Good: "This method is doing a bit too much..."
- [ ] Use the line reference as context, then talk about the concern naturally

For each reviewed commit, follow this five-pass process:

#### Pass 1: Draft all comments

- [ ] Write initial feedback for each issue found
- [ ] Include line numbers as context for yourself, not as part of the final
      comment
- [ ] Display with "**First pass:**" label

#### Pass 2: Apply formatting and prefixes

- [ ] Format each comment with the line reference in parentheses before the
      prefix:
  - `(Line {n}) Non-blocking: {concise comment}`
  - `(Lines {n}-{m}) Nit: {concise comment}`
  - `(Line {n}) {blocking comment with no prefix}`
- [ ] Ensure every comment uses regular hyphens only (no em/en dashes)
- [ ] Display with "**Second pass (formatted):**" label

#### Pass 3: Verify suggestions

For any comment that proposes an alternative approach, code change, or specific
library/feature usage:

- [ ] **Check existence**: Do referenced classes, modules, methods, or constants
      actually exist in this codebase?
- [ ] **Check validity**: Is the suggestion technically valid given the current
      code context? (e.g., `class_double` requires a real class; mock patterns
      may be intentional)
- [ ] **Check intent**: Does the code use an intentionally unconventional
      pattern? (e.g., anonymous classes, metaprogramming, test doubles)
- [ ] **Rephrase if uncertain**: If you cannot verify the suggestion is correct,
      rephrase as a genuine question instead of a confident statement:
  - Wrong: "Use `class_double('FakeModel', exists?: true)` instead"
  - Right: "Would `class_double` work here? Not sure if that fits with how the
    test doubles are set up"
- [ ] Display with "**Third pass (verified):**" label

#### Pass 4: Verify line references

For every final comment that includes `(Line {n})` or `(Lines {n}-{m})`:

- [ ] **Check file path**: The file path in the report must exactly match a file
      changed by the commit.
- [ ] **Check line source**: The referenced line must be a new-file line number
      from `HEAD`, verified with `nl -ba {file}` after checking out the commit.
- [ ] **Check diff presence**: The referenced line must appear in the commit
      diff as an added or modified line, or as nearby diff context that GitHub
      would show for that hunk.
- [ ] **Check content match**: The concern must match what is actually on that
      line or line range. Do not use a method name, variable, string, or behavior
      in the comment unless it appears on the referenced line range or its
      immediate surrounding context.
- [ ] **Check ranges**: For `(Lines {n}-{m})`, both endpoints must exist in the
      same file at `HEAD`, `n` must be less than `m`, and every line in the range
      must be relevant to the comment.
- [ ] **Fix or remove**: If a line reference is wrong, stale, guessed, points to
      the old file, or only loosely related, either move it to the verified
      correct line or remove that finding. Never leave an approximate line
      number in the final report.
- [ ] **No unverified detailed findings**: Detailed Findings must only contain
      comments with verified line references. If a concern is real but no exact
      line can be verified, mention it only in the summary without a line
      reference, or omit it.
- [ ] Display with "**Fourth pass (line-verified):**" label

#### Pass 5: Review and refine

- [ ] Check for quality issues:
  - [ ] **Grammar**: Every sentence is grammatically complete
  - [ ] **Tone**: Casual and conversational, not robotic or accusatory
  - [ ] **Conciseness**: One or two sentences max per comment
  - [ ] **Voice**: Sounds like a Brazilian developer wrote it
  - [ ] **No em/en dashes**: Verify no `—` or `–` anywhere in output
  - [ ] **Prefixes correctly applied**: Minor suggestions have `Non-blocking`,
        trivial have `Nit`, blocking have none
  - [ ] **Line references**: Parentheses with line numbers appear before the
        prefix, not inside the comment text
  - [ ] **Line accuracy**: Every line reference was verified against the
        checked-out file at `HEAD` and the commit diff. No approximate or guessed
        line numbers remain.
  - [ ] **No unverified findings**: The Detailed Findings section contains no
        comments whose file path and line reference were not verified.
  - [ ] **First-person voice**: Feedback sounds like I wrote it to the PR author
  - [ ] **PR-ready**: The text can be pasted directly as a PR comment
  - [ ] **Line context**: Comments use `(Line n)` / `(Lines n-m)` as context and
        do not repeat code already visible on that line
  - [ ] **Suggestion accuracy**: No confident suggestions that depend on
        unverified assumptions about the codebase
  - [ ] **Commit message accuracy**: The commit message matches the actual diff
        and follows `config/ai/skills/shared/commit-message-style.md`
- [ ] If issues found, refine and display with "**Final (refined):**" label

Create a markdown file named `pr-review-{index}-{short-hash}.md` in the current
directory with this structure:

```markdown
# PR Review: {commit-hash}

## Commit Info

**Message:** {commit message}
**Files Changed:** {number of files}

## Verdict

{One sentence: either "I'd approve this as-is." or "I'd request changes because there are blocking issues."}

## Summary

{2-3 sentences max. Briefly mention the main concern or say "I did not see anything major, just a few nits." Do NOT repeat what was already commented above - just the big picture.}

## Commit Message

{Either "Looks good to me." or a short copy-pasteable comment explaining what should change.}

## Detailed Findings

### `{file-path}`

#### Readability & Maintainability

- (Line {n}) Non-blocking: {concise comment}
- (Lines {n}-{m}) Nit: {concise comment}

#### Performance

- (Line {n}) Non-blocking: {concise comment}

#### Typos

- (Line {n}) Nit: `{typo}` -> `{correction}`

---

### `{next-file-path}`

...
```

### Step 5: Output Results

- [ ] Save the review file
- [ ] Display a summary of findings to the user
- [ ] Report the path to the generated review file
- [ ] Move to the next commit or exit when in the last commit

### Step 6: Write Final Summary File

After all commits are reviewed, create a file named `pr-review-summary.md` in
the current directory with this exact structure:

```markdown
# PR Review Summary

## Overall Verdict

{ "I'd approve this." or "I'd request changes." }

## Rationale

{ 2-3 sentences explaining why. If approving: "I did not find anything blocking, just a couple nits." If requesting changes: "I found X blocking issues that I think we should fix before merge." }

## Per-Commit Status

| Commit       | Verdict                             |
| ------------ | ----------------------------------- |
| {short-hash} | {I'd approve / I'd request changes} |
| {short-hash} | {I'd approve / I'd request changes} |
```

## Issue Categories

### Readability & Maintainability

- Unclear or misleading names
- Functions doing too many things
- Deep nesting or complex conditionals
- Missing error handling
- Duplicated code
- Inconsistent code style
- Missing or outdated comments
- Poor separation of concerns

### Performance

- O(n^2) or worse algorithms where better exists
- Unnecessary database queries or API calls
- Missing caching opportunities
- Synchronous operations that could be async
- Large memory allocations
- Inefficient string concatenation
- Redundant re-renders (React/frontend)

### Typos

- Misspelled variable/function/class names
- Typos in comments and documentation
- Spelling errors in user-facing strings
- Incorrect technical terms

### Trivial Issues

- Unused imports or variables
- Dead code or unreachable branches
- Debugging artifacts (console.log, debugger, print statements)
- Commented-out code blocks

### Code Issues

- Potential bugs or logic errors
- Unhandled edge cases
- Missing error handling
- Race conditions or async issues

### Test Inconsistencies

- Missing tests for new functionality
- Tests that don't match implementation
- Broken or incomplete test assertions
- Test coverage gaps for critical paths

## Guidelines

Follow the guidelines in `AGENTS.md` or `CLAUDE.md` if they exists in the project.

## Key Requirements

- Use the short commit hash (7 characters) for the filename
- Be specific about line numbers and provide actionable feedback
- Only include detailed findings with verified line references. Never guess or
  approximate a line number.
- For each issue, explain WHY it's a problem and suggest a fix
- For each issue, write a message that I can copy and paste to my peer
- Write summaries, verdicts, rationale, commit-message notes, and findings in a
  natural first-person voice, as if I wrote them directly to the PR author
- Use the line reference as context instead of repeating code that is already
  visible on that line
- For every individual comment, start with `Non-blocking:` or `Nit:`
  (after the line reference in parentheses) if it's a suggestion or minor issue
  that shouldn't block the merge. Only omit the prefix if the issue is critical
  and should block the PR.
- Write all feedback messages in a way they look like written by me, a
  Brazilian developer, using a casual natural voice, so I can copy and
  paste them into GitHub comments.
- Skip categories that have no issues for a file
- If a file has no issues at all, include it with "I did not find issues here"
- Prioritize impactful issues over minor nitpicks
- If no issues are found in any file, state "I did not find any issues in this PR"
- NEVER modify any code - only generate the review report
- NEVER use em dashes (—) or en dashes (–) in ANY output: not in review
  comments, not in summaries, not in verdicts, not in rationale. Use regular
  hyphens (-) only.
- **Sort files alphabetically by path in the report**
- **Sort issues by line number (ascending) within each category**

## Writing Style

Review comments must be casual, concise, and sound like they were written by a
Brazilian developer writing in a natural human voice - direct, friendly, and
natural. They must be suitable for direct copy-paste into GitHub PR reviews.

**Tone rules:**

- Grammar MUST be correct. No broken English, no missing articles.
- Be concise. One or two sentences max per comment.
- Casual and conversational: "This might break if...", "Maybe we could..."
- Use first person when it sounds natural: "I think...", "I'd prefer...",
  "I'm not sure..."
- Never robotic: no "ISSUE:", "VIOLATION:", "ERROR:"
- Never accusatory: no "You forgot...", "This is wrong"
- Use short, natural phrasing you'd actually type in a PR comment
- Do not repeat what the referenced line already shows. Use the line reference
  as context and focus the comment on the concern.

**Prefixes:**

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

Bad (line reference inside comment):

- "Nit: Lines 10-14, the comment for 'ID stability' got mangled..."

Bad (robotic):

- "[TYPO] Variable 'reponse' is misspelled. Should be 'response'."
- "[PERF] Inefficient: Loop executes on each render cycle without memoization."
- "It is recommended that the developer consider refactoring this function."
