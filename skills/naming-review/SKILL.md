---
name: naming-review
description: Review and fix identifiers (modules, functions, variables, endpoints, tables) so they are self-explanatory from the call site — runs a prediction test where a context-free subagent guesses each name's behavior from signatures alone, plus a one-concept-one-word consistency scan. Use when creating a new module or public API, or on explicit request — when the user says names are "not self explanatory", "renomme", "unclear naming", "what does this module even do". Not a default per-PR pass; never fire spontaneously on routine diffs.
---

# Naming review

Un nom est bon si un dev qui découvre le code dans 6 mois prédit le
comportement depuis le point d'appel, sans ouvrir le corps. Comme pour la
prose, l'auteur ne peut pas juger : il connaît déjà le corps.

## Le test de prédiction (mécanisme central)

1. Collecter les noms publics du périmètre : fichiers/modules, fonctions
   exportées avec signatures, types clés, tables, endpoints. Noms et
   signatures SEULEMENT — jamais les corps.
2. Agent frais (`general-purpose`, zéro contexte) avec ce contrat : « Pour
   chaque élément, décris ce qu'il fait et ce qu'il retourne. Signale ceux que
   tu ne peux pas prédire, et les paires qui pourraient vouloir dire la même
   chose. »
3. Diff prédictions vs réalité. Prédiction fausse ou vague = candidat au
   renommage. L'agent ne peut pas tricher : il ne connaît réellement pas le
   projet.

## Les fautes qui paient

- **Nom menteur** : dit X, fait X+Y (`getUser` qui crée l'utilisateur,
  `validate` qui mute).
- **Générique** : Manager, Helper, Utils, Processor, Service fourre-tout,
  `data`, `info`, `handle*`, `do*`, `process*`.
- **Implémentation au lieu d'intention** : `loopOverRows` vs `applyLateFees`.
- **Vocabulaire incohérent** : deux mots pour un concept (`fetch`/`get`/`load`
  mélangés) ou un mot pour deux concepts (« account » = deux entités). Tenir
  un mini-glossaire : un concept, un mot, greppable.
- **Booléen non-prédicat** (`enabled` → `isEnabled`), **unités absentes**
  (`timeout` → `timeoutMs`), **longueur ∝ portée** (`i` ok en boucle de 3
  lignes, jamais en nom de module).
- **Module nommé par couche** (`utils2`, `helpers`, `common`) au lieu du
  concept métier (`billing`, `scoring`).

## Renommer

- Renommage mécanique (LSP/IDE ou grep exhaustif + vérification), dans un
  commit dédié, jamais mélangé à un changement de logique.
- API publique, table, endpoint : proposer, ne pas renommer d'autorité (coût
  de migration) — livrer une liste « à renommer à la prochaine occasion ».

## Doser

Nouveau module / API publique : scan complet. Sur demande explicite :
périmètre indiqué par l'appelant (un diff, un module). Jamais spontanément sur
un diff de routine ; pas de renommage cosmétique de code non touché par le
chantier.
