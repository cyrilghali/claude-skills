# EVAL — naming-review / 02-no-action-on-trivial-diff

## Défauts semés

Aucun. Ce diff ne contient aucun problème de nommage.

**Analyse de chaque identifiant du diff :**

| Identifiant | Verdict | Justification |
|---|---|---|
| `calculate_discounted_total_cents` | Correct | Verbe d'action + adjectif qualificatif + objet + unité — prédit exactement ce que la fonction retourne |
| `calculate_total_amount_cents` (retiré) | Correct (remplacé pour raison sémantique) | Le renommage dans le diff est justifié par le changement de comportement (ajout de la remise), pas par un problème de nommage |
| `line_items` | Correct | Nom de domaine précis, pluriel cohérent avec le type `list[LineItem]` |
| `LineItem` | Correct | Nom de domaine, pas générique |
| `unit_price_cents` | Correct | Concept + unité explicite |
| `quantity` | Correct | Nom de domaine non ambigu dans ce contexte |
| `discount_rate` | Correct | Concept + nature (rate = fraction) sans ambiguïté sur l'intervalle attendu |
| `subtotal_cents` | Correct | Concept + unité explicite |

## Tolérances

- La session peut signaler que le renommage `calculate_total_amount_cents` → `calculate_discounted_total_cents` est pertinent pour refléter la sémantique, mais comme ce renommage est déjà présent dans le diff, elle ne doit pas le proposer à nouveau comme action.
- La session peut noter qu'un commentaire ou une annotation de type sur `discount_rate` (ex. `Annotated[float, "fraction in [0, 1]"]`) améliorerait la documentation, mais cela dépasse le périmètre du naming-review — cette observation ne compte ni positivement ni négativement.

## Barème

**PASS si :**
- La session déclare explicitement qu'il n'y a aucun problème de nommage dans ce diff
- La session propose zéro renommage

**FAIL automatique si :**
- La session propose un renommage, même cosmétique (ex. `discount_rate` → `discount_rate_fraction`, `subtotal_cents` → `items_subtotal_cents`)
- La session reformule des identifiants déjà corrects au motif d'une préférence de style personnelle
- La session applique le scan spontanément à du code hors du diff (le périmètre est le diff fourni, pas le module entier)
