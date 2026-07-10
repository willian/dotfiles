---
description: Review unstaged and staged comments added on the current branch and cut them down to only the strictly necessary, rewriting survivors in plain English.
allowed-tools: Bash, Read, Edit, Grep, Skill
model: opus
effort: high
---

## Behavior

Review every comment added in the uncommitted changes. Remove comments
that a reader does not need, then rewrite the survivors to be short and plain.
The goal: only strictly necessary comments remain.

Edit comments and code in the working tree. Do not commit. Only touch comments
added or changed in the uncommitted diff — leave already-committed comments
alone.

Follow these steps in order.

### Step 1: Collect the comments in the uncommitted changes

- [ ] Run `git diff HEAD` to read the full uncommitted diff, both staged and
      unstaged. If nothing appears, run `git diff` and `git diff --cached`
      separately to confirm.
- [ ] Collect every added (`+`) or changed line that is a comment. Cover each
      language in the diff:
  - Ruby, shell, YAML: `#`
  - TS/JS: `//` and `/* */`
  - JSX/TSX: `{/* */}`
  - ERB: `<%# %>`
  - CSS/SCSS: `/* */`
- [ ] Include comments attached to code the diff changed, not just brand-new
      comment lines.
- [ ] If no comments were added, say so and stop.

### Step 2: Triage each comment against two questions

For each comment, decide whether it should exist at all:

1. **Can renaming or refactoring the code carry the intent instead?** A comment
   that restates what a clearer name or small refactor could show should go.
   Prefer changing the code.
2. **Is the comment necessary for a reader who knows the frameworks?** Drop
   comments, or clauses inside a comment, that explain standard framework
   behavior. This covers how environment flags resolve — what `Rails.env`,
   `RAILS_ENV`, or `NODE_ENV` mean and which environments they map to — config
   defaults, and standard Rails, React, or library conventions. A framework
   developer already knows these, so keep only the intent the code cannot show.

   Apply this at the clause level, not just the whole comment. When one
   sentence states real intent and another explains framework behavior, cut the
   framework sentence and keep the intent. Example:

   ```ruby
   # Only emit where Cloud Logging reads STDOUT. Deployed environments boot as
   # RAILS_ENV=production, so the guard covers staging and preview too.
   ...subscribe if Rails.env.production?
   ```

   becomes:

   ```ruby
   # Only emit where Cloud Logging reads STDOUT.
   ...subscribe if Rails.env.production?
   ```

   The second sentence explains how `RAILS_ENV` maps to environments, which any
   Rails developer understands, so cut it.

Keep a comment only when it explains non-obvious intent, a constraint, a
warning, or a decision the code cannot show on its own. Never drop a legal or
license notice.

- [ ] Present a short table: each comment, the verdict (remove / refactor code /
      keep-and-rewrite), and a one-line reason.
- [ ] Renames or refactors change code, so confirm those with the user before
      applying. Comment-only removals and rewrites need no confirmation.

### Step 3: Apply removals and refactors

- [ ] Remove the comments marked for removal.
- [ ] For comments replaced by clearer code, apply the confirmed rename or
      refactor and delete the comment.

### Step 4: Rewrite the surviving comments

Rewrite each kept comment against the rules below.

**Audience:** Attention is expensive. Readers are engineers under time pressure
who skim comments. Be concise and do not overstate.

**Rules:**

1. Aim for short sentences, roughly 15-25 words. Combine closely related ideas
   into one flowing sentence rather than splitting every clause.
2. Avoid jargon and fancy synonyms. Use the simplest wording that communicates
   the idea.
3. Keep each sentence focused, but let a cause and its effect share one
   sentence.
4. Cut filler. Remove or replace words like "in order to", "as well as", "the
   ability to", "leverage", "utilize", "robust", "comprehensive", "seamless".
5. Use active voice.
6. Say a thing once.
7. Avoid sentences that list 3 or more items. Use a bulleted list instead.
8. Avoid pronouns.
9. Avoid parenthetical asides and advanced punctuation. Subordinate clauses are
   fine when they keep two related ideas in one sentence.
10. Write complete sentences that flow together into a complete idea.
11. Replace reinforcing "and"s with the single most impactful item. "search and
    find" becomes "search"; "neat and tidy" becomes "tidy".
12. Remove or quantify weasel words that generalize data. "huge impact on
    revenue" becomes "increases revenue by XX%" or "required to hit revenue
    targets".
13. Lead with the most critical information first.

- [ ] Rewrite each comment, then check it against every rule and shorten again.
- [ ] Show a before/after for each rewritten comment.

### Step 5: Verify and summarize

- [ ] If code changed, run the relevant linter and tests for the touched files.
- [ ] Summarize: comments removed, code refactored, comments rewritten.

## Key Requirements

- Only touch comments added or changed in the uncommitted diff.
- Prefer clearer code over a comment whenever a rename or small refactor works.
- Confirm before any rename or refactor; apply comment removals and rewrites
  directly.
- Keep comments that carry non-obvious intent, constraints, warnings, or
  required notices.
