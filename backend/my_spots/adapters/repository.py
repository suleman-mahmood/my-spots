from abc import ABC, abstractmethod
from typing import Dict, Set

from ..domain.model import User, Reel, Comment, Tag, Report


class UserAbstractRepository(ABC):
    @abstractmethod
    def add(self, user: User) -> None:
        pass

    @abstractmethod
    def get(self, user_id: str) -> User:
        pass

    @abstractmethod
    def save(self, user: User) -> None:
        pass


class FakeUserRepository(UserAbstractRepository):
    def __init__(self):
        self.users: Dict[str, User] = {}

    def add(self, user: User) -> None:
        self.users[user.id] = user

    def get(self, user_id: str) -> User:
        return self.users[user_id]

    def save(self, user: User) -> None:
        self.users[user.id] = user


class UserRepository(UserAbstractRepository):
    def __init__(self, connection):
        self.connection = connection
        self.cursor = connection.cursor()

    def add(self, user: User) -> None:
        sql = """
            insert into users (id, full_name, user_name, email, phone_number, profile_text, location, avatar_url, following, followers)
            values (%s, %s, %s, %s, %s, %s, '%s', %s, %s, %s)
        """
        self.cursor.execute(
            sql,
            [
                user.id,
                user.full_name,
                user.user_name,
                user.email,
                user.phone_number,
                user.profile_text,
                user.location,
                user.avatar_url,
                0,  # Following will be 0 when a new user is created
                0,  # Followers will be 0 when a new user is created
            ],
        )

    def get(self, user_id: str) -> User:
        sql = """
            select id, full_name, user_name, email, phone_number, profile_text, location, avatar_url
            from users
            where id = %s
        """
        self.cursor.execute(sql, [user_id])
        row = self.cursor.fetchone()

        if row is None:
            raise Exception(f"No such user exists for the given user_id ${user_id}")

        user = User(
            id=row[0],
            full_name=row[1],
            user_name=row[2],
            email=row[3],
            phone_number=row[4],
            profile_text=row[5],
            location=tuple(float(r) for r in row[6][1:-1].split(",")),
            avatar_url=row[7],
        )

        # Fetching followers
        sql = """
            select from_id
            from followers
            where to_id = %s
        """
        self.cursor.execute(sql, [user_id])
        rows = self.cursor.fetchall()
        user.followers = {r[0] for r in rows}

        # Fetching following
        sql = """
            select to_id
            from followers
            where from_id = %s
        """
        self.cursor.execute(sql, [user_id])
        rows = self.cursor.fetchall()
        user.following = {r[0] for r in rows}

        return user

    def save(self, user: User) -> None:
        sql = """
            insert into users (id, full_name, user_name, email, phone_number, profile_text, location, avatar_url, following, followers)
            values (%s, %s, %s, %s, %s, %s, '%s', %s, %s, %s)
            on conflict (id) do update set
                full_name = excluded.full_name,
                user_name = excluded.user_name,
                email = excluded.email,
                phone_number = excluded.phone_number,
                profile_text = excluded.profile_text,
                location = excluded.location,
                avatar_url = excluded.avatar_url,
                following = excluded.following,
                followers = excluded.followers
        """
        self.cursor.execute(
            sql,
            [
                user.id,
                user.full_name,
                user.user_name,
                user.email,
                user.phone_number,
                user.profile_text,
                user.location,
                user.avatar_url,
                len(user.following),
                len(user.followers),
            ],
        )

        # Only following is changed, followers are unchanged
        sql = """
            delete from followers
            where from_id = %s
        """
        self.cursor.execute(sql, [user.id])

        if len(user.following) != 0:
            sql = """
                insert into followers (from_id, to_id)
                values
            """
            args = [(user.id, f) for f in user.following]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str))


class ReelAbstractRepository(ABC):
    @abstractmethod
    def add(self, reel: Reel) -> None:
        pass

    @abstractmethod
    def add_tag(self, tag: Tag) -> None:
        pass

    @abstractmethod
    def get(self, reel_id: str) -> Reel:
        pass

    @abstractmethod
    def get_tags(self, tag_ids: str) -> Set[Tag]:
        pass

    @abstractmethod
    def delete(self, reel_id: str) -> None:
        pass

    @abstractmethod
    def save(self, reel: Reel) -> None:
        pass


class FakeReelRepository(ReelAbstractRepository):
    def __init__(self):
        self.reels: Dict[str, Reel] = {}

    def add(self, reel: Reel) -> None:
        self.reels[reel.id] = reel

    def get(self, reel_id: str) -> Reel:
        return self.reels[reel_id]

    def delete(self, reel_id: str) -> None:
        self.reels.pop(reel_id)

    def save(self, reel: Reel) -> None:
        self.reels[reel.id] = reel


