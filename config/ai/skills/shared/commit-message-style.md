---
description: Instructions for generating good commit messages
---

# Commit Message Style Guide

## Core Principle

Every commit message must make sense to someone reading it in isolation, with
enough context about where, what, and why. A reader should understand the change
without needing to look at the diff or other commits.

## Writing Process

Follow this multi-pass approach to craft quality commit messages:

### Pass 1: Draft

1. Identify and state the commit type (see "Body Structure")
2. Write the title. It MUST be 50 characters or fewer; verify with
   `echo -n "<title>" | wc -c`, never by eyeballing it. If it is over, shorten
   it before showing it to anyone (see "Shortening an over-long title").
3. Write the body following the body structure

### Pass 2: Simplify

1. Remove redundant or unnecessary details
2. Check for repeated information across paragraphs
3. For each passage, ask what the reader loses if it goes. "It is true" and "it
   is well written" are not reasons to keep it. A passage that reproduces a list
   the changed file already carries, or walks through content the diff shows,
   can go: say that the thing exists and let the file hold the particulars.
4. Cut what the reader already assumes, such as "the specs were updated to
   match". Nobody doubts that tests track the code.
5. Check the length against the size of the change. A message can follow every
   rule above and still be twice as long as the change deserves. A one-file
   change with a plain motive needs a short paragraph, not four.

### Pass 3: Review and Refine

Check the draft against the six currently most common mistakes. These are not
the most important rules in this guide; they are the ones drafts most often get
wrong right now:

1. **Too technical, in the weeds**: the body narrates code mechanics instead of
   system behavior, or names a method or class the reader has never heard of
   (see "Write for a Human Reader")
2. **Inaccurate claims**: statements not verified against the full diff, or
   stale after a squash or rebase (see "Accuracy Against the Diff")
