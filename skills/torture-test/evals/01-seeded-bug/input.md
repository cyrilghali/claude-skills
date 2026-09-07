Tâche : invoque la skill torture-test sur ce qui suit et livre le résultat.

---

```python
# wallet.py
from typing import Protocol


class WalletDB(Protocol):
    def get_wallet(self, wallet_id: str) -> dict: ...
    def update_wallet(self, wallet_id: str, balance_cents: int) -> None: ...
    def record_transaction(self, wallet_id: str, delta_cents: int) -> None: ...


class InsufficientFundsError(Exception):
    pass


def debit_wallet(db: WalletDB, wallet_id: str, amount_cents: int) -> dict:
    """
    Debit amount_cents from the wallet. Returns the updated balance.
    Raises InsufficientFundsError if the wallet has insufficient funds.
    Raises ValueError if amount_cents is not positive.
    """
    if amount_cents <= 0:
        raise ValueError(f"amount_cents must be positive, got {amount_cents}")

    wallet = db.get_wallet(wallet_id)
    if wallet["balance_cents"] < amount_cents:
        raise InsufficientFundsError(
            f"Insufficient funds: balance={wallet['balance_cents']}, "
            f"requested={amount_cents}"
        )

    new_balance = wallet["balance_cents"] - amount_cents
    db.update_wallet(wallet_id, new_balance)
    db.record_transaction(wallet_id, -amount_cents)

    return {"wallet_id": wallet_id, "balance_cents": new_balance}
```

```python
# test_wallet.py
from unittest.mock import MagicMock, call
import pytest
from wallet import debit_wallet, InsufficientFundsError


def make_db(balance_cents: int) -> MagicMock:
    db = MagicMock()
    db.get_wallet.return_value = {"balance_cents": balance_cents}
    return db


def test_debit_reduces_balance():
    db = make_db(10_000)
    result = debit_wallet(db, "w1", 3_000)
    assert result["balance_cents"] == 7_000
    db.update_wallet.assert_called_once_with("w1", 7_000)


def test_debit_exact_amount_empties_wallet():
    db = make_db(5_000)
    result = debit_wallet(db, "w1", 5_000)
    assert result["balance_cents"] == 0


def test_debit_insufficient_funds_raises():
    db = make_db(1_000)
    with pytest.raises(InsufficientFundsError):
        debit_wallet(db, "w1", 2_000)


def test_debit_zero_amount_raises():
    db = make_db(10_000)
    with pytest.raises(ValueError):
        debit_wallet(db, "w1", 0)


def test_debit_negative_amount_raises():
    db = make_db(10_000)
    with pytest.raises(ValueError):
        debit_wallet(db, "w1", -500)
```
