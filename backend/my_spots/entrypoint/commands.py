from uuid import uuid4
from typing import Tuple, Set

from .unit_of_work import AbstractUnitOfWork
from ..domain.model import User, Reel, Comment, Report, Tag


# Users module


def create_user(
    full_name: str,
    user_name: str,
    email: str,
    phone_number: str,
    profile_text: str,
    location: Tuple[float, float],
    avatar_url: str,
    uow: AbstractUnitOfWork,
) -> User:
    user = User(
        id=str(uuid4()),
        full_name=full_name,
        user_name=user_name,
        email=email,
        phone_number=phone_number,
        profile_text=profile_text,
        location=location,
        avatar_url=avatar_url,
    )

    with uow:
        uow.users.add(user)

    return user


def update_user(
    uow: AbstractUnitOfWork,
    user_id: str,
    full_name: str = "",
    user_name: str = "",
    email: str = "",
    phone_number: str = "",
    profile_text: str = "",
    location: Tuple[float, float] = (0.0, 0.0),
    avatar_url: str = "",
):
    with uow:
        user = uow.users.get(user_id)

        user.full_name = user.full_name if full_name == "" else full_name
        user.user_name = user.user_name if user_name == "" else user_name
        user.email = user.email if email == "" else email
        user.phone_numer = user.phone_number if phone_number == "" else phone_number
        user.profile_text = user.profile_text if profile_text == "" else profile_text
        user.location = user.location if location == (0.0, 0.0) else location
        user.avatar_url = user.avatar_url if avatar_url == "" else avatar_url

        uow.users.save(user)


def follow_user(
    user_id: str,
    user_to_follow_id: str,
    uow: AbstractUnitOfWork,
):
    with uow:
        user = uow.users.get(user_id)
        user.follow_user(user_id=user_to_follow_id)
        uow.users.save(user)


# Reels module


def create_tag(
    tag_name: str,
    uow: AbstractUnitOfWork,
) -> Tag:
    tag = Tag(id=str(uuid4()), tag_name=tag_name)

    with uow:
        uow.reels.add_tag(tag=tag)

    return tag


def create_reel(
    user_id: str,
    video_url: str,
    location: Tuple[float, float],
    caption: str,
    description: str,
    thumbnail_url: str,
    tags: Set[Tag],
    uow: AbstractUnitOfWork,
) -> Reel:
    reel = Reel(
        id=str(uuid4()),
        user_id=user_id,
        video_url=video_url,
        location=location,
        caption=caption,
        description=description,
        thumbnail_url=thumbnail_url,
        tags=tags,
    )

    with uow:
        uow.reels.add(reel)

    return reel


def delete_reel(
    reel_id: str,
    uow: AbstractUnitOfWork,
):
    with uow:
        uow.reels.delete(reel_id)


def view_reel(
    reel_id: str,
    user_id: str,
    uow: AbstractUnitOfWork,
):
    with uow:
        reel = uow.reels.get(reel_id)
        reel.view_reel(user_id=user_id)
        uow.reels.save(reel)


def like_reel(
    reel_id: str,
    user_id: str,
    uow: AbstractUnitOfWork,
):
    with uow:
        reel = uow.reels.get(reel_id)
        reel.like_reel(user_id=user_id)
        uow.reels.save(reel)


def favourite_reel(
    reel_id: str,
    user_id: str,
    uow: AbstractUnitOfWork,
):
    with uow:
        reel = uow.reels.get(reel_id)
        reel.favourite_reel(user_id=user_id)
        uow.reels.save(reel)


def comment_reel(
    reel_id: str,
    user_id: str,
    comment_text: str,
    uow: AbstractUnitOfWork,
) -> Comment:
    comment = Comment(id=str(uuid4()), user_id=user_id, comment_text=comment_text)
    with uow:
        reel = uow.reels.get(reel_id)
        reel.comment_reel(comment=comment)
        uow.reels.save(reel)

    return comment


def report_reel(
    reel_id: str,
    user_id: str,
    report_text: str,
    uow: AbstractUnitOfWork,
) -> Report:
    report = Report(id=str(uuid4()), user_id=user_id, report_text=report_text)
    with uow:
        reel = uow.reels.get(reel_id)
        reel.report_reel(report=report)
        uow.reels.save(reel)

    return report
