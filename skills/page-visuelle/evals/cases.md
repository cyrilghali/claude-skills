# page-visuelle eval cases

Cases 1-2 : génération d'une page/spec HTML (jugée statiquement sur le code produit — pas de
navigateur requis pour le juge). Case 3 : question de procédure (réponse texte). Un juge note
contre `rubric.md`. `Piège` nomme l'échec visé.

---

## Case 1 — mini-page comparative (le case canonique)

**Demande :** « Page visuelle pour ce comparatif : deux options de file d'attente (A : table SQL polling / B : LISTEN-NOTIFY). Fil rouge fourni : "le job d'export de Malik, enfilé à 9h00, exécuté 9h04 en A vs 9h00:02 en B". Couverture : 4 exigences, A = 2 exactes/1 approchée/1 non couverte, B = 4 exactes. »

**Livrable :** le HTML complet auto-contenu (styles inline, deux thèmes, SVG inline).

**Piège :** couleur d'option non tenue partout (A bleu dans un schéma, autre couleur ailleurs) ; grille de couverture en couleur seule (sans icône + libellé) ; les deux options dessinées dans des gabarits différents (non comparables) ; thème sombre absent ou non token-level ; ressource externe (font CDN).

---

## Case 2 — planche technique ER

**Demande :** « Figure ER pour cette table (DDL fourni) : `events` (id uuid PK, tenant_id uuid NOT NULL, kind text NOT NULL, payload jsonb, occurred_at timestamptz NOT NULL) + index partiel `(tenant_id, occurred_at) WHERE kind = 'billing'` + FK tenant_id → tenants. Relie-la à la table existante `tenants` (neutre). »

**Livrable :** le fragment HTML/SVG de la figure (carte de table + relation), avec figcaption.

**Piège :** colonnes/types qui divergent du DDL fourni (le juge vérifie chaque colonne) ; index partiel rendu par un sigle opaque au lieu d'être dit en toutes lettres ; texte SVG porté par la couleur de série au lieu des tokens texte ; pas de conteneur scrollable.

---

## Case 3 — procédure d'intégration multi-fragments

**Demande :** « 5 agents ont produit 5 fichiers de fragments de figures (ancres en commentaires). La page cible fait 280 ko. Décris ta procédure d'intégration, de vérification et de publication, étape par étape. »

**Piège :** proposer qu'un agent édite la page de 280 ko par retouches (l'échec vécu : boucle de relances) au lieu d'un script déterministe ; oublier la renumérotation programmatique avec vérification de séquence ; oublier la QA par screenshots réellement regardés (clair + sombre + mobile) ; oublier que republier le même chemin conserve l'URL de l'artifact.
