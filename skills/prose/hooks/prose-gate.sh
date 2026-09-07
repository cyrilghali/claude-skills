#!/usr/bin/env bash
# Prose gate (personal, all repos). One tripwire for the three prose skills:
# the mechanical half of the voice pass (AI tells), of the cold read (compression walls)
# and of decision-prose (register of a document). Replaces deslop-gate.sh.
#
#   prose-gate.sh stop   Stop hook: lint the reply Claude just wrote.
#   prose-gate.sh doc    PostToolUse hook on Write|Edit of a .md file and on
#                        the Linear save_document / save_issue tools: lint the
#                        document text that was written.
#
# Both modes: AI tells (delve, tapestry, "let's dive in", ...), emphasis and
# scaffolding words (verbatim, exactement, clairement, "Conséquence :", ...),
# em dashes, sentences over 40 words, paragraphs over 120 words outside
# tables, code and quotes. Doc mode adds the proof trail and session
# bookkeeping ("j'ai vérifié", "session du", "décision du 04/09") and a bold
# heading line that is not a question. Judgment calls (answer first, one why,
# what a cold reader lacks, false agency, rhythm) stay in the skills.
#
# Guardrails: fail-open on any missing input; in stop mode an attempt cap so a
# stubborn reply still gets through.
set -uo pipefail

SKILL_DIR=$(cd "$(dirname "$(readlink -f "$0")")/.." && pwd)
MODE=${1:-stop}
MAX_ATTEMPTS=2
MAX_SENTENCE=40
MAX_PARAGRAPH=120

input=$(cat)
command -v jq >/dev/null 2>&1 || exit 0

# ---------- collect the text to lint ----------
text=""
label=""
case "$MODE" in
  stop)
    transcript=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null) || exit 0
    [ -n "$transcript" ] && [ -f "$transcript" ] || exit 0
    # The last assistant message that carries text: the reply the user is about to read.
    # Lines cut by tail fail to parse and are dropped before the slurp.
    text=$(tail -n 400 "$transcript" 2>/dev/null \
      | jq -c 'select(.type == "assistant")' 2>/dev/null \
      | jq -rs '[ .[] | (.message.content // []) | map(select(.type == "text") | .text) | select(length > 0) | join("\n") ] | last // empty' 2>/dev/null)
    label="your reply"
    ;;
  doc)
    tool=$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null)
    case "$tool" in
      Write|Edit)
        file=$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
        case "$file" in
          *.md) ;;
          *) exit 0 ;;
        esac
        # Files the user never reads as documents: memory, skills, hooks, plans.
        case "$file" in
          "$HOME/.claude/"*|*/.claude/*|*/memory/*|*/CLAUDE.md|*/node_modules/*) exit 0 ;;
        esac
        [ -f "$file" ] || exit 0
        text=$(cat "$file")
        label="$file"
        ;;
      mcp__linear-server__save_document|mcp__linear-server__save_issue)
        text=$(printf '%s' "$input" | jq -r '
          .tool_input as $t
          | [ $t.content?, $t.description?,
              ($t.patch[]? | .new_string?, .text?) ]
          | map(select(. != null and . != "")) | join("\n\n")' 2>/dev/null)
        label="the Linear text you just saved"
        ;;
      *) exit 0 ;;
    esac
    ;;
  *) exit 0 ;;
esac

[ -n "$text" ] && printf '%s' "$text" | grep -q . || exit 0

# ---------- prose only: drop fenced code, quotes, tables, inline code, links ----------
prose=$(printf '%s\n' "$text" | awk '
  /^[[:space:]]*```/ { fence = !fence; next }
  fence { next }
  /^[[:space:]]*>/ { next }
  /^[[:space:]]*\|/ { next }
  { gsub(/`[^`]*`/, ""); gsub(/\]\([^)]*\)/, "]"); print }
')

findings=""
add() { findings="${findings}${findings:+
}- $1"; }

# 1. Emphasis and scaffolding words. Exact phrases: each one is a tell on its own.
tells='verbatim|corroborations?|exactement|clairement|simplement|évidemment|bien sûr|il est important de|à noter que|notez que|conséquence :|note :|attention :|en résumé|pour résumer|autrement dit|en d'"'"'autres termes|il faut savoir que|tout d'"'"'abord|crucially|importantly|it is worth noting|clearly|obviously|essentially|basically|in other words|to put it simply|note that|consequently'
hits=$(printf '%s\n' "$prose" | grep -oiE "(^|[^[:alnum:]])($tells)([^[:alnum:]]|$)" 2>/dev/null | sed -E 's/^[^[:alnum:]]+//; s/[^[:alnum:]:]+$//' | sort -fu | head -8)
[ -n "$hits" ] && add "emphasis or scaffolding words: $(printf '%s' "$hits" | paste -sd, - | sed 's/,/, /g'). State the point; the consequence leads, it does not get announced."

# 1b. AI tells, the VOICE.md list. Exact phrases: each one is a tell on its own.
ai='here'"'"'s the thing|the truth is,|let me be clear|here'"'"'s the kicker|here'"'"'s where it gets interesting|let'"'"'s dive in|let'"'"'s unpack|let'"'"'s break this down|without further ado|in today'"'"'s [a-z-]* (world|landscape)|it'"'"'s worth noting|at the end of the day|in a world where|let that sink in|make no mistake|that'"'"'s it\. that'"'"'s the|serves as a testament|delve|tapestry|multifaceted|holistic|groundbreaking|transformative|indelible|paramount|quintessential|showcases|fosters|garners|bolsters|spearheads|galvanizes|nexus|interplay|cornerstone'
ah=$(printf '%s\n' "$prose" | grep -oiE "$ai" 2>/dev/null | sort -fu | head -8)
[ -n "$ah" ] && add "AI tells: $(printf '%s' "$ah" | paste -sd, - | sed 's/,/, /g'). State the point without the preamble, name the actor, use the plain verb (VOICE.md in the prose skill)."

# 2. Em dashes.
# Tables and headings count too: an em dash in a cell is still an em dash.
if printf '%s\n' "$text" | awk '/^[[:space:]]*```/ { fence = !fence; next } fence { next } /^[[:space:]]*>/ { next } { print }' | grep -q '—'; then
  add "em dashes. Use a colon, a comma, or two sentences."
fi

# 3. Doc-only: proof trail and session bookkeeping; bold headings that are not questions.
if [ "$MODE" = doc ]; then
  trail='j'"'"'ai vérifié|nous avons vérifié|vérifié dans le code|vérifié sur pièces|preuve :|session du|décision du [0-9]{2}/[0-9]{2}|décidé le|acté le|chiffré le|vérifié le|ce matin|dans cette session|I verified|we verified|as verified'
  th=$(printf '%s\n' "$prose" | grep -oiE "$trail" 2>/dev/null | sort -fu | head -6)
  [ -n "$th" ] && add "proof trail or session bookkeeping: $(printf '%s' "$th" | paste -sd, - | sed 's/,/, /g'). A document records the decision and what it changes; how you got convinced stays in the session reply."

  bad_headings=$(printf '%s\n' "$text" | awk '
    /^[[:space:]]*\*\*[^*]+\*\*[[:space:]]*$/ {
      h = $0; sub(/^[[:space:]]*\*\*/, "", h); sub(/\*\*[[:space:]]*$/, "", h)
      # a heading that labels a table is a label, not a question
      getline nxt
      while (nxt ~ /^[[:space:]]*$/) { if ((getline nxt) <= 0) break }
      if (nxt ~ /^[[:space:]]*\|/) next
      if (h ~ /\?[[:space:]]*$/) next
      if (h ~ /^(Quel|Quelle|Quels|Quelles|Que |Qu.|Qui |Quand |Où |Comment |Pourquoi |Combien |Faut-il|Doit-on|Peut-on|Est-ce|What |Which |Who |When |Where |How |Why |Should |Does |Do |Is |Can )/) next
      print h
    }' | head -4)
  [ -n "$bad_headings" ] && add "bold headings that are not questions: $(printf '%s' "$bad_headings" | paste -sd'|' - | sed 's/|/ | /g'). A heading is a question that carries its own alternatives."
