# design-props eval cases

Chaque case décrit un état de code auto-contenu (pas d'accès repo nécessaire) et une demande.
L'agent de génération applique le skill en version condensée : faisabilité (verdicts par exigence),
2-3 philosophies avec template commun, critiques principales, synthèse (matrice, vrai choix,
trajectoire, décisions). Un juge note contre `rubric.md`. `Piège` nomme l'échec visé.

---

## Case 1 — l'hypothèse structurante piégée (le case canonique)

**Demande :** « Propose plusieurs designs pour des statistiques d'usage des webhooks (taux d'échec sur 30j, temps médian de rétablissement, endpoints jamais rétablis). »

**État du code fourni :**
- `webhook_endpoints` (id, url, disabled_at) — état courant.
- `webhook_deliveries` (endpoint_id, status, attempted_at) — « les livraisons sont conservées » d'après le README… **mais** la migration fournie montre un job `PruneDeliveriesJob` qui `DELETE WHERE attempted_at < now() - interval '7 days'`.
- `webhook_failures_count` sur endpoints — compteur écrasé à chaque sync.

**Piège :** bâtir les designs sur « les livraisons sont conservées » sans relever que la rétention de 7 jours invalide toute métrique 30j — l'hypothèse structurante contredite par un détail fourni. Un générateur qui applique le skill doit la vérifier/relever en Phase 0 et en tirer les verdicts 🔴.

---

## Case 2 — philosophies non distinctes

**Demande :** « 3 approches pour historiser les changements de permissions (qui a donné quel accès, quand, révoqué quand). »

**État du code :** `permissions` (état courant, upsert), `audit_log` générique (jsonb, non typé, 90j de rétention), aucun événement typé.

**Piège :** produire 3 variantes de la même philosophie (3 formes de table d'audit) au lieu de philosophies réellement distinctes (ex. : event log typé / entité stateful avec versions / étendre l'audit_log existant), et omettre le contender minimal. Second piège : extensibilité en score vague (« extensible : oui ») au lieu de point par point contre les besoins futurs fournis (rétention 2 ans exigée par conformité, groupes de permissions à venir).

---

## Case 3 — synthèse sans décision

**Demande :** « Compare pgvector vs service de recherche externe pour la recherche sémantique des documents, et dis-nous quoi faire. »

**État fourni :** Postgres 16 géré (extensions autorisées : liste incluant pgvector), 2M docs, équipe sans infra dédiée, latence cible < 200ms, budget serré, croissance ×10 possible à 18 mois.

**Piège :** conclure par un tableau sans nommer **le vrai choix** ni la trajectoire phasée avec déclencheurs (« démarrer pgvector ; basculer si p95 > 200ms au-delà de N docs »), ni formuler les décisions restantes en questions pour l'équipe.
