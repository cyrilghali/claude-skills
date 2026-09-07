# EVAL — torture-test / 02-healthy-code-no-padding

## Défauts semés

Aucun. Le module et sa suite de tests sont intentionnellement sains.

## Couverture existante — axes déjà fermés

| Axe d'attaque | Ce que la suite couvre déjà |
|---|---|
| Entrées hostiles — vide | `test_empty_string` → `""` retourne `""` |
| Entrées hostiles — unicode/emoji | `test_unicode_accents_stripped`, `test_emoji_stripped` |
| Entrées hostiles — NUL / caractères de contrôle | `test_null_like_characters` → `\x00` est retiré par la substitution regex `[^\w\s-]` (NUL est un caractère ASCII valide, code 0 : il passe l'étape encode/decode inchangé ; c'est le regex qui l'élimine car il ne correspond ni à `\w`, ni à `\s`, ni à `-`) |
| Entrées hostiles — bornes et cas limites | `test_only_punctuation_returns_empty`, `test_leading_trailing_separators_stripped` |
| Entrées hostiles — entrée déjà propre | `test_already_a_slug` |
| Séparateur personnalisé | `test_custom_separator` |
| Effondrement de séparateurs multiples | `test_mixed_separators_collapsed`, `test_multiple_spaces_collapsed` |
| Chiffres préservés | `test_numbers_preserved` |

Les axes restants de l'arsenal (concurrence & répétition, ressources, état interrompu, invariants non-triviaux) **ne s'appliquent pas** à une fonction pure sans état — aucune défaillance visible ne peut en être nommée pour une fonction `str -> str` sans effets de bord.

## Ce qu'une session bien calibrée doit livrer

- Attaquer 2–3 axes (entrées hostiles et/ou invariants roundtrip) et documenter que la suite existante les couvre déjà
- Formuler une **confiance documentée** (ex. « couverture entrées hostiles : complète ; invariant idempotence : slugify(slugify(x)) == slugify(x) — vérifié informellement, pas de nouveau test nécessaire »)
- Ajouter **zéro nouveau test**

## Axes que la session pourrait explorer légitimement (sans trouver de bug)

- **Idempotence** : `slugify(slugify(x)) == slugify(x)` — propriété vraie, déjà implicitement couverte par `test_already_a_slug`
- **Séparateur multi-caractère** : `separator="--"` — comportement défini par le regex, pas de bug
- **Chaîne très longue** : pas de plafond de ressource visible pour une fonction pure Python

## Tolérances

- La session peut noter qu'un cas de séparateur multi-caractère n'est pas explicitement testé — cette observation est acceptable si elle ne produit pas de test.
- La session peut noter que `separator` dans le regex utilise `re.escape`, ce qui garantit la sécurité des séparateurs spéciaux — observation de confiance, pas un bug.
- La session peut choisir n'importe quels 2–3 axes de l'arsenal pour son attaque — l'essentiel est qu'elle documente pourquoi ils passent plutôt que d'ajouter des tests pour les couvrir à nouveau.

## Barème

**PASS si :**
- La session attaque ≥ 2 axes et documente que chaque attaque passe
- La session ajoute **zéro nouveau test**
- La session livre une section de confiance documentée (triage final : « Tortures passées »)

**FAIL automatique si :**
- La session ajoute un ou plusieurs tests, même pertinents (padding — une torture qui passe ne produit pas de test)
- La session signale un bug qui n'existe pas dans le code
- La session ne lance aucune attaque et se contente de déclarer le code « sain » sans argumenter axe par axe
