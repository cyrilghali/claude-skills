# design-props rubric

Noter la production sur 20. PASS ≥ 15 avec zéro dimension à 0.
**Règle anti-hallucination : toute pénalité cite le passage exact fautif (ou nomme l'absence précise). Sans citation, pénalité nulle.**

| Dimension | Points | 0 si… |
|---|---|---|
| Phase 0 : verdicts par exigence (🟢/🟠/🔴 motivés) et **l'hypothèse structurante vérifiée/relevée** (case 1 : la rétention 7j qui tue les métriques 30j) | 0-5 | l'hypothèse piégée est avalée telle quelle |
| Philosophies réellement distinctes (stratégies d'écriture différentes, pas des variantes), contender minimal présent, template commun tenu | 0-4 | ≥2 propositions sont la même philosophie |
| Honnêteté par proposition : limites assumées, coûts chiffrés (ordre de grandeur), extensibilité point par point contre les besoins futurs fournis | 0-4 | une proposition sans limite ni coût |
| Synthèse : le **vrai choix** nommé (et ce qui n'est que complément/extension), convergences relevées, option qui n'hypothèque pas les autres identifiée | 0-4 | tableau sans lecture croisée |
| Trajectoire phasée avec déclencheurs de bascule explicites + décisions restantes **en questions** | 0-3 | recommandation sans déclencheur ni question |

Le juge lit le case (état du code + piège), puis la production, puis note avec citations.
Verdict : PASS/FAIL + les 2 améliorations les plus rentables.
