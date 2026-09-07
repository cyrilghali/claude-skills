---
name: rewrite-commits
description: Collapse a draft PR's noisy iteration commits into 1-3 atomic commits before review.
disable-model-invocation: true
---

# rewrite-commits

Iteration with an LLM — and your own evolving decisions — produces branches with 5-15 small commits like "rename X", "tighten threshold", "drop Y", "trim tests", "restore Y". This skill collapses that noise into 1-3 atomic commits that map to logical units of change, so reviewers see the *result* of the thinking, not the thinking itself.

## When to trigger

- After heavy back-and-forth iteration on a draft PR, before flipping ready-for-review
- When a draft PR's `git log` reads like a stream of consciousness instead of a feature

## When NOT to trigger

- The PR has reviews (force-push will lose review-thread anchors and surprise reviewers)
- The branch is `main`, `staging`, `master`, or any shared protected branch
- The branch is open as non-draft and has been visible to reviewers for a while
- The user has explicitly asked to keep the commit-by-commit history

## Pre-checks (run these first; refuse if any fails)

1. **Branch ahead of base** — `git rev-list --count <pr-base>..HEAD` returns ≥ 2.
2. **Branch is the user's own** — current branch isn't `main`/`staging`/`master`.
3. **Working tree clean** — `git status --porcelain` returns empty.
4. **PR is draft (or no reviews)** — `gh pr view --json isDraft,reviews` shows `isDraft: true` or `reviews: []`. If non-draft with no reviews, warn but allow.
5. **Determine the PR base** — usually `<remote>/<base-ref>` from `gh pr view --json baseRefName`. For stacked PRs, this may be another feature branch.

## Process

### 1. List the noise

```bash
git log --oneline <pr-base>..HEAD
```

Show the user how many commits are about to be collapsed.

### 2. Group commits into atomic units

Most PRs collapse into 1-3 commits along these lines:
- **Plumbing / data flow** — migrations, schema changes, threading values through job args
- **Behavior** — the user-facing or system-facing effect (alerts, UI, API change)
- **Tests** — only as a separate commit if pure test additions to existing code

Walk the diff (`git diff <pr-base>...HEAD --stat`) and propose the commit structure to the user with subjects. Get approval before executing.

### 3. Execute the rewrite

```bash
# 1. All current changes become staged against the PR base
git reset --soft <pr-base>

# 2. Unstage everything so we can re-stage selectively
git restore --staged .
```

For each planned commit:

```bash
# 3a. Stage the files belonging to this commit
git add <file1> <file2> ...

# 3b. For partial-file commits (file split across two commits):
#     Edit the file to its commit-N state via Edit tool,
#     stage it, commit, then Edit forward to commit-(N+1) state for the next round.
#     Never use `git add -p` (interactive flag, blocked).

# 3c. Commit
git commit -m "<subject>" -m "<body>"
```

### 4. Force-push

```bash
git push --force-with-lease
```

Use `--force-with-lease` (not `--force`) so a concurrent push from elsewhere isn't silently overwritten. The PR retains its number, description, and labels — only the commit list changes.

### 5. Report

Show the user the new `git log --oneline <pr-base>..HEAD` so they can confirm the result.

## Constraints

- **Never use** `git rebase -i` or `git add -p` — interactive flags are blocked. Work via `reset --soft` + selective `git add` + Edit-based file shaping for partial-file commits.
- **Never rewrite history on shared branches** (main, staging, master). The skill's pre-checks must enforce this.
- **Always confirm the commit structure** with the user before force-pushing. Even in auto mode — the structure is a judgment call only the user can make.
- **Use `--force-with-lease`**, never `--force`.
- **Keep the PR description intact** — only the commits change. If the PR description references commit shas or counts, flag that to the user before force-pushing.

## Why this exists

Code review focuses on the diff and the messages explaining it. Iteration commits document the *author's* journey, not the *reviewer's* path through the change. A clean atomic history:

- Lets reviewers read the PR commit-by-commit and trust each step
- Bisecting a regression lands on a meaningful unit, not a "rename" or "tweak threshold"
- The PR's git log becomes the changelog for its feature
- The author's hesitations, false starts, and corrections stay private (where they belong)

Iteration is fine. Shipping iteration is noise.
