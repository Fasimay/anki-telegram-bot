from pathlib import Path
from anki.collection import Collection

class CollectionManager:

    def __init__(self, collection_path: Path) -> None:
        self._collection_path = collection_path
        self._collection: Collection | None = None

    def open(self) -> Collection:
        if self._collection is not None:
            return self._collection

        if not self._collection_path.is_file():
            raise FileNotFoundError(f"Anki collection not found: {self._collection_path}")

        self._collection = Collection(str(self._collection_path))
        return  self._collection

    def close(self) -> None:
        if self._collection is None:
            return

        self._collection.close()
        self._collection = None