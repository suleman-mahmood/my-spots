from .unit_of_work import AbstractUnitOfWork
from ..domain.model import User, Reel

from hashlib import sha256
from uuid import uuid4
from datetime import datetime
from typing import List

"""
Users module
"""


def fetch_user() -> User:
    pass


"""
Reels module
"""


def fetch_reel() -> Reel:
    pass


def neartest_reels() -> List[Reel]:
    pass


def followers_reels() -> List[Reel]:
    pass


def search_reels() -> List[Reel]:
    pass


def tag_reels() -> List[Reel]:
    pass
