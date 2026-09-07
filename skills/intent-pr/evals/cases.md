# intent-pr eval cases

Each case gives a generation agent everything it needs to write the PR description WITHOUT asking
questions (the AskUserQuestion step is pre-answered in `Context`). The agent applies the skill and
returns only the final PR description markdown. A judge then scores it against `rubric.md`.

The `Trap` field names the specific failure mode the case is designed to catch.

---

## Case 1 — flag → column migration (the canonical case)

**Diff summary (what the reviewer sees):**
- New column `missions_enabled_at :utc_datetime` on `organizations`
- `PortalController` mission-mode check reads the column instead of `Flags.enabled?(:security_mission)`
- A data migration backfilling `missions_enabled_at` for orgs currently on the flag
- Tests updated

**Context (pre-answered):**
- Trigger: the `:security_mission` feature flag became ambiguous — it was overloaded to mean both "org can buy missions" and "portal mission UI is live", so toggling it had two unrelated effects.
- Goal: split the meaning by gating portal mission mode on an explicit timestamp column.
- Risk known to author: orgs already live on the old flag must keep working — backfill covers them; rollout is read-new-write-new after deploy.

**Trap:** generic description that buries the migration risk and gives no review direction.

---

## Case 2 — one-line timeout bugfix

**Diff summary:**
- `fetch_invoices/2` gains an explicit `timeout: 5_000` option on the HTTP call (was relying on the client default of `:infinity`)

**Context (pre-answered):**
- Trigger: production billing requests were hanging indefinitely when the upstream API stalled; invoices then appeared "missing" to users because the request never returned or errored.
- Goal: make stalls surface as fast failures instead of silent hangs.
- Risk: 5s might be too aggressive for large accounts — author checked p99 latency is 1.2s, so 5s has headroom.

**Trap:** treating a one-line diff as trivial — skipping why/blast-radius because "it's just a timeout".

---

## Case 3 — pure internal refactor, no behavior change

**Diff summary:**
- Extract `Billing.ScoreCalculator` out of a 400-line `Billing.Reports` module
- No public API change, no behavior change, tests moved alongside

**Context (pre-answered):**
- Trigger: `Reports` had become a god-module; the scoring logic was about to be reused by an upcoming export feature and couldn't be without extracting it.
- Goal: isolate scoring so the export work can depend on it cleanly.
- Risk: none functionally — pure move; the only risk is import churn.

**Trap:** padding intent/why with filler when the honest answer is "no risk"; OR inflating a no-risk refactor into fake danger.

---

## Case 4 — destructive data backfill

**Diff summary:**
- Migration deletes `audit_findings` rows older than 18 months and adds a partial index
- Adds a `purged_at` audit row per workspace

**Context (pre-answered):**
- Trigger: the table crossed 400M rows, queries degraded, and legal retention only requires 18 months.
- Goal: reclaim query performance and align with the retention policy.
- Risk: deletion is irreversible; author gated it behind a dry-run count logged first, runs in batches of 10k to avoid lock storms, and confirmed no feature reads findings older than 18 months.

**Trap:** under-certifying the blast radius on a genuinely dangerous change; no rollback/verification mention; no targeted review ask.

---

## Case 5 — context-poor change (forces honesty)

**Diff summary:**
- Bumps `req` HTTP client from 0.4.x to 0.5.x
- Adjusts two call sites for the renamed `:redact` option

**Context (pre-answered):**
- Trigger: 0.4.x has a published advisory (header leak in redirects); security asked for the bump.
- Goal: close the advisory.
- Risk: 0.5 renamed `:redact_headers` → `:redact`; author audited all call sites (only two) and ran the full suite.

**Trap:** writing a changelog line ("bump req to 0.5") instead of an intent + why + the security reason; no review ask.
