from .unit_of_work import AbstractUnitOfWork
from ..domain.model import User, Reel, Comment, Tag

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


def get_all_tags(uow: AbstractUnitOfWork) -> List[Tag]:
    sql = """
        select id, tag_name 
        from tags
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql)
        rows = cursor.fetchall()

        return [
            Tag(
                id=r[0],
                tag_name=r[1],
            )
            for r in rows
        ]


def get_reel(reel_id: str, uow: AbstractUnitOfWork) -> Reel:
    with uow:
        reel = uow.reels.get(reel_id)
        return reel


def user_reels(user_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select r.id, r.user_id, r.video_url, r.location, r.spot_name, r.caption, r.description, r.thumbnail_url, r.banned, r.created_at, r.likes, r.views, r.comments, r.favourites, array_agg(concat(t.id, t.tag_name)) as tags
        from reels r
        left join 
            reels_tags rt on r.id = rt.reel_id
        left join 
            tags t on rt.tag_id = t.id
        where r.user_id = %s
        group by 
            r.id
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql, [user_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                spot_name=r[4],
                caption=r[5],
                description=r[6],
                thumbnail_url=r[7],
                banned=r[8],
                created_at=r[9],
                likes=int(r[10]),
                views=int(r[11]),
                comments=int(r[12]),
                favourites=int(r[13]),
                # TODO: Need to fix this later on
                # tags=[
                #     Tag(id=tag_tuple[0], tag_name=tag_tuple[1]) for tag_tuple in r[13]
                # ],
            )
            for r in rows
        ]


def user_favourite_reels(user_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select r.id, r.user_id, r.video_url, r.location, r.spot_name, r.caption, r.description, r.thumbnail_url, r.banned, r.created_at, r.likes, r.views, r.comments, r.favourites, array_agg(concat(t.id, t.tag_name)) as tags
        from reels r
        left join 
            reels_tags rt on r.id = rt.reel_id
        left join 
            tags t on rt.tag_id = t.id
        inner join
            favourites f on r.id = f.reel_id
        where f.user_id = %s
        group by 
            r.id
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql, [user_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                spot_name=r[4],
                caption=r[5],
                description=r[6],
                thumbnail_url=r[7],
                banned=r[8],
                created_at=r[9],
                likes=int(r[10]),
                views=int(r[11]),
                comments=int(r[12]),
                favourites=int(r[13]),
                # TODO: Need to fix this later on
                # tags=[
                #     Tag(id=tag_tuple[0], tag_name=tag_tuple[1]) for tag_tuple in r[13]
                # ],
            )
            for r in rows
        ]


# TODO: Apply algorithm to get nearest reels in sorted order
def nearest_reels(uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select r.id, r.user_id, r.video_url, r.location, r.spot_name, r.caption, r.description, r.thumbnail_url, r.banned, r.created_at, r.likes, r.views, r.comments, r.favourites, array_agg(concat(t.id, t.tag_name)) as tags
        from reels r
        left join 
            reels_tags rt on r.id = rt.reel_id
        left join 
            tags t on rt.tag_id = t.id
        group by 
            r.id
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql)
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                spot_name=r[4],
                caption=r[5],
                description=r[6],
                thumbnail_url=r[7],
                banned=r[8],
                created_at=r[9],
                likes=int(r[10]),
                views=int(r[11]),
                comments=int(r[12]),
                favourites=int(r[13]),
                # TODO: Need to fix this later on
                # tags=[
                #     Tag(id=tag_tuple[0], tag_name=tag_tuple[1]) for tag_tuple in r[13]
                # ],
            )
            for r in rows
        ]


# TODO: Change this
def following_reels(user_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select r.id, r.user_id, r.video_url, r.location, r.spot_name, r.caption, r.description, r.thumbnail_url, r.banned, r.created_at, r.likes, r.views, r.comments, r.favourites, array_agg(concat(t.id, t.tag_name)) as tags
        from reels r
        left join 
            reels_tags rt on r.id = rt.reel_id
        left join 
            tags t on rt.tag_id = t.id
        inner join
            followers f on r.user_id = f.to_id
        where f.from_id = %s
        group by 
            r.id
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql, [user_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                spot_name=r[4],
                caption=r[5],
                description=r[6],
                thumbnail_url=r[7],
                banned=r[8],
                created_at=r[9],
                likes=int(r[10]),
                views=int(r[11]),
                comments=int(r[12]),
                favourites=int(r[13]),
                # TODO: Need to fix this later on
                # tags=[
                #     Tag(id=tag_tuple[0], tag_name=tag_tuple[1]) for tag_tuple in r[13]
                # ],
            )
            for r in rows
        ]


# TODO: change this
def search_reels(search_text: str, uow: AbstractUnitOfWork) -> List[Reel]:
    return nearest_reels(uow=uow)


def tag_reels(tag_id: str, uow: AbstractUnitOfWork) -> List[Reel]:
    sql = """
        select id, user_id, video_url, location, spot_name, caption, description, thumbnail_url, banned, created_at
        from reels
        where id in (
            select reel_id
            from reel_tags
            where tag_id = %s
        )
    """

    with uow:
        cursor = uow.cursor
        cursor.execute(sql, [tag_id])
        rows = cursor.fetchall()

        return [
            Reel(
                id=r[0],
                user_id=r[1],
                video_url=r[2],
                location=tuple(float(r) for r in r[3][1:-1].split(",")),
                spot_name=r[4],
                caption=r[5],
                description=r[6],
                thumbnail_url=r[7],
                banned=r[8],
                created_at=r[9],
            )
            for r in rows
        ]


def reel_comments(reel_id: str, uow: AbstractUnitOfWork) -> List[Comment]:
    with uow:
        reel = uow.reels.get(reel_id)
        return list(reel.comments)