class ReelRepository(ReelAbstractRepository):
    def __init__(self, connection):
        self.connection = connection
        self.cursor = connection.cursor()

    def add(self, reel: Reel) -> None:
        sql = """
            insert into reels (id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at, likes, views)
            values (%s, %s, %s, '%s', %s, %s, %s, %s, %s, %s, %s)
        """
        self.cursor.execute(
            sql,
            [
                reel.id,
                reel.user_id,
                reel.video_url,
                reel.location,
                reel.caption,
                reel.description,
                reel.thumbnail_url,
                reel.banned,
                reel.created_at,
                0,  # Likes will be 0 when a new reel is created
                0,  # Views will be 0 when a new reel is created
            ],
        )

        if len(reel.tags) != 0:
            sql = """
                insert into reels_tags (reel_id, tag_id)
                values
            """
            args = [(reel.id, t.id) for t in reel.tags]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str))

    def add_tag(self, tag: Tag):
        sql = """
            insert into tags (id, tag_name)
            values (%s, %s)
        """
        self.cursor.execute(sql, [tag.id, tag.tag_name])

    def get(self, reel_id: str) -> Reel:
        sql = """
            select id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at
            from reels
            where id = %s
        """
        self.cursor.execute(sql, [reel_id])
        row = self.cursor.fetchone()

        if row is None:
            raise Exception(f"No such reel exists for the given reel_id ${reel_id}")

        reel = Reel(
            id=row[0],
            user_id=row[1],
            video_url=row[2],
            location=tuple(float(r) for r in row[3][1:-1].split(",")),
            caption=row[4],
            description=row[5],
            thumbnail_url=row[6],
            banned=row[7],
            created_at=row[8],
        )

        sql = """
            select id, tag_name
            from tags
            where id in (
                select tag_id
                from reels_tags
                where reel_id = %s
            )
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.tags = {Tag(id=r[0], tag_name=r[1]) for r in rows}

        sql = """
            select user_id
            from likes
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.likes = {r[0] for r in rows}

        sql = """
            select user_id
            from views
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.views = {r[0] for r in rows}

        sql = """
            select user_id
            from favourites
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.favourites = {r[0] for r in rows}

        sql = """
            select id, user_id, comment_text, created_at
            from comments
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.comments = {
            Comment(id=r[0], user_id=r[1], comment_text=r[2], created_at=r[3])
            for r in rows
        }

        sql = """
            select id, user_id, report_text, created_at
            from reports
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])
        rows = self.cursor.fetchall()
        reel.reports = {
            Report(id=r[0], user_id=r[1], report_text=r[2], created_at=r[3])
            for r in rows
        }

        return reel

    def get_tags(self, tag_ids: str) -> Set[Tag]:
        sql = """
            select id, tag_name
            from tags
            where id in %s
        """
        self.cursor.execute(sql, [tuple(tag_ids)])
        rows = self.cursor.fetchall()

        return {Tag(id=r[0], tag_name=r[1]) for r in rows}

    def delete(self, reel_id: str) -> None:
        sql = """
            delete from reels_tags
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel_id])

        sql = """
            delete from reels
            where id = %s
        """
        self.cursor.execute(sql, [reel_id])

    def save(self, reel: Reel) -> None:
        sql = """
            insert into reels (id, user_id, video_url, location, caption, description, thumbnail_url, banned, created_at, likes, views)
            values (%s, %s, %s, '%s', %s, %s, %s, %s, %s, %s, %s)
            on conflict (id) do update set
                user_id = excluded.user_id,
                video_url = excluded.video_url,
                location = excluded.location,
                caption = excluded.caption,
                description = excluded.description,
                thumbnail_url = excluded.thumbnail_url,
                banned = excluded.banned,
                created_at = excluded.created_at,
                likes = excluded.likes,
                views = excluded.views
        """
        self.cursor.execute(
            sql,
            [
                reel.id,
                reel.user_id,
                reel.video_url,
                reel.location,
                reel.caption,
                reel.description,
                reel.thumbnail_url,
                reel.banned,
                reel.created_at,
                len(reel.likes),
                len(reel.views),
            ],
        )

        # Upserting tags

        sql = """
            delete from reels_tags
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel.id])

        if len(reel.tags) != 0:
            sql = """
                insert into reels_tags (reel_id, tag_id)
                values
            """
            args = [(reel.id, t.id) for t in reel.tags]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str))

        # Upserting likes

        sql = """
            delete from likes
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel.id])

        if len(reel.likes) != 0:
            sql = """
                insert into likes (user_id, reel_id)
                values
            """
            args = [(l, reel.id) for l in reel.likes]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str))

        # Upserting views

        if len(reel.views) != 0:
            sql = """
                insert into views (user_id, reel_id)
                values
            """
            sql_2 = """
                on conflict (user_id, reel_id) do nothing
            """
            args = [(v, reel.id) for v in reel.views]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str) + sql_2)

        # Upserting favourites

        sql = """
            delete from favourites
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel.id])

        if len(reel.favourites) != 0:
            sql = """
                insert into favourites (user_id, reel_id)
                values
            """
            args = [(f, reel.id) for f in reel.favourites]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str))

        # Upserting comments

        sql = """
            delete from comments
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel.id])

        if len(reel.comments) != 0:
            sql = """
                insert into comments (id, user_id, reel_id, comment_text, created_at)
                values
            """
            sql_2 = """
                on conflict (id) do update set
                    user_id = excluded.user_id,
                    reel_id = excluded.reel_id,
                    comment_text = excluded.comment_text,
                    created_at = excluded.created_at
            """
            args = [
                (c.id, c.user_id, reel.id, c.comment_text, c.created_at)
                for c in reel.comments
            ]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s,%s,%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str) + sql_2)

        # Upserting reports

        sql = """
            delete from reports
            where reel_id = %s
        """
        self.cursor.execute(sql, [reel.id])

        if len(reel.reports) != 0:
            sql = """
                insert into reports (id, user_id, reel_id, report_text, created_at)
                values
            """
            sql_2 = """
                on conflict (id) do update set
                    user_id = excluded.user_id,
                    reel_id = excluded.reel_id,
                    report_text = excluded.report_text,
                    created_at = excluded.created_at
            """
            args = [
                (r.id, r.user_id, reel.id, r.report_text, r.created_at)
                for r in reel.reports
            ]
            args_str = ",".join(
                self.cursor.mogrify("(%s,%s,%s,%s,%s)", x).decode("utf-8") for x in args
            )
            self.cursor.execute(sql + (args_str) + sql_2)
