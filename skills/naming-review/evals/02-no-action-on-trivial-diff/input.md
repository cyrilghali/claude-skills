Tâche : invoque la skill naming-review sur ce qui suit et livre le résultat.

---

```diff
--- a/src/billing/invoice_calculator.py
+++ b/src/billing/invoice_calculator.py
@@ -14,10 +14,13 @@ from dataclasses import dataclass
 @dataclass
 class LineItem:
     unit_price_cents: int
     quantity: int

-def calculate_total_amount_cents(
+def calculate_discounted_total_cents(
     line_items: list[LineItem],
     discount_rate: float,
 ) -> int:
-    subtotal_cents = sum(item.unit_price_cents * item.quantity for item in line_items)
-    return int(subtotal_cents * (1 - discount_rate))
+    if not 0.0 <= discount_rate <= 1.0:
+        raise ValueError(
+            f"discount_rate must be in [0.0, 1.0], got {discount_rate}"
+        )
+    subtotal_cents = sum(item.unit_price_cents * item.quantity for item in line_items)
+    return round(subtotal_cents * (1 - discount_rate))
```