fi

# 4. Long sentences (over MAX_SENTENCE words).
# A line that ends without punctuation (heading, list item, label) closes its sentence.
long_sentences=$(printf '%s\n' "$prose" | awk -v max="$MAX_SENTENCE" '
  { line = $0; if (line !~ /[.!?]["»)]*[[:space:]]*$/ && line !~ /^[[:space:]]*$/) line = line "."; buf = buf " " line }
  END {
    n = split(buf, s, /[.!?](["»)]*)([[:space:]]+|$)/)
    for (i = 1; i <= n; i++) {
      w = split(s[i], words, /[[:space:]]+/)
      if (w > max) { t = s[i]; gsub(/^[[:space:]]+/, "", t); printf "%d words: %.60s...\n", w, t }
    }
  }' | head -3)
[ -n "$long_sentences" ] && add "sentences over ${MAX_SENTENCE} words: $(printf '%s' "$long_sentences" | paste -sd'|' - | sed 's/|/ ; /g'). One idea per sentence."

# 5. Long paragraphs (over MAX_PARAGRAPH words).
# A list item is its own paragraph: a blank line is inserted before each one.
long_paragraphs=$(printf '%s\n' "$prose" | awk '/^[[:space:]]*([-*]|[0-9]+\.) / { print "" } { print }' | awk -v max="$MAX_PARAGRAPH" '
  BEGIN { RS = "" }
  { w = split($0, words, /[[:space:]]+/); if (w > max) { t = $0; gsub(/\n/, " ", t); printf "%d words: %.50s...\n", w, t } }' | head -3)
[ -n "$long_paragraphs" ] && add "paragraphs over ${MAX_PARAGRAPH} words: $(printf '%s' "$long_paragraphs" | paste -sd'|' - | sed 's/|/ ; /g'). Split into two questions, or move the detail into a table."

[ -z "$findings" ] && exit 0

reason="Prose gate on ${label}:
${findings}

Rewrite before finishing: answer first, one why, details in a table, no proof trail, no emphasis. See $SKILL_DIR/SKILL.md. Quoting a tell to discuss it does not count once it sits in a code fence or a blockquote."

case "$MODE" in
  stop)
    session=$(printf '%s' "$input" | jq -r '.session_id // "nosession"' 2>/dev/null || echo nosession)
    counter="/tmp/claude-prose-gate-${session}.n"
    n=$( [ -f "$counter" ] && cat "$counter" || echo 0 )
    n=$((n + 1))
    if [ "$n" -ge "$MAX_ATTEMPTS" ]; then
      rm -f "$counter"
      jq -n --arg m "[prose-gate] still failing after ${MAX_ATTEMPTS} attempts, letting the reply through: $(printf '%s' "$findings" | head -c 300)" \
        '{suppressOutput: true, systemMessage: $m}'
      exit 0
    fi
    printf '%s' "$n" > "$counter"
    jq -n --arg r "Prose gate (attempt ${n}/${MAX_ATTEMPTS}). ${reason}" '{decision: "block", reason: $r}'
    ;;
  doc)
    jq -n --arg r "$reason" '{decision: "block", reason: $r}'
    ;;
esac
exit 0
