---
name: page-visuelle
description: Transformer un document technique en page HTML visuelle auto-contenue — contrat de figure, palette validée, schémas comparables, QA par screenshots, fusion par script. Use when the user asks to "make it more visual", wants diagrams/figures added to a document, or wants a technical design (ER, flux, migrations, couverture) rendu en page lisible (artifact).
---

# Page visuelle technique

Prérequis : charger les skills `artifact-design` (calibrage) et `dataviz` (palette **validée par script**, jamais à l'œil) avant toute figure.

## 1. Spec d'abord, figures ensuite

Écrire une spec courte AVANT de produire : tokens (surfaces, encres, couleurs d'entité, statuts — les deux thèmes au niveau token), inventaire des figures avec leur section cible, interdits (hero vide, emoji-puces, dual-axis, couleur seule porteuse de sens). Les agents produisent contre la spec, pas contre leur goût.

## 2. Règles de figures qui marchent

- **La couleur suit l'entité** : chaque option ou entité du comparatif reçoit une couleur fixe de la palette, tenue partout — schémas, badges, tableaux. Les statuts (exact/approché/impossible) usent des couleurs status réservées, **toujours icône + libellé**, jamais couleur seule.
- **Squelette identique pour ce qui se compare** : les N options rejouent le même scénario dans le même gabarit — c'est la comparabilité d'un coup d'œil qui fait la valeur.
- **Le fil rouge en frise = visuel-thèse** de la page : la frise met en évidence le fait-clé que le document démontre (le moment où le problème se produit).
- Design technique : ER en **cartes de tables** (nom mono teinté entité, colonnes `nom type` + badges PK/FK/UNIQ/NEW + « index partiel » en toutes lettres, colonnes exactes du DDL source) ; chemins d'écriture en flèches étiquetées (trait plein = transactionnel, pointillé = cross-DB best-effort, légende obligatoire) ; migrations en frises à pastilles de phase ; couverture en grille avec provenance (table/colonne qui répond).
- Contrat de markup unique (`<figure class="fig">` + `.fig-scroll` + `figcaption` numérotée) appliqué à **chaque** figure sans exception — un titre en `<p>` ne remplace pas un `figcaption` ; aucun style global dans les fragments.
- **Le texte porte les tokens texte, jamais la couleur d'entité** — y compris les `<text>` SVG (labels, légendes) : seule la géométrie (barres, boîtes, flèches) est colorée par entité. C'est l'erreur la plus fréquente en génération (attrapée par l'eval).

## 3. Production multi-agents : fusion par script, jamais par LLM

- Fragments de figures par agents en parallèle (un fichier par planche, ancres `<!-- ancre: … -->`, synthèse courte en réponse — jamais le HTML en réponse, il meurt sur la limite de sortie).
- **La fusion dans la page est un script Python déterministe** (insertion par section, CSS des composants ajouté une fois, renumérotation `Fig. 1..N` programmatique avec vérification de séquence continue). Un agent qui édite un fichier de 300 ko par retouches meurt en boucle — vécu : 5 relances avant d'être arrêté.
- Piège vérifié : après fusion, traquer les **doubles numérotations** (« Fig. 10 — Fig. 4 ») héritées des fragments.

## 4. QA par captures réelles

Screenshoter avec agent-browser (wrapper doctype minimal, `file://`) : clair + sombre (`set media dark`) + mobile 375px, à plusieurs profondeurs de scroll, et **regarder chaque capture** (Read). Vérifier : zéro scroll horizontal de page (`scrollWidth <= clientWidth`), thème sombre lisible sur chaque figure, labels sans collision. Un validateur ne remplace pas les yeux.

## 5. Exemplaire de référence

Garde à côté du skill une page complète déjà livrée (frises, ER en cartes de tables, grilles de couverture), ses specs visuelles et le script de fusion : ce sont les modèles à imiter.

## 6. Publication et survie

- Artifact : republier le **même chemin de fichier** conserve la même URL (versions labellisées) ; un chemin différent mint une nouvelle URL. Un aperçu peut être publié avant la QA finale, puis écrasé sur le même lien.
- Copier (`cp`) la page, les fragments et le script de fusion vers un dossier durable du home (ex. `~/<projet>-work/`) — les scratchpads de session peuvent être purgés en cours de route.
