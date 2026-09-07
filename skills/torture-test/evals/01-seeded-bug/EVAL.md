# EVAL — torture-test / 01-seeded-bug

## Défaut semé

**Un seul bug, volontairement.**

| Aspect | Détail |
|---|---|
| **Description** | `debit_wallet` ne dispose d'aucune clé d'idempotence. Si l'appelant réessaie après un timeout réseau (ou si un double-clic déclenche deux appels simultanés), `db.get_wallet` renvoie le solde d'origine lors des deux appels, le garde-fou « fonds insuffisants » ne se déclenche pas, et le portefeuille est débité deux fois du même montant. |
| **Axe d'attaque** | Concurrence & répétition (axe 4 de l'arsenal) — retry après timeout, double-submit |
| **Repro minimal** | Appeler `debit_wallet(db, "w1", 3_000)` deux fois avec le même `db` mock dont `get_wallet` retourne toujours `{"balance_cents": 10_000}` ; `update_wallet` est appelé deux fois avec `7_000` alors que le solde réel devrait être `7_000` après le premier appel, non `4_000`. |
| **Bénéficiaire** | L'utilisateur final perd de l'argent (deux débits au lieu d'un). L'équipe support reçoit des tickets de contestation. |
| **Sévérité** | Élevée — perte financière réelle, non détectable par la suite existante. |

## Ce que la suite existante ne couvre pas

Les tests existants passent tous sans détecter le bug car le mock `make_db` retourne toujours le même solde fixe. Un appel répété au même mock donne le même résultat que le premier appel — le double-débit n'est jamais modélisé.

## Tolérances

- La session peut formuler le bug comme « absence d'idempotence », « pas de clé de déduplication », « double-débit sur retry » ou tout équivalent sémantique — toutes ces formulations désignent le même problème.
- La session peut identifier l'axe comme « retry », « double-submit », « concurrence », ou « répétition » — tous pointent l'axe 4.
- Le bénéficiaire peut être formulé comme « utilisateur qui perd de l'argent », « client qui voit deux transactions », « équipe support / finance » — toute entité qui subit une conséquence concrète et visible convient.
- La session peut proposer une correction (clé d'idempotence, verrou pessimiste, SELECT FOR UPDATE) sans que cela soit un FAIL — mais le bug doit d'abord être **rapporté** (repro + bénéficiaire) avant toute correction ou tout test.

## Barème

**PASS si :**
- Le bug (double-débit sur retry / absence d'idempotence) est identifié et rapporté comme un **finding** avec repro minimal ET bénéficiaire nommé
- Si un test est ajouté pour ce bug, il cite un bénéficiaire et il **échoue sur le code tel quel** (kill-check implicite — un test qui passe sur le code bugué sans modification est un faux positif). Note au juge : inspecter le mock du test produit — si `get_wallet` retourne une valeur fixe (mock sans état), tout test de retry passera sur le code bugué → faux positif.
- Aucun test n'est ajouté pour une torture qui **passe** (entrées hostiles déjà couvertes par les tests existants : zéro, négatif, fonds insuffisants)

**FAIL automatique si :**
- La session ajoute un test qui « couvre » le bug sans l'avoir rapporté comme finding
- La session ajoute un test qui passerait sur le code actuel tel quel (entérine le comportement douteux)
- La session ajoute des tests pour les axes qui passent déjà (padding) — ex. un test supplémentaire pour `amount_cents = 0` alors que `test_debit_zero_amount_raises` existe déjà
- La session ne nomme aucun bénéficiaire pour les tests qu'elle ajoute
