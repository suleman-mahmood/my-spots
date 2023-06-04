import pytest

from .commands import *
from uuid import uuid4
from ..entrypoint import unit_of_work


def seed_user(uow: AbstractUnitOfWork) -> User:
    return create_user(
        id=str(uuid4()),
        full_name="Suleman Mahmood",
        user_name="suleman.mahmood",
        email="sulemanmahmood99@gmail.com",
        phone_number="03333462677",
        profile_text="cool profile",
        avatar_url="https://www.suleman.com",
        location=(25.0, 30.0),
        uow=uow,
    )


def seed_reel(user_id: str, tags: Set[Tag], uow: AbstractUnitOfWork) -> Reel:
    return create_reel(
        user_id=user_id,
        video_url="https://www.reel.com",
        spot_name="cool spot",
        location=(26.0, 31.0),
        caption="cool caption",
        description="cool description",
        thumbnail_url="https://www.thumbnail.com",
        tags=tags,
        uow=uow,
    )


def seed_tags(uow: AbstractUnitOfWork) -> Set[Tag]:
    tags = set()

    tags.add(create_tag(tag_name="cool", uow=uow))
    tags.add(create_tag(tag_name="reel", uow=uow))
    tags.add(create_tag(tag_name="short", uow=uow))

    return tags


def test_create_user():
    user = seed_user(uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_user = uow.users.get(user_id=user.id)

        assert fetched_user.id == user.id
        assert fetched_user.full_name == user.full_name
        assert fetched_user.user_name == user.user_name
        assert fetched_user.email == user.email
        assert fetched_user.phone_number == user.phone_number
        assert fetched_user.profile_text == user.profile_text
        assert fetched_user.location == user.location
        assert fetched_user.avatar_url == user.avatar_url


def test_update_user():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    new_name = "Fawaz Ahmed"

    update_user(uow=unit_of_work.UnitOfWork(), user_id=user.id, full_name=new_name)

    with unit_of_work.UnitOfWork() as uow:
        fetched_user = uow.users.get(user_id=user.id)

        assert fetched_user.full_name == new_name


def test_follow_user():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    user_2 = seed_user(uow=unit_of_work.UnitOfWork())

    follow_user(
        user_id=user.id, user_to_follow_id=user_2.id, uow=unit_of_work.UnitOfWork()
    )

    with unit_of_work.UnitOfWork() as uow:
        fetched_user = uow.users.get(user_id=user.id)

        assert user_2.id in fetched_user.following


def test_create_tag():
    tags = seed_tags(uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_tags = uow.reels.get_tags(tag_ids=[t.id for t in tags])

        assert tags == fetched_tags


def test_create_reel_without_tags():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        assert reel.id == fetched_reel.id
        assert reel.user_id == fetched_reel.user_id
        assert reel.video_url == fetched_reel.video_url
        assert reel.location == fetched_reel.location
        assert reel.caption == fetched_reel.caption
        assert reel.description == fetched_reel.description
        assert reel.thumbnail_url == fetched_reel.thumbnail_url
        assert reel.tags == fetched_reel.tags


def test_create_reel_with_tags():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    tags = seed_tags(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(
        user_id=user.id,
        tags=tags,
        uow=unit_of_work.UnitOfWork(),
    )

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        assert reel.id == fetched_reel.id
        assert reel.user_id == fetched_reel.user_id
        assert reel.video_url == fetched_reel.video_url
        assert reel.location == fetched_reel.location
        assert reel.caption == fetched_reel.caption
        assert reel.description == fetched_reel.description
        assert reel.thumbnail_url == fetched_reel.thumbnail_url
        assert reel.tags == fetched_reel.tags


def test_delete_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    delete_reel(reel_id=reel.id, uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        with pytest.raises(Exception):
            uow.reels.get(reel_id=reel.id)


def test_delete_reel_with_tags():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    tags = seed_tags(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(
        user_id=user.id,
        tags=tags,
        uow=unit_of_work.UnitOfWork(),
    )

    delete_reel(reel_id=reel.id, uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        with pytest.raises(Exception):
            uow.reels.get(reel_id=reel.id)


def test_view_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    view_reel(reel_id=reel.id, user_id=user.id, uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        assert fetched_reel.views == {user.id}


def test_like_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    like_reel(reel_id=reel.id, user_id=user.id, uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        assert fetched_reel.likes == {user.id}


def test_favourite_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    favourite_reel(reel_id=reel.id, user_id=user.id, uow=unit_of_work.UnitOfWork())

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        assert fetched_reel.favourites == {user.id}


def test_comment_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    comment = comment_reel(
        reel_id=reel.id,
        user_id=user.id,
        comment_text="Nice Reel",
        uow=unit_of_work.UnitOfWork(),
    )

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        # Removing time zone info
        fetched_reel.comments = {
            Comment(
                id=c.id,
                user_id=c.user_id,
                comment_text=c.comment_text,
                created_at=c.created_at.replace(tzinfo=None),
            )
            for c in fetched_reel.comments
        }
        assert fetched_reel.comments == {comment}


def test_report_reel():
    user = seed_user(uow=unit_of_work.UnitOfWork())
    reel = seed_reel(user_id=user.id, tags=set(), uow=unit_of_work.UnitOfWork())

    report = report_reel(
        reel_id=reel.id,
        user_id=user.id,
        report_text="In appropriate content",
        uow=unit_of_work.UnitOfWork(),
    )

    with unit_of_work.UnitOfWork() as uow:
        fetched_reel = uow.reels.get(reel_id=reel.id)

        # Removing time zone info
        fetched_reel.reports = {
            Report(
                id=r.id,
                user_id=r.user_id,
                report_text=r.report_text,
                created_at=r.created_at.replace(tzinfo=None),
            )
            for r in fetched_reel.reports
        }
        assert fetched_reel.reports == {report}
