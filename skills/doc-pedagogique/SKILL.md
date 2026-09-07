---
name: doc-pedagogique
description: Rédiger un document technique pédagogique en français soigné — contexte avant jargon, exemple fil rouge, options comparées, verdicts honnêtes. Use when writing a French technical document that compares several options or must onboard a reader who doesn't know the subject (design doc, étude, note d'architecture), or when the user rejects a draft as "difficilement compréhensible" or "français moyen". Not for short notes to an expert audience — scale down instead.
---

# Document pédagogique

Le lecteur cible découvre le sujet. Il doit comprendre le problème en 60 secondes et lire le document d'un trait, sans avoir le code ni le contexte sous les yeux.

## Structure (dans cet ordre)

1. **Chapeau** — ce que le document compare/explique et comment le lire (4-6 lignes).
2. **D'où on part** — comment le système fonctionne aujourd'hui, en langage humain. Aucun terme technique avant son introduction.
3. **Le problème, sur un exemple** — le fil rouge (voir plus bas), puis les questions qu'on ne sait pas répondre, une par une.
4. **Ce que le produit demande** — les exigences, reliées à leurs sources (brief, roadmap).
5. **Les options** — une section par option, template identique (voir plus bas).
6. **Comparaison** — un tableau + 3-5 enseignements en prose (« le vrai choix est X contre Y », « Z est un complément, pas un concurrent »).
7. **Recommandation** — trajectoire phasée + **décisions à trancher formulées en questions** (« L'escalation est-elle au scope de septembre ? Si oui… »).

## Le fil rouge

Un exemple concret unique et nommé (« le fichier de Léa, détecté le 1er mars, résolu le 12 ») introduit dans la section problème, puis **rejoué dans chaque option** : « sur notre exemple, voici ce qui s'écrit, où ». C'est lui qui rend le modèle de données tangible — un lecteur ne comprend pas un schéma, il comprend ce qui arrive à Léa.

## Template par option

- **L'idée** — 2-3 phrases, aucun nom de table avant de l'avoir expliqué.
- **Sur notre exemple** — le fil rouge rejoué dans ce design.
- **Ce qu'il faut construire** — liste numérotée, ordonnée par dépendance, chiffrée si possible.
- **Ce que ça donne** — par audience (admin, employé, produit futur).
- **Où ça coince** — les vraies limites, en gras la plus grave. Jamais omises : la crédibilité du document vient de là.
- **En une phrase** — le verdict.

## Règles de français

- Prose rédigée, phrases complètes. Jamais de télégraphe (`A → B → échec`), de fragments, ni d'abréviations inventées.
- Un terme technique = en `code` + expliqué **à sa première apparition**, jamais après.
- Guillemets français « », espaces insécables avant : ; ? !, accents sur les majuscules (À, É).
- Une idée par phrase ; couper toute phrase qui exige une relecture.
- Chiffres et unités précis (« ~6 j-h », « 31 figures »), pas de « rapidement » ou « facilement ».

## Règle de production

Les sous-agents/workflows produisent la **matière** (recherche, propositions longues, synthèses). La **passe finale s'écrit dans le contexte principal** — par l'assistant qui a tout le contexte, phrase par phrase — jamais en publiant ou en assemblant la prose compressée de sous-agents : elle produit un français moyen et un texte qui se lit comme un scorecard. Compresser soi-même = choisir ce qu'on omet, pas raccourcir les phrases.

## Exemplaire de référence

Garde à côté du skill le document qui a fait basculer ton lecteur après rejet d'une version compressée par agents. On s'y réfère pour le ton, le fil rouge (un personnage nommé qu'on suit de bout en bout) et le template par option.

## Finition

Cible : lisible en 10-12 minutes. Relire en se demandant à chaque section « un nouveau sur le projet comprend-il sans moi ? ». Clore la livraison en dirigeant les yeux du lecteur vers les 1-2 sections qui portent la décision (voir la voix de certification du CLAUDE.md global).
