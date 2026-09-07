Tâche : invoque la skill torture-test sur ce qui suit et livre le résultat.

---

```python
# slugify.py
import re
import unicodedata


def slugify(text: str, separator: str = "-") -> str:
    """
    Convert arbitrary text to a URL-safe slug.

    Normalizes unicode to NFKD, strips non-ASCII bytes, lowercases,
    collapses whitespace and punctuation into `separator`, and trims
    leading/trailing separators.
    """
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = text.lower()
    text = re.sub(r"[^\w\s-]", "", text)
    text = re.sub(rf"[-\s{re.escape(separator)}]+", separator, text)
    return text.strip(separator)
```

```python
# test_slugify.py
import pytest
from slugify import slugify


def test_basic_phrase():
    assert slugify("Hello World") == "hello-world"


def test_empty_string():
    assert slugify("") == ""


def test_only_punctuation_returns_empty():
    assert slugify("!@#$%^&*()") == ""


def test_unicode_accents_stripped():
    assert slugify("café résumé Ñoño") == "cafe-resume-nono"


def test_emoji_stripped():
    assert slugify("hello 🌍 world") == "hello-world"


def test_null_like_characters():
    assert slugify("a\x00b") == "ab"


def test_multiple_spaces_collapsed():
    assert slugify("a   b   c") == "a-b-c"


def test_leading_trailing_separators_stripped():
    assert slugify("  --hello--  ") == "hello"


def test_numbers_preserved():
    assert slugify("item 42 version 3") == "item-42-version-3"


def test_custom_separator():
    assert slugify("hello world", separator="_") == "hello_world"


def test_already_a_slug():
    assert slugify("already-a-slug") == "already-a-slug"


def test_mixed_separators_collapsed():
    assert slugify("a - b -- c") == "a-b-c"
```
