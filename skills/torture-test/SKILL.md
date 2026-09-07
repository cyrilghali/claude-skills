---
name: torture-test
description: Adversarial QA pass that tries to break code and its test suite only where a named beneficiary gains from it — hostile inputs, invariant/property checks, concurrency and retry storms, resource ceilings, interrupted state — with mutation testing delegated to the mutation-test skill. Findings first, new tests second, documented confidence instead of padding. Use when the user says "break this", "torture test", "harden the tests", "QA pass", or before shipping risky logic (money, concurrency, migrations, parsers).
---

# Torture testing

Le but n'est pas d'écrire plus de tests, c'est de trouver ce qui casse et qui
s'en soucie. **Règle du bénéficiaire (porte d'entrée, pas conseil)** : avant
chaque attaque, répondre à « quelle défaillance visible — pour l'utilisateur
final, l'astreinte, le mainteneur, la perf — ce test attraperait-il ? ».
Pas de réponse → l'attaque ne se lance pas.

## Arsenal — choisir 2 ou 3 axes selon le code, jamais tout

1. **Mutation** — robustesse de la suite face au code : déléguée entièrement à
   la skill mutation-test (opérateurs, contrat d'exécutant, scoring).
2. **Entrées hostiles** — vide, énorme, unicode/emoji/NUL, négatif, bornes ±1,
   encodage cassé, TZ/DST/29 février, locale, injection dans les champs libres.
3. **Invariants (property)** — roundtrip encode/decode, idempotence des
   retries, somme conservée (argent !), tri stable, monotonie. Seulement si
   l'invariant existe vraiment dans le domaine — ne pas en inventer.
4. **Concurrence & répétition** — double-submit, retry après timeout
   (l'opération a-t-elle eu lieu ?), événements hors ordre, deux workers sur la
   même ressource.
5. **Ressources** — N×100 pour trouver le plafond perf (mesurer, pas deviner),
   dépendance lente ou morte, disque plein simulé, mémoire bornée.
6. **État interrompu** — crash entre deux écritures, replay d'un job à moitié
   fait, migration partielle, cache incohérent avec la source.

## Règles de valeur

- **Oracle obligatoire** : chaque torture porte une attente vérifiable. « Ça
  n'a pas crashé » n'est un oracle que pour les attaques de robustesse pure.
- **Findings avant tests** : un bug trouvé se rapporte (repro minimal, impact,
  bénéficiaire touché) AVANT d'écrire quoi que ce soit. Le fix n'est pas dans
  cette passe — et un test qui entérinerait le comportement douteux est refusé.
- **Budget** : ~10 attaques max par passe. Chaque test ajouté cite son
  bénéficiaire en une ligne (nom du test ou description).
- **Zéro padding** : une torture qui passe ne produit pas de test — elle
  produit une ligne de confiance documentée dans le triage.

## Exécution

- **Un module** : en direct, dans la session.
- **Une branche large** : agents exécutants parallèles, contrat façon
  mutation-test phase 1 — préflight propre (`git status --porcelain` vide),
  baseline verte avant toute attaque, un axe par agent, revert prouvé,
  interdits commit/push.

## Triage final (le livrable)

1. **Bugs trouvés** — repro minimal + bénéficiaire touché + sévérité.
2. **Trous réels** — tests tueurs ajoutés, chacun avec sa ligne bénéficiaire ;
   kill-check : le test échoue sur le comportement cassé, passe sur le sain.
3. **Tortures passées** — confiance documentée, zéro ligne de code ajoutée.
