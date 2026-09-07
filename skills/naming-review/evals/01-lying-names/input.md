Tâche : invoque la skill naming-review sur ce qui suit et livre le résultat.

---

```python
# subscription_manager.py
from __future__ import annotations
from dataclasses import dataclass
import httpx

DEFAULT_TIMEOUT = 3000  # milliseconds


@dataclass
class Subscription:
    subscription_id: str
    user_id: str
    plan_id: str
    enabled: bool
    created_at: str


class DataManager:
    """Handles subscription data for the billing service."""

    def __init__(self, base_url: str) -> None:
        self.base_url = base_url

    def get_user(self, user_id: str, timeout: int = DEFAULT_TIMEOUT) -> dict:
        """Return the user account for the given user_id."""
        resp = httpx.get(f"{self.base_url}/users/{user_id}", timeout=timeout / 1000)
        if resp.status_code == 404:
            resp = httpx.post(
                f"{self.base_url}/users",
                json={"id": user_id, "plan": "free"},
                timeout=timeout / 1000,
            )
        resp.raise_for_status()
        return resp.json()

    def fetch_subscriptions(self, user_id: str) -> list[Subscription]:
        """Return all subscriptions for a user."""
        resp = httpx.get(f"{self.base_url}/users/{user_id}/subscriptions")
        resp.raise_for_status()
        return [Subscription(**s) for s in resp.json()]

    def load_plan_details(self, plan_id: str) -> dict:
        """Return plan metadata from the catalog."""
        resp = httpx.get(f"{self.base_url}/plans/{plan_id}")
        resp.raise_for_status()
        return resp.json()

    def cancel_subscription(self, subscription_id: str) -> bool:
        """Cancel a subscription. Returns True if the cancellation succeeded."""
        resp = httpx.delete(f"{self.base_url}/subscriptions/{subscription_id}")
        return resp.status_code == 204
```
