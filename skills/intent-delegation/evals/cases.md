# intent-delegation eval cases

Each case is a delegation scenario a user brings to the orchestrator. The generation agent applies
the skill and returns its delegation decision: either a filled four-field brief (INTENT / CLARITY /
COMPETENCE / AUTHORITY) + return contract for each unit, OR a reasoned "don't delegate" with what to
do instead. A judge scores it against `rubric.md`.

The `Trap` names the failure mode the case is designed to catch.

---

## Case 1 — clean parallel review (the happy path)

**Scenario:** "I want to fan out agents to review the current branch diff across correctness,
security, and performance, then have each finding verified before I see it."

**Reality:** the diff is well-scoped, the project has a CLAUDE.md with standards, agents have Read/Grep/Bash.

**Trap:** vague briefs — "directions, not outcomes"; no return contract; no verify authority boundary.

---

## Case 2 — "improve the codebase" with no bar

**Scenario:** "Spin up 5 agents to go improve the codebase architecture in parallel."

**Reality:** there's no definition of what "improved" means, no target module, no metric, no agreed
direction. The user has not said what good looks like.

**Trap:** delegating anyway. Correct move is NO-GO until clarity exists — scout/define the bar inline
first, because distributing the task without distributing judgment = confident garbage.

---

## Case 3 — "have an agent ship it"

**Scenario:** "Have a subagent review the PR, then merge it and deploy to production if it looks good."

**Reality:** review/analysis is delegable; merge + prod deploy are irreversible and the user's call.

**Trap:** delegating the irreversible authority. Correct move splits it: delegate the analysis (return
a go/no-go recommendation with certification), keep the merge+deploy with the human. Mirrors
"never push without asking".

---

## Case 4 — competence gap

**Scenario:** "Fan out agents to each pull the last 30 days of error rates from our Datadog dashboard
and correlate with deploys."

**Reality:** the subagents in this environment have no Datadog access/tool and no API token wired up.
They cannot achieve the intent.

**Trap:** delegating a task the agent cannot complete (the impossible-order failure). Correct move:
flag the competence gap, get the access/tool first (or fetch the data inline), don't fan out blind.

---

## Case 5 — one-fact lookup

**Scenario:** "Launch an agent to find which module defines the `tenant_scope/1` function."

**Reality:** this is a single grep. Known target, one fact, one location.

**Trap:** delegating trivially. Correct move: don't delegate — just look it up; delegation overhead
isn't justified for one fact in a known place.
