---
name: mutation-test
description: Measure a branch's test robustness by mutation testing — parallel agents apply targeted mutants one at a time and report which ones the tests fail to kill. Use when the user says "mutation testing", "nos tests sont-ils solides", "are the tests strong enough", after opening a draft PR with risky lib/ logic (SQL, seams, jobs, calculs), or when torture-test delegates its mutation axis.
---

# Mutation testing d'une branche

Mesure la robustesse des tests d'une branche/PR sans dépendance (pas de Muzak) :
des agents appliquent des mutants ciblés au code de prod un par un, relancent les
tests de la PR, et rapportent tués/survivants. Chaque survivant = un trou de test
concret avec l'assertion à ajouter. Pour les attaques au-delà de la mutation
(entrées hostiles, concurrence, ressources, état interrompu), voir la skill
torture-test.

## Quand

- Avant de merger un lot de PRs à logique risquée (SQL, seams, jobs, calculs).
- Sur demande « nos tests sont-ils solides ? » / « mutation testing ».
- Après un gros chantier multi-PRs : une passe par PR, en parallèle.

## Périmètre

1 agent = 1 branche (ou 1 module si la branche est grosse). Cible = les fichiers
`lib/` (ou `src/`) du diff de la branche ; tests = les fichiers de test du même diff :
`git diff --name-only $(git merge-base origin/<base> HEAD)..HEAD`.
Exécutants : `general-purpose`, `model: "sonnet"`, lancés en un seul bloc parallèle.
Chaque agent travaille dans le worktree/fork de sa branche — jamais deux agents
dans le même worktree.

## Phase 1 — mesure (l'agent)

Contrat à donner à chaque agent (adapter cible/chemins) :

1. **Pré-vol** : worktree propre (`git status --porcelain` vide). S'il est sale :
   backup par fichier (`cp` vers le scratchpad) et restauration par `cp`, JAMAIS
   de revert git global (`checkout .`, `stash`, `reset` interdits).
2. **Baseline** : lancer les tests de la PR (foreground, timeout long, jamais en
   background). Rouge → STOP et rapporter, on ne mute pas sur une base rouge.
3. **Concevoir 8–15 mutants ciblés** sur le code NOUVEAU seulement, priorisés sur
   la logique la plus risquée. Opérateurs qui paient :
   - flips de comparaison (`>=`↔`>`, `==`↔`!=`) et de bornes (off-by-one, signes) ;
   - suppression d'une clause `where`/filtre/garde ; inversion d'une négation ;
   - swap de valeurs du domaine (atoms d'event/actor, strings de metadata) ;
   - SQL : colonnes de PARTITION BY, ASC↔DESC, NOT EXISTS↔EXISTS,
     `IS NOT DISTINCT FROM`→`=`, médiane→moyenne, intervalles ;
   - émission/écriture sautée, ou limitée au premier élément d'une liste.
   Préférer les mutants QUI COMPILENT (les strings SQL sont idéales) — une erreur
   de compilation n'est qu'un « killed by compiler », signal faible.
4. **Un mutant à la fois** : Edit → tests de la PR → noter KILLED (quel test) ou
   SURVIVED → revert (`git checkout -- <fichier>` ou `cp` du backup) → vérifier
   worktree propre avant le suivant. Survivant → relancer une fois le répertoire
   de tests voisin pour distinguer « survit à la PR » de « survit à tout ».
5. **Rapport** : tableau `id | fichier:ligne | mutation | résultat`, puis par
   survivant une ligne « trou révélé + assertion suggérée ». Terminer par le
   `git status --porcelain` final (preuve de propreté).

Interdits : commit, push, toucher d'autres fichiers que la cible.

## Phase 2 — durcissement (optionnel, sur validation)

Après consolidation, trier les survivants : réels (cacheraient un bug prod) vs
cosmétiques (ordre intra-transaction, compteurs de log, aliasing de fixtures).
Pour les réels, relancer un agent par branche avec ce contrat :

1. Ajouter les tests tueurs suggérés — production intouchée ; un soupçon de bug
   prod découvert en route se RAPPORTE, ne se corrige pas dans cette passe.
2. **Kill-check obligatoire** par mutant : réappliquer le mutant → le nouveau
   test échoue → revert → suite verte. Un test qui ne tue pas son mutant est refusé.
3. Format/lint du repo, commit tests-seulement sur la branche de la PR, pas de push.

## Livrable (privé, JAMAIS sur GitHub)

Ne jamais poster le résultat en commentaire de PR ni nulle part de public
Le livrable va au demandeur directement :

1. **Le rapport dans la session** — le message final de consolidation EST le
   livrable principal.
2. **Une copie locale** dans `~/.claude/mutation-reports/<repo>-pr<N>.md`
   (créer le dossier au besoin), pour relecture à froid via `rv`.

Format identique dans les deux : concis, lisible à froid, jamais de slop :
une phrase d'explication de la pratique, le score, puis UNIQUEMENT les
survivants réels — chacun en « ce qui survit → l'assertion qui le tuerait »,
localisé `fichier:ligne`. Pas de tableau, pas d'emoji, pas de section vide ;
zéro survivant réel → deux lignes. Les cosmétiques écartés : un compte, sans
détail.

```markdown
**Mutation testing** — j'ai altéré le code nouveau de cette PR en N points
(filtres supprimés, comparaisons inversées, mappings permutés) pour vérifier
qu'à chaque fois un test casse. Score : K/N tués.

M survivants qui cacheraient un vrai bug :

- `fichier.ex:LIGNE` — <mutation en une proposition> ne fait échouer aucun test.
  Assertion à ajouter : <le test concret qui le tuerait>.

Survivants cosmétiques ignorés : C.
```

## Consolidation (boucle principale)

- Score par branche (tués/total) + score global.
- Séparer survivants réels / cosmétiques ; pour chaque réel, dire quel bug prod
  il cacherait.
- Un survivant peut révéler un vrai bug prod (ex. off-by-one légitime) : le
  remonter comme finding, jamais le « corriger » via un test qui entérine le
  comportement douteux.
