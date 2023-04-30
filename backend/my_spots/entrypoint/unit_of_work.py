import os
from abc import ABC, abstractmethod
import psycopg2

from dotenv import load_dotenv

from ..adapters.repository import (
    UserAbstractRepository,
    UserRepository,
    FakeUserRepository,
    ReelAbstractRepository,
    ReelRepository,
    FakeReelRepository,
)

load_dotenv()


class AbstractUnitOfWork(ABC):
    users: UserAbstractRepository
    reels: ReelAbstractRepository

    def __enter__(self) -> "AbstractUnitOfWork":
        return self

    def __exit__(self, *args):
        self.commit()
        self.rollback()

    @abstractmethod
    def commit(self):
        raise NotImplementedError

    @abstractmethod
    def rollback(self):
        raise NotImplementedError


class FakeUnitOfWork(AbstractUnitOfWork):
    def __init__(self):
        super().__init__()
        self.users = FakeUserRepository()
        self.reels = FakeReelRepository()

    def commit(self):
        pass

    def rollback(self):
        pass


class UnitOfWork(AbstractUnitOfWork):
    def __enter__(self):
        self.connection = psycopg2.connect(
            host=os.environ.get("DB_HOST"),
            database=os.environ.get("DB_NAME"),
            user=os.environ.get("DB_USER"),
            password=os.environ.get("DB_PASSWORD"),
            port=os.environ.get("DB_PORT"),
        )

        self.cursor = self.connection.cursor()

        self.users = UserRepository(self.connection)
        self.reels = ReelRepository(self.connection)

        return super().__enter__()

    def __exit__(self, *args):
        super().__exit__(*args)
        self.connection.close()

    def commit(self):
        self.connection.commit()

    def rollback(self):
        self.connection.rollback()
