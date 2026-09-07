# EVAL — naming-review / 01-lying-names

## Défauts semés

| # | Identifiant | Localisation | Défaut | Item de la checklist |
|---|---|---|---|---|
| 1 | `get_user` | Méthode de `DataManager`, ligne ~27 | Nom menteur : le nom annonce une lecture (`get`), mais le corps effectue aussi une création (`POST /users`) si l'utilisateur est absent. Le contrat réel est un upsert. | Nom menteur : dit X, fait X+Y |
| 2 | `DataManager` | Nom de la classe, ligne ~20 | Générique fourre-tout : « Manager » ne dit pas ce que la classe fait — on ne peut pas deviner qu'elle orchestre les abonnements de facturation depuis le nom seul. | Générique (Manager, Helper, Utils…) |
| 3 | `timeout` | Paramètre de `get_user`, ligne ~27 | Unité absente : le paramètre est en millisecondes (`DEFAULT_TIMEOUT = 3000 # milliseconds`) mais le nom seul ne le dit pas. Le corps divise par 1000 pour passer à httpx, ce qui révèle l'unité — mais le nom devrait le faire. | Unités absentes (`timeout` → `timeout_ms`) |
| 4 | `fetch_subscriptions` / `load_plan_details` | Méthodes de `DataManager`, lignes ~37 et ~43 | Vocabulaire incohérent : deux mots différents (`fetch_` et `load_`) pour le même concept « lire depuis l'API HTTP ». Un lecteur ne peut pas deviner la règle. | Vocabulaire incohérent (deux mots pour un concept) |
| 5 | `enabled` | Champ du dataclass `Subscription`, ligne ~16 | Booléen non-prédicat : le champ est un `bool` mais son nom est un adjectif, pas un prédicat. La convention attendue est `is_enabled`. | Booléen non-prédicat (`enabled` → `is_enabled`) |

**Total : 5 défauts semés.**

## Identifiants corrects à ne pas renommer

Les identifiants suivants sont bien nommés — toute proposition de renommage sur ceux-ci est un FAIL :

- `Subscription` (nom de domaine précis, pas de générique)
- `subscription_id`, `user_id`, `plan_id`, `created_at` (champs du dataclass — clairs et cohérents)
- `base_url` (attribut — précis, une seule valeur)
- `cancel_subscription` (prédicat d'action + objet — clair)
- `DEFAULT_TIMEOUT` (constante — acceptable, l'unité est en commentaire sur cette ligne ; le défaut est sur le paramètre de fonction)

## Tolérances

- **#1 (nom menteur)** : la session peut proposer `get_or_create_user`, `upsert_user`, `ensure_user_exists`, ou tout nom qui signale explicitement la création potentielle. Toute formulation claire et sans ambiguïté convient.
- **#2 (générique)** : la session peut proposer `SubscriptionRepository`, `BillingDataClient`, `SubscriptionClient`, ou tout nom ancré dans le domaine métier. Elle ne doit pas proposer un autre générique.
- **#3 (unité)** : `timeout_ms` est la correction canonique. `timeout_milliseconds` est acceptable. La session doit noter que le paramètre de la fonction est concerné (pas seulement la constante `DEFAULT_TIMEOUT` dont le commentaire documente déjà l'unité).
- **#4 (vocabulaire)** : la session peut choisir `fetch_` ou `get_` ou `load_` comme préfixe canonique, l'essentiel est qu'elle identifie l'incohérence et propose un préfixe unique pour les deux méthodes.
- **#5 (booléen)** : `is_enabled` est la correction canonique. En Python, `is_active` ou `is_active_subscription` sont également acceptables si la session justifie le changement de mot.

## Barème

**PASS si :**
- ≥ 4 des 5 défauts sont identifiés avec une proposition de renommage concrète pour chacun
- Aucune proposition de renommage n'est faite sur les identifiants listés dans « Identifiants corrects » ci-dessus

**FAIL automatique si :**
- Moins de 4 défauts identifiés
- La session propose un renommage sur un identifiant de la liste « corrects » sans raison fondée dans la checklist (renommage cosmétique)
- La session renomme directement dans le code sans passer par le mécanisme de proposition (l'API publique d'une classe = proposer, ne pas renommer d'autorité)