3. **Missing subject grounding**: the body describes a bug or behavior before
   the reader can tell what part of the system it belongs to (see "Ground the
   Subject")
4. **Unparseable titles**: stacked nouns, bare identifiers, or non-universal
   acronyms (see "Title Guidelines")
5. **Paragraphs that should be bullet lists**: a paragraph of parallel,
   reorderable facts written as prose, two items included (see "Narrative or
   Bullets")
6. **Detail the reader does not need**: a passage that is plain and correct but
   still says what the diff already shows, or a body longer than the change
   warrants (see "Pass 2")

Then re-read the message against every rule section in this guide. If the title
changed since Pass 1, count it again. If issues are found, refine the message to
address them.

The following rules are non-negotiable, whatever the checks above turn up:

- The "why" is accurate, and you asked the user for it when it was not known.
- Every claim is verifiable in the full diff.
- There is no AI attribution anywhere in the message.

## Write for a Human Reader

Write the body at the altitude of system behavior, not code mechanics. The
reader is a teammate skimming `git log` to understand how the product changed,
not someone stepping through the code. The technical depth lives in the diff;
the message explains the change in plain English.

- Describe what the system does differently, not how the code accomplishes it.
- Don't narrate code mechanics visible in the diff: chains of method calls, data
  flow between variables, or internal structures as the actors of sentences. If
  a sentence only makes sense with the code open, rewrite it at the level of
  what behavior changed.
- Human-readable does not mean less informative. When the change depends on a
  concept that is not commonly known (an advisory lock, what a library exists to
  do, a framework mechanism), explain the concept in plain terms rather than
  assuming knowledge or dropping it. Cut code mechanics, not ideas.
- Don't over-explain benefits that are obvious from the change itself.

This is the most frequent failure mode. When in doubt, the message is too
technical, not too plain.

### Naming code in the message

Before naming a method, class, file, or internal key, ask whether a teammate
skimming `git log` would recognize it without opening the diff.

- Name it when the reader would search for it (a job, an endpoint, a well-known
  class), or when the change cannot be identified without it. Then explain its
  behavior in plain words: identifiers should anchor the message, not carry it.
- Being the subject of the sentence is not enough to earn a mention. A private
  helper the reader has never heard of is better described by what it does, or
  through what a user does and what they see. A parameter added to such a helper
  is almost never worth naming; a signature change is code mechanics even when
  the identifier is the subject.
- Use backticks around any identifier you do name: component, function, class,
  file, and variable names (e.g., `UserProfile` component, `constants.ts` file).

## Ground the Subject

Before any behavior is described, the reader must know what part of the system
it belongs to and what role that part plays. The title can carry some of this,
and a plain-language subject ("the skills form") is often better grounding than
a class name. Name a specific class or job when the change lives in one and the
title doesn't already establish it.

The failure mode is opening with a mechanism the reader can't place, like
"`attach(io: ...)` writes the blob and attachment rows..." with no indication of
whose code that is.

The first mention of any subject should be specific enough to identify it
without surrounding context ("the system tests for resume parsing", not "the
system tests"). After the subject is established, pronouns and generic terms are
fine.

## Accuracy Against the Diff

Every factual claim must be verifiable in the actual diff, read in full. Do not
describe behavior you have not confirmed in the code, and do not carry over
claims from an earlier draft of the change. After a squash or rebase, re-check
every "previously" or "now" statement: it may describe an intermediate state
that no longer exists anywhere in the history.

## Narrative or Bullets

**The reorder test decides.** If the sentences in a passage could be reordered
without changing the meaning, they are parallel facts and belong in a bullet
list. If each sentence depends on the previous one (problem, solution, benefit,
causation), they belong in prose.

### When the facts are causal, write a narrative

The body must read as a coherent narrative, not a list of disconnected
observations. Connect sentences so the reader understands the causal chain: what
situation existed, why it was a problem, and how the change addresses it. Each
sentence should flow from the previous one.

**Bad** (disconnected facts):

```
This switches from the `company_multi_source/enrich` endpoint to
`company_clean/enrich`, requesting only the two fields the app needs.
Response keys are now plain strings instead of symbols.
```

**Good** (narrative):

```
The app only needs two fields from Coresignal, but
`company_multi_source/enrich` returns a large, unnormalized payload
at 2 credits per request. This switches to `company_clean/enrich`,
which provides standardized data at half the cost, and passes a
`fields` parameter to request only what the app needs.
```

The bad version lists what changed as disconnected observations; each sentence
could be removed without affecting the others. The good version builds a causal
chain: the situation, why it was a problem, and how the change addresses it.

Do not force parallel facts into prose with fake connective tissue.

### When the facts are parallel, write a list

- **Use bullet points** whenever the body enumerates parallel behaviors,
  features, or design decisions, including a list of two. The reorder test
  decides, not a minimum count: two parallel causes belong in a list just as
  three do. This applies whether the parallel items are packed into one sentence
  ("The module does A, does B, skips C when D, and catches E") or spread across
  a paragraph as one sentence per item. Both read as a wall of text and should
  become a bullet list under a short intro sentence.
- Each bullet must be a grammatically complete sentence with a subject and verb.
  A fragment like "- Replaces X with Y" is acceptable only when an explicit
  intro sentence clearly supplies the subject (e.g., "Two functions are
  updated:"). When in doubt, make the subject explicit.
- In bullet points, describe what code or components DO (present tense), not
  what was added or created (past tense).

## The "Why" is Required

The code diff shows _what_ changed. The commit message must explain _why_ it
changed. If the motivation, context, or business reason behind a change is not
obvious from the code alone, **you must ask the user** before writing the
message. Do not guess or leave the "why" out.

Questions to determine if you know the "why":

- Can you explain the motivation for this change without speculating?
- Would a reader understand not just what happened, but why it was worth doing?
- Is there a business reason, user-reported problem, or technical constraint
  driving this change that isn't visible in the diff?

If any answer is no, ask the user before drafting.

State the "why" as a property of the code, never the process that surfaced it.
Not "a code review flagged the duplication", but "the logic was duplicated in
five places".

## Title Guidelines

The title must be unambiguous on first read. If it can be parsed in more than
one way, restructure it. Focus on "what/why" rather than "how".

### Form

- Use imperative mood ("Add feature" not "Added feature" or "Adds feature")
- Drop articles (a, an, the). Titles use headline style, so write "Submit job
  posting form as JSON", not "Submit the job posting form as JSON". This applies
  to every title, not only the ones that exceed the character limit. Keep an
  article only when removing it changes the meaning or makes the title
  ambiguous.
- The title should read as a natural phrase or near-sentence that makes sense in
  plain English, not just a string of technical terms
- The title should give the reader the most useful information within 50
  characters

### What the title must establish

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
- Name the page or feature a generic element belongs to. "Hero section", "stats
  bar", and "section header" read as global when they belong to one page: write
  "Redesign profile hero with unified edit modal", not "Redesign hero section
  with unified edit modal".
- Say when the change is test infrastructure. "Stop leaking Vite servers when
  startup times out" reads as a production leak; "Stop leaking Vite servers
  during system tests" does not.

### Wording to avoid

- Avoid stacked-noun phrases that are hard to parse. "Fix roles endpoint in find
  talent loader" reads as word soup because "find talent loader" has no
  grammatical signposts. Add words or restructure until the parse is
  unambiguous.
- Never use an acronym in the title unless it is universally known (API and URL
  are fine; SSRF is not). Use plain words in the title and spell out the acronym
  in the body.
- Prefer plain words over bare code identifiers in the title. A title built
  around an identifier (e.g., "Fix variant_urls") assumes the reader already
  knows what it refers to. Use an identifier when the message cannot be conveyed
  effectively without it; otherwise describe the thing in plain words and let
  the identifier appear in the body.

### Shortening an over-long title

Articles are already gone under the Title Guidelines, so if the title is still
over 50, shorten by:

- Using shorter synonyms (e.g., "Add" instead of "Implement", "Let" instead of
  "Allow")
- Removing scope qualifiers if the change is obvious from context

## Body Structure

Before drafting, state the type of commit you've identified: bug fix, feature,
enhancement, refactor, performance, test, documentation, dependency,
configuration, or cleanup. This forces a decision about what the message must
explain.

For simple, self-explanatory changes of any type, one or two sentences on what
changed and why is enough. Otherwise the shape depends on whether the commit
fixes something or adds something. Both shapes open the same way: establish what
part of the system is changing, unless the title already does.

**When the commit fixes or changes existing behavior** (bug fix, refactor,
performance, cleanup, and most configuration changes), lead with the problem:

1. What the code did before, and why that was wrong or costly. For bug fixes,
   give the impact and the root cause.
2. What the change does.
3. The benefit, only when the first two do not already show it.

**When the commit adds something new** (feature, test, documentation,
dependency), lead with the thing itself:

1. What the commit adds, and what a user or the system can now do.
2. Why it was needed. For a dependency, this is the feature need, the security
   patch, or the deprecation. For a test, it is what the test protects.
3. Anything the reader would otherwise get wrong, such as a limit or an excluded
   case.

An enhancement takes whichever shape fits: lead with the problem when it removes
a limit the reader would recognize, and with the thing itself when it extends
what the code already did well.

Do not invent a problem to fill step 1 of the first shape. An addition with no
prior fault has no "before", and writing one produces a false claim. For the
same reason, when a commit continues a feature an earlier commit started, do not
write the intermediate state as a bug: not "the sidebar disappeared", but what
the previous commit did, what it did not cover, and what this commit adds.

Don't reference other commits unless directly relevant. The commit above is the
one case where it is: the earlier commit is the motivating context.

## Sentences and Word Choice

### Sentence construction

- **Grammar**: Every sentence must be grammatically complete with a subject and
  verb. Sentence fragments are not acceptable. Use proper subject-verb
  agreement, punctuation, and sentence structure.
- **Active voice**: Write in active voice with clear actors performing actions.
- **Sentence complexity**: Check if any sentence expresses more than two ideas.
  If a sentence has multiple subordinate clauses (using "when", "because",
  "while", "causing", "resulting in"), it likely expresses too many ideas and
  should be split into separate sentences for clarity.
- **Run-on sentences**: Check for multiple independent clauses joined by commas.
  These should be split into separate sentences.
- **No em dashes**: Never use em dashes. Use a semicolon, colon, comma, or
  period as the grammar requires, or restructure the sentence.
- **Articles**: Body text keeps "a", "an", and "the". Titles drop them; see
  Title Guidelines.
- **Noun clusters**: Do not stack more than three nouns, in the body or the
  title.

### Word choice

- **Use the names the code uses.** If a word appears in the code, the API, the
  database, or the UI, it is the right word in prose about that code. Don't
  paraphrase it into something the reader has to translate back.
- **Replace summary phrases with the fact they summarize.** "The distinction
  stays internal" says nothing; "nobody outside those roles sees the
  difference" says who and what.
- **Say the literal thing.** Use the ordinary verb for what happens: the page
  shows a message, the request timed out, the logic is duplicated in five
  places. A figurative substitute ("names the wait", "pays the timeout",
  "duplicated across five surfaces") makes the reader decode a metaphor to reach
  the fact. This covers verbs of addition too: prefer "adds" or "now supports"
  over "`Foo` gains a `bar` option".
- **Vague or subjective language**: Avoid subjective terms without concrete
  benefits ("improve", "better", "comprehensive", "enhance", "modernize") and
  vague verbs ("adjust", "update" when more specific terms apply).
- **Invented terminology**: Do not coin a phrase and present it as if it were an
  established term of art. If a concept has a standard name, use that name; if
  it doesn't, describe the concept in plain words instead of naming it. Test: if
  a teammate searched for the phrase, would they find anything? If not, the
  phrase is doing fake authority work and should be unpacked into a plain
  description.
- **"This commit" phrasing**: "This commit does X" is acceptable whenever it
  reads naturally. Do not strip it as a default editing step. Rephrase only when
  leading with the subject being changed ("The hook...", "The guide...") is
  clearly better, not merely possible.

## Examples

The first four show a fault and its fix. The last four show a correct message
for a given shape or size. One more pair sits under "Narrative or Bullets",
where it demonstrates causal order.

### Too technical (what NOT to do)

```
Dedupe skills before saving talent profile

`SkillsForm` builds `selectedSkills` by concatenating `initialSkills`
with the array returned from `useSkillSearch`, then maps over the
result to build `skillIds` for the `PATCH` payload, so the same id
could appear twice when a skill was both preloaded and re-selected.
The `useMemo` now wraps the concatenation in `uniqBy`.
```

_Issue: This narrates code mechanics. Variables and hooks are the actors of
every sentence, and a reader needs the code open to follow any of it. None of it
explains what a user or the system experienced._

**Better version:**

```
Dedupe skills before saving talent profile

The skills form let the same skill be added twice, once from the
profile's existing skills and once from search results. Saving the
profile then failed validation on the duplicate. The form now
removes duplicates by id before submitting.
```

The better version names the code under change (the skills form), then describes
the behavior entirely in plain English. The diff carries the implementation.

### Bug fix without subject grounding (what NOT to do)

```
Save attachment to db only after upload succeeds

`attach(io: ...)` writes the blob and attachment rows before
uploading to the storage service. If the upload then failed,
the DB was left pointing at a missing remote file.
```

_Issue: A reader who hasn't seen the diff doesn't know what code path this is
in. Is `attach` being called from a controller? A job? Which job? Name the
subject before describing its behavior._

**Better version:**

```
Save attachment to db only after upload succeeds

`AttachFileJob` downloads a file from a remote URL and attaches it
to a record. The previous implementation used Active Storage's
`record.attach(io: ...)` form, which writes the blob and attachment
rows before uploading the file. If the upload then failed, the DB
was left pointing at a missing remote file.

This commit uploads the file first and only creates the blob and
attachment records once the upload has succeeded.
```

### Vague and subjective (what NOT to do)

```
Make file extension validation case-insensitive

This commit comprehensively enhances resume upload validation and
improves the user experience. It modernizes how the code handles
file extensions, so uploads work better than before.
```

_Issue: Subjective terms carry the whole body ("comprehensively", "enhances",
"improves", "modernizes", "better"). Every one of them is a claim the reader
cannot check, and none of them says what the code now does differently._

**Better version:**

```
Make file extension validation case-insensitive

Resume file uploads were rejecting valid PDFs, because the MIME type
check compared file extensions case-sensitively. A file named
"document.PDF" failed validation while "document.pdf" passed. The
check is now case-insensitive.
```

### Run-on sentence with an over-explained benefit (what NOT to do)

```
Retry failed webhook deliveries

The webhook sender was giving up after the first failed delivery,
which meant a subscriber that restarted during a send lost the event
permanently, and since subscribers restart during every deploy this
was happening often, so the sender now retries three times with
backoff, which makes deliveries much more reliable for subscribers.
```

_Issue: One sentence carries five clauses joined by commas. The closing benefit,
that retries make delivery more reliable, restates what "retries three times"
already says._

**Better version:**

```
Retry failed webhook deliveries

The webhook sender gave up after the first failed delivery. A
subscriber that restarted mid-send lost the event permanently, and
subscribers restart on every deploy. The sender now retries three
times with backoff.
```

### Bug fix (problem-first shape, narrative structure)

```
Fix memory leak in WebSocket connection handler

The WebSocket connection handler registers event listeners when a
connection opens. They were never removed when the connection
closed, so references accumulated and the application leaked memory
whenever connections closed unexpectedly.

This commit removes event listeners in the cleanup function and adds
a guard to prevent duplicate listener registration.
```

### Feature (additive shape, with bullet points)

```
Add dark mode support to dashboard

The dashboard now has a theme toggle to help reduce eye strain when
users work in the evening:

- The toggle switches the dashboard between the light and the dark
  color scheme.
- Every dashboard component follows the selected scheme.
- The browser remembers the choice between visits.
```

The first sentence carries both what the dashboard can now do and why. There is
no "before" paragraph, because nothing was broken. The three behaviors are
parallel and pass the reorder test, so they are a list, and each bullet is a
complete sentence.

### Complex change (several causes, one outcome)

```
Increase and fix timeouts for TDE requests

The base `ExternalApi::Client` class sets a 60s timeout for both opening
connections and getting responses. The TDE client was previously
intending to override these default timeouts on a per-request basis to
10s. This was problematic for three reasons:
- The override was not having any effect on the read timeout, because
  the code was calling `#timeout=` on the request options instead of
  `#read_timeout=`.
- Getting recommendations now involves a multi-step pipeline that can be
  very slow. We actually need to increase the timeout to 90s, not
  decrease it to 10s.
- There is no reason to override the timeout for opening connections.
  That should be relatively short in all instances, not specific to TDE.

This commit fixes the timeout override bug and updates timeouts to:
- 90s for recommendations `read_timeout`
- 30s for match analysis `read_timeout`
- 10s for all `open_timeout`

In addition, we now calculate the refresh interval for ID tokens used to
communicate with TDE based on the timeout values that are set. This was
previously hardcoded, and no longer sufficient with the new timeouts.
```

A long body is right here because the change has three independent causes, and a
reader who knows only one of them would misread the commit. Length follows from
the number of independent facts, not from the size of the diff. Do not pad a
single-cause change to look like this one.

### Simple change (dependency)

```
Update Node.js version requirement to 18+

The minimum Node version is now 18. Node 16 reaches end-of-life next
month and stops getting security patches.
```

Two sentences carry a one-line change. The reader does not need a paragraph on
why security patches matter.

## Common Requirements

- NEVER update git config
- NEVER use interactive git commands (-i flag)
- Use HEREDOC format for commit messages to ensure proper formatting
- Write commit messages as if they were written entirely by the human developer
- NEVER add `Co-Authored-By: Claude` or any AI attribution - commit messages
  must have no mention of AI assistance whatsoever
