---
name: dense-brief
description: Answer an expert's question at maximum information density — select for intent first (every clause must have a job the reader can name; cut what their next click would show them), then compress into one load-bearing sentence structured by punctuation, every claim anchored to a verifiable identifier, next follow-ups pre-folded as clauses. Use for quick factual questions in a loaded project context ("explain in 1 sentence", "which X", "why Y"), status pings, and any answer where the reader has full context and wants zero ceremony.
---

# Dense brief

The register for answering someone who already has the project in their head: compress to the edge of parseability, never past it. Word count is bought with punctuation and shared vocabulary, not with omission — the answer still contains the mechanism, the caveat, and the number.

## Move zero — intent before density

**Selection comes before compression, and it is the harder discipline.** Every clause must have a job the reader could name: change a decision, direct attention, certify a risk, unblock an action. Apply the test *before* compressing: "if the reader asked *why are you telling me this?*, does the clause contain its own answer?" A clause whose only qualities are being true, verifiable, and well-compressed is **noise with good posture** — density makes purposeless information *cheaper to ship, not worth shipping*. This is the register's characteristic failure mode: the five moves below make you efficient at transmitting whatever you selected, so a selection error doesn't look like rambling (which the reader would catch) — it looks like rigor. Concretely: restating what the reader's next click will show them (the diff, the file, the dashboard) always fails the test; what you decided, measured, rejected, or need from them always passes. When a clause fails, cut it — compressing it is how the failure survives review.

## The five moves

1. **One sentence, punctuation as structure.** Em-dashes pivot (claim — mechanism — caveat); parentheticals carry qualifiers. The sentence holds 4–6 facts because its skeleton is typographic, not syntactic.
   > "#19007 delivers the first three dashboard metrics — workforce exposed, total detections by policy, remediated over time — by aggregating the `policy_detection_events` journal on a new endpoint (replica reads, double feature-flag gate, trends null until a full live-era previous window exists)."

2. **Layered qualification, fixed order.** *By design → but in practice → in today's data → until X lands.* Each layer narrows the previous one; the reader always knows which regime a fact belongs to.
   > "policy-agnostic by design — but in practice fed by the three task-generating policies — and in today's prod data effectively two — alert-only kinds won't appear until their seams land."

3. **Every claim carries its identifier.** Exact counts (20.6k), exact routes, exact atoms, PR numbers, dates. A generality ("most of the volume") is a claim the reader can't check; an identifier is one they can.

4. **Calibrate vocabulary to the reader, unpack nothing.** Use the project's own words (seams, journal, live-era) exactly as the codebase/tickets use them. Defining a term the reader coined is noise.

5. **Pre-fold the next question.** Anticipate the 1–2 follow-ups the answer will trigger and attach them as trailing clauses — the "but in practice" and "until" layers usually are those follow-ups.

## The one guardrail

The edge is a re-read: if a clause forces the reader back to the start of the sentence, the compression failed — split into two sentences and keep the density, or drop the least load-bearing qualifier. Telegraphic fragment-lists are allowed only inside one parenthetical per answer; two is a chain.

## When not to use

- Explanatory or comparative documents → `doc-pedagogique` (its audience discovers the subject; this register assumes the opposite).
- PR bodies → `intent-pr`: the body is one sentence, so there is nothing to compress. This register belongs in the *session certification* that accompanies it, under one constraint — every clause must carry something **the diff cannot show** (a decision, a measurement, a constraint, a cross-PR interaction). A clause that compresses what-changed is still a brief, and dense-brief makes that failure *efficient*, not acceptable.
- Any reader without the shared context — the vocabulary calibration (move 4) is what makes this register fast, and it's exactly what makes it unreadable to outsiders.
- Bad news, disagreement, or decisions needing buy-in — density reads as curtness there; switch to plain prose.
