# intent-pr scoring rubric

Score a generated PR description against the skill's contract. Each dimension is 0–2.
Return per-dimension scores, a total /18, a pass/fail (pass = total ≥ 14 AND no dimension = 0),
and one concrete rewrite suggestion per dimension scoring < 2.

| # | Dimension | 0 | 1 | 2 |
|---|-----------|---|---|---|
| 1 | **Intent present & well-formed** | Missing, or a noun phrase | Present but vague or restates the diff | One sentence, `[verb] [goal]`, names the decision not the mechanics |
| 2 | **Why = undeducible context** | Missing, or pure restatement of the diff | Present but thin or leaks implementation detail | Gives the trigger/motivation a reviewer could not infer from the code |
| 3 | **Blast radius certified** | Absent | Present but vague ("should be fine") | Names what could break AND what the author checked; "isolated, nothing risky" is full marks IF the change is genuinely safe |
| 4 | **Review ask is directional** | Absent, or "review everything" | Present but generic | Points the reviewer at the 1–2 things that matter most |
| 5 | **No micro leakage** | Names files/functions/modules, or enumerates changes | One slip | Stays macro throughout |
| 6 | **Not a brief / not a changelog** | Reads as "here's what I did" list | Mixed | Reads as a certification of intent + risk |
| 7 | **Decisive test** | Reviewer would have to reconstruct intent or hunt for risk | Partial | A reviewer could approve from the description alone and use the diff only to confirm |
| 8 | **Concision** | > ~200 words, or multi-sentence blast bullets / review-ask items | ~150–200 words, some padding or hedges | ≤ ~150 words, every sentence earns its place, bullets are one line each |
| 9 | **First-person certification voice** | Passive throughout ("tests were updated", "is green") | Mixed | Checks stated in first person ("I verified…", "I confirmed…") that vouch for the work |

## Case-specific must-checks

- **Case 2:** must NOT be skimped because the diff is one line — why and blast radius both required.
- **Case 3:** blast radius should honestly say "no functional risk" — penalize BOTH fake danger and filler padding.
- **Case 4:** blast radius MUST mention irreversibility + the safeguards (dry-run, batching, retention check). Missing any → dimension 3 capped at 1.
- **Case 5:** the security advisory is the real "why" — if it's written as a version-bump changelog line, dimension 6 = 0.

## Output format (return exactly this)

```
CASE: <n>
SCORES: 1:_ 2:_ 3:_ 4:_ 5:_ 6:_ 7:_ 8:_ 9:_
TOTAL: _/18
VERDICT: PASS | FAIL
WORD COUNT: _
FIXES:
- dim <n>: <one concrete rewrite suggestion>
```
