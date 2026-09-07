---
name: intent-delegation
description: Structure agent delegation the intent-based way before any fan-out — define each subagent's intent, clarity, competence, and authority boundary so it decides well locally instead of guessing or escalating everything. Use when designing a Workflow, writing a subagent/Task prompt, fanning out parallel agents, or when a delegated agent returns plausible-but-wrong work or keeps asking permission.
---

# Intent-based delegation

From L. David Marquet, *Turn the Ship Around!*: **move authority to the information, don't move information to authority.** A subagent has the local information; the orchestrator should push decision authority *down* to it — but only after two preconditions are met. Marquet's law: **you can only distribute control as far as you've distributed competence and clarity.** Skip either and delegation produces confident garbage (no clarity) or silent failure (no competence).

Use this BEFORE you write the agent prompt or the `Workflow` script — it's a pre-flight, not a review.

## The delegation brief — four fields per agent

For every subagent or fan-out unit, fill all four. If you can't, you're not ready to delegate.

```
INTENT     The outcome in one line, as a decision/product — not a direction.
           ✘ "Look at the auth module."   ✔ "Determine whether any auth path skips the tenant check; return each gap."
CLARITY    The context + decision criteria the agent needs to choose well without you.
           Not just facts — the *why* and the bar for "good". An agent that knows the goal
           makes the call you'd make. One that only knows the task guesses.
COMPETENCE The tools/data/access required to actually achieve the intent.
           If the agent lacks them, grant them or don't delegate. Never delegate a task
           the agent cannot complete — that's the impossible-order failure.
AUTHORITY  What it may decide alone vs. must surface. State BOTH sides — the positive
           ("may decide X, run Y") and the negative ("surface Z, don't act"). A boundary
           written only in the negative gives no autonomy. The "I intend to…" line:
           reversible/in-scope → decide and proceed; irreversible/ambiguous → surface, don't act.
```

Every stage gets its own brief — a synthesis, verify, or dedup step is a delegated unit too, and needs its own AUTHORITY line. Don't let a downstream stage inherit "no boundary".

## Return contract — certify, don't dump

Tell the agent to return a **certified result**, not a raw dump: its conclusion, its confidence, and explicitly *what it could not verify*. "Obedient" agents that report success they didn't check are the silent-failure mode.

Give a **concrete field schema**, not a prose description of one — and define what each confidence level means (don't leave "medium" to the agent's taste). With `Workflow`/`Task`, pass an actual `schema` so the conclusion is forced, not narrated. Minimum fields: `conclusion`, `confidence`, `unverified` (mandatory — a missing `unverified` is itself a silent failure).

## When NOT to delegate

- **Clarity is missing and unwritable** — you don't yet know the bar for "good". Scout inline first, then delegate.
- **Competence is absent** — the agent has no tool/access for the intent. Fix that first.
- **The decision is irreversible and yours** — don't delegate the authority, only the analysis. (Mirrors: never push without asking — delegate the diff read, keep the merge.)
- **One fact, known location** — just look it up. Delegation has overhead.

## Anti-patterns this catches

| Symptom | Missing field |
|---|---|
| Agent returns plausible-but-wrong work | Clarity (it guessed the bar) |
| Agent asks permission for everything | Authority (boundary never set) |
| Agent reports done but it isn't | Return contract (no certification) |
| Agent fails silently / can't proceed | Competence (no tools/access) |
| Five agents, vague overlapping output | Intent (directions, not outcomes) |

## The test

Before launching: *could this agent make the decision I would make, with what I gave it?* If no — add clarity or competence until yes, or don't delegate. Distributing the task without distributing the judgment is leader-follower in disguise.
