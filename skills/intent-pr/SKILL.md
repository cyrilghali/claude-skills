---
name: intent-pr
description: Write an intent-based PR — a one-sentence `## Why` body, with the full risk certification delivered to the author in session rather than in the PR. Use when asked for an "intent-based PR", "certify a PR", a PR that "directs the reviewer", or when a PR body should make review faster instead of dumping a diff summary.
argument-hint: "[branch] [repo]"
---

# Intent-based PR description

A PR is the **"I intend to…"** moment of code (L. David Marquet, *Turn the Ship Around!*). The author who has the context announces intent and *certifies* the risks; the reviewer's job collapses from reconstructing the change to **validating or blocking the intent**. Approval becomes almost mechanical — not because work was hidden, but because the author already did the reviewer's thinking.

Certification and PR body are two different artefacts. The certification is long-form and goes to the author in session (voice and format: `CLAUDE.md`, "Certification voice"). The PR body is one sentence.

## The body — one sentence under `## Why`

```markdown
## Why

Gate portal mission mode on `missions_enabled_at` instead of the `:security_mission` flag, so a workspace opts in explicitly (PLA-2535).
```

That is the whole body. It carries the intent as `[verb] [goal]` + ticket ref, and nothing the diff already shows. A full certified body was cut as far too verbose: the density belongs in the session reply, where the author reads it.

Add a further section only when the author asks for one. When they do, it is one-sentence bullets and it climbs the cut ladder below first.

**Repos avec un gate sur le corps de PR** : le gate exige un `## Why` **visible**, c'est la section d'intention, tout contenu « Objectif » fusionne dedans. Un `<!-- ## Why -->` en commentaire HTML contourne le gate : un gate contourné est un gate menti. Passe le corps en `--body-file`, après la passe `prose` sur la phrase.

**Le lecteur est l'équipe.** La ligne s'adresse aux reviewers humains. Le processus agent↔auteur (« my implementation agent », « before handover », « my run ») reste en session ; une question déjà tranchée en pré-review disparaît du corps.

## Process

1. **Read the diff and any linked Linear issue** (`INB-`, `PLA-`, `SON-`, …). Use the ticket for motivation and links; the description is your sentence, not its paste.
2. **Gather context if missing** — `AskUserQuestion`, one question at a time, motivation first, stop at 2–3. Skip only if the conversation or ticket already answers it. A one-line diff still needs its why.
3. **Write the sentence**, then the session certification: what you checked, folded with the risk it covers, closing on the 1–2 things you want scrutinised.
4. **Run the decisive test** below. Open PRs as `--draft`.

## The decisive test

*Could a reviewer approve from the sentence plus the diff, without reconstructing the intent?* If they would have to hunt for why the change exists, the sentence failed — rewrite it. Marquet's rule: "can you look at this?" is still leader-follower; the intent-based PR says "here's my intent — block if you see a hole."

## The cut ladder — for any section beyond the sentence

Bodies accrete over their life (review deltas, stack maps, status notes). Climb this before adding one; stop at the first rung that holds.

1. **The diff already shows it?** Delete. The body states intent; it never narrates changes.
2. **It doesn't change how the reviewer reads the diff?** Delete — status belongs in comments.
3. **A link can replace the content?** Link (ticket, doc, other PR).
4. **It's a re-review delta** ("since your last review")? Three lines max: what moved, why, where to re-look — the delta for the reviewer, not the work done.
5. **It's shared boilerplate** (stack map, project banner)? Script-generated, one screen max, identical everywhere.

Deletion over addition: a body a reviewer scrolls is a body that failed.
