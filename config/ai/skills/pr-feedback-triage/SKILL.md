---
name: pr-feedback-triage
description: Triage and address GitHub PR feedback using gh. Use when an AI agent needs to read PR comments from reviewers, group feedback by origin commit, decide what to address, push back on, clarify, or answer, write markdown analysis files, draft replies, or work through requested PR feedback changes.
model: opus
effort: high
---

# PR Feedback Triage

## Behavior

Use this skill to inspect feedback on the pull request associated with the
current branch, classify each actionable comment, and optionally work through
the comments one at a time.

Default to analysis-only triage unless the user explicitly asks to make code
changes or draft replies for GitHub.

## Inputs

- Prefer an explicit PR number when the user provides one.
- If no PR number is provided, infer it with `gh pr view`.
- Prefer an explicit reviewer username when the user provides one.
- If no reviewer is provided, include everyone unless the request says to ask.
- If the user says "my peer, <username>" or similar, treat `<username>` as the
  reviewer filter.

## Prerequisites

Before making code changes for feedback, ask:

1. Have you rebased onto the target branch? This helps keep commit ownership
   clear when amending feedback fixes.
2. Whose feedback should we address? Default to everyone if the user does not
   name a reviewer.

If the user has not rebased, stop before changing code and ask them to rebase
first.

For analysis-only triage, do not require the rebase question.

## Fetch Feedback

Use `gh` to collect every relevant feedback stream:

- PR metadata: `gh pr view --json number,url,headRefName,baseRefName`
- Issue-level comments: `gh api repos/{owner}/{repo}/issues/{n}/comments --paginate`
- Inline review comments: `gh api repos/{owner}/{repo}/pulls/{n}/comments --paginate`
- Review summaries: `gh api repos/{owner}/{repo}/pulls/{n}/reviews --paginate`
- Review thread status when needed: use GitHub GraphQL to identify resolved or
  outdated review threads.

Filter comments by the requested reviewer username when one is provided. Match
against `author.login` or `user.login`, depending on the payload shape.

Skip resolved and outdated inline review threads by default. Keep a count of
skipped comments in the summary. If a skipped comment looks important or the
user explicitly asks for all feedback, include it under a separate
`Skipped or stale feedback` section.

## Group Feedback

Group every comment by its origin commit:

1. Prefer `original_commit_id` for inline review comments.
2. Fall back to `commit_id` for inline review comments and review summaries.
3. Use `unmapped-pr-level-comments` for issue-level comments or comments that
   cannot be mapped to a commit.

For each commit group, try to enrich the heading with the short hash and commit
subject using local Git:

```bash
git show -s --format='%h %s' <commit>
```

If the commit is not present locally, keep the hash and mark it as not found in
the current checkout. Do not invent a mapping.

## Classify Comments

Classify each actionable comment as one of:

- `address`: The comment points out a correctness issue, regression, missing or
  inaccurate test, unclear code, maintainability problem, security concern,
  performance issue, or a cheap improvement with clear value.
- `push-back`: The premise appears incorrect, conflicts with the PR's intended
  design, is out of scope, is mostly subjective without clear benefit, or has a
  high implementation cost for low value.
- `clarify`: The comment is ambiguous, lacks enough context, cannot be mapped
  confidently, appears stale, or needs reviewer intent before action.
- `reply-only`: The comment can be answered without code changes.

Base the classification on the comment, surrounding code, PR context, and
commit intent. If uncertain, choose `clarify` instead of pretending the answer
is known.

## Write Analysis

Write markdown files under `pr-feedback-triage-<pr-number>/` unless the user
asks for a different location.

Create:

- `summary.md`: overall recommendation, counts by classification, skipped
  stale/resolved counts, and suggested order of work.
- One file per origin commit group:
  - `<short-hash>.md` for mapped comments.
  - `unmapped-pr-level-comments.md` for unmapped comments.

Use this structure for each commit file:

```markdown
# PR Feedback Triage: <commit-or-group>

## Commit

- Hash: <full-hash-or-unmapped>
- Subject: <subject-or-not-available>

## Recommendation

<Short summary of what should be addressed, pushed back, clarified, or answered.>

## Comments

### <classification>: <short comment label>

- Reviewer: <username>
- Source: <comment URL>
- Location: <file:line or PR-level>
- Status: <active | resolved | outdated | unknown>
- Comment: <brief paraphrase or short quote>
- Reasoning: <why this classification is appropriate>
- Suggested response: <copy-pasteable reply in my voice, when useful>
- Suggested change: <concrete code/test/docs action, or "None">
```

Keep quoted comment text short. Paraphrase long comments.

## Reply Voice

When drafting replies, write in a human, natural voice as if written by me.
Keep replies concise. Do not repeat context the reviewer already wrote. Never
use em dashes or en dashes.

For pushback, be direct but collaborative:

- Acknowledge the point.
- State the reason for not changing it.
- Offer a narrow alternative only when useful.

For clarification, ask one specific question.

## Working Through Changes

When the user asks to address feedback:

1. Confirm the rebase prerequisite.
2. Work one comment or one commit group at a time.
3. Make the smallest code, test, or documentation change that resolves the
   accepted feedback.
4. After each change, report what changed and ask before moving to the next
   comment or commit group.
5. Do not post GitHub replies automatically unless the user explicitly asks.

Do not change code for comments classified as `push-back`, `clarify`, or
`reply-only` unless the user overrides the classification.
