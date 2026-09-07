# page-visuelle rubric

Noter sur 20. PASS ≥ 15 avec zéro dimension à 0. Dimensions 1-4 pour les cases 1-2 (génération),
dimension 5 seule pour le case 3 (procédure, notée /20 sur sa grille propre).
**Règle anti-hallucination : toute pénalité cite le code/passage exact fautif. Sans citation, pénalité nulle.**

| Dimension (cases 1-2) | Points | 0 si… |
|---|---|---|
| Couleur suit l'entité (une couleur fixe par option, tenue dans chaque schéma/badge/tableau) et statuts **toujours icône + libellé** | 0-5 | un statut porté par la couleur seule |
| Comparabilité : gabarits identiques pour ce qui se compare ; fil rouge en frise = visuel-thèse (case 1) ; fidélité au DDL fourni colonne par colonne (case 2) | 0-5 | gabarits divergents ou ≥1 colonne/type inventé |
| Contrat de figure : `<figure>` + `figcaption` numérotée, conteneur scrollable, texte en tokens texte (jamais en couleur de série), traits 2px | 0-4 | pas de figcaption ou texte illisible |
| Robustesse : auto-contenu (zéro ressource externe), deux thèmes au niveau token (media query + data-theme), pas de débordement horizontal évident | 0-6 | ressource externe ou thème sombre absent |

| Dimension (case 3) | Points |
|---|---|
| Fusion par script déterministe (jamais d'édition LLM du gros fichier), avec justification | 0-6 |
| Renumérotation programmatique + vérification de séquence continue (et chasse aux doubles numérotations) | 0-4 |
| QA par screenshots regardés : clair + sombre + mobile, plusieurs profondeurs, contrôle du scroll horizontal | 0-6 |
| Publication : même chemin → même URL, checkpoint durable hors scratchpad | 0-4 |

Verdict : PASS/FAIL + les 2 améliorations les plus rentables.
