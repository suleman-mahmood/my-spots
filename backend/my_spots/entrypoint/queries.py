from .unit_of_work import AbstractUnitOfWork
from ..domain.model import User, Reel

from hashlib import sha256
from uuid import uuid4
from datetime import datetime
from typing import List

"""
Users module
"""


def get_user(user_id: str, uow: AbstractUnitOfWork) -> User:
    with uow:
        user = uow.users.get(user_id)
        return user


"""
Reels module
"""


def get_reel(reel_id: str, uow: AbstractUnitOfWork) -> Reel:
    with uow:
        reel = uow.reels.get(reel_id)
        return reel


# TODO: Change this
def nearest_reels(user_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at
        from reels
        where user_id = %s
    """

    with uow.cursor as cursor:
        cursor.execute(sql, [user_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                caption=r[4],
                description=r[5],
                thumbnail_url=r[6],
                banned=r[7],
                created_at=r[8],
            )
            for r in rows
        ]


# TODO: Change this
def following_reels(user_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at
        from reels
        where user_id = %s
    """

    with uow.cursor as cursor:
        cursor.execute(sql, [user_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                caption=r[4],
                description=r[5],
                thumbnail_url=r[6],
                banned=r[7],
                created_at=r[8],
            )
            for r in rows
        ]


# TODO: change this
def search_reels(keywords: List[str], uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at
        from reels
        limit 10
    """

    with uow.cursor as cursor:
        cursor.execute(sql)
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                caption=r[4],
                description=r[5],
                thumbnail_url=r[6],
                banned=r[7],
                created_at=r[8],
            )
            for r in rows
        ]


def tag_reels(tag_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at
        from reels
        where id in (
            select reel_id
            from reel_tags
            where tag_id = %s
        )
    """

    with uow.cursor as cursor:
        cursor.execute(sql, [tag_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                caption=r[4],
                description=r[5],
                thumbnail_url=r[6],
                banned=r[7],
                created_at=r[8],
            )
            for r in rows
        ]
