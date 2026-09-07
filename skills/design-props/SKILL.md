---
name: design-props
description: Produire N propositions de design techniques comparées, ancrées dans le code réel — philosophies imposées, critique adversariale, matrice et trajectoire. Use when the user asks for "plusieurs propositions de design", "compare des approches/architectures", multiple technical design propositions, a comparative architecture study, or an explicit N-approaches comparison. Not for a single design spec or direct recommendation.
---

# Propositions de design comparées

Objectif : que la décision devienne presque mécanique — le lecteur voit le vrai choix, ce que chaque option coûte, et ce qu'elle hypothèque.

## Phase 0 — Faisabilité (avant tout design)

1. Cartographier le réel : schémas, migrations, points d'écriture (seams), avec fichier:ligne. Déléguer à des sous-agents d'exploration en lecture seule (type Explore), mais **vérifier soi-même l'hypothèse structurante** — celle dont une erreur invaliderait toutes les propositions (ex. : « cette table est-elle écrasée à chaque cycle ou réconciliée par diff ? »).
2. Croiser chaque exigence produit avec ce qui est réellement persisté : verdict 🟢 calculable / 🟠 dégradé / 🔴 impossible, avec la raison.
3. Chercher l'argument qui tranche : une exigence produit future qui rend une migration obligatoire de toute façon change la question de « si » en « quand ».

## Phase 1 — Concevoir N philosophies distinctes

- 3-5 philosophies **imposées** (ex. : event log pur / entité stateful / hybride / pré-agrégés) — inclure le contender minimal « ne rien changer aux chemins d'écriture », il force l'honnêteté des autres.
- Chaque auteur (agent) pousse SA philosophie à son meilleur, interdiction de dériver vers les autres : la comparaison se fait ailleurs.
- **Template commun imposé** (modèle de données avec DDL, chemins d'écriture, couverture exigence par exigence, usage par audience, extensibilité, migration, coûts) — sans template commun, les propositions ne se comparent pas.
- Extensibilité = confrontée **point par point à la roadmap produit réelle** (chaque axe : natif / extension simple / refonte), jamais un score vague.

## Phase 2 — Critique adversariale puis révision

- 3 lentilles par proposition, chacune cherchant à réfuter : **réalité du codebase** (ouvrir les fichiers cités), **extensibilité produit** (la roadmap casse-t-elle le design ?), **exactitude/perf des requêtes** (dénominateurs point-in-time approximés en douce, cross-DB, volumes).
- L'auteur révise : corrige les critiques fondées, **écarte les infondées en le justifiant**, et ajoute une section « Limites assumées » — ce que sa philosophie ne résoudra jamais bien.

## Phase 3 — Synthèse

- Matrice comparative (couverture, coût sprint 1, roadmap, risque migration, réversibilité).
- Lecture croisée : où les propositions **convergent** (= décisions robustes quel que soit le choix — ex. « toutes instrumentent les mêmes seams »), quel est le **vrai choix** (souvent 2 options ; les autres sont des compléments ou des extensions), et quelle option **n'hypothèque pas** les autres.
- Trajectoire phasée avec déclencheurs de bascule explicites, puis décisions à trancher **en questions**.

## Exemplaire de référence

Garde à côté du skill l'étude complète qui a validé la méthode chez toi (le livrable final et ses specs) : c'est elle qu'on relit pour le ton et le format des décisions. Dans l'étude d'origine, les quatre philosophies étaient : event log pur / entité stateful / hybride / rollups pré-agrégés.

## Exécution en workflow (pièges vécus)

- Sortie des agents : **toujours Write dans un fichier + une synthèse courte en réponse** — le livrable long va dans le fichier ; un agent qui le colle dans sa réponse meurt sur la limite de sortie (32k tokens).
- Checkpoints : les journaux du tool Workflow (`journal.jsonl`, reprise via `resumeFromRunId`) évitent de re-payer les agents terminés ; snapshotter en plus les livrables vers un dossier durable du home après chaque phase (les scratchpads de session peuvent être purgés).
- La rédaction finale du document livré suit le skill `doc-pedagogique`.
