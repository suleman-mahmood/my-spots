from dataclasses import dataclass, field
from datetime import datetime
from typing import List, Tuple, Set

# from uuid import uuid4
# from enum import Enum

# ///// ///// ///// ///// ///// ///// ///// ///// ///// /////
# Use cases for MySpots
# \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\

# - Create a new user account
# - Update user account (eg name, phone_number etc)
# - Fetch user account

# - Follow/Unfollow other users

# - Create a new reel
# - Delete reel

# - Watch a reel
# - Like a reel
# - Comment on a reel
# - Favourite a reel
# - Report a reel

# - Nearest (Explore) reels, gets a list of reels based on user's location
# - Followers reels, gets a list of reels from users the user follows
# - User reels, gets all reels for a specific user
# - Search reels, gets a list of reels based on search query
# - Tag reels, gets a list of reels based on a tag

# - For future upgrades
#     - Explore reels, gets a list of reels recommended for the user
#     - Trending reels, gets a list of reels based on popularity

# ///// ///// ///// ///// ///// ///// ///// ///// ///// /////
# Use cases for Users
# \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\

# - Create a new user account
# - Update user account (eg name, phone_number etc)
# - Fetch user account

# - Follow/Unfollow other users


@dataclass
class User:
    id: str
    full_name: str
    user_name: str
    email: str
    phone_number: str
    profile_text: str  # Bio
    location: Tuple[float, float]
    avatar_url: str
    following: Set[str] = field(default_factory=set)
    followers: Set[str] = field(default_factory=set)

    @property
    def followers_count(self):
        return len(self.followers)

    @property
    def following_count(self):
        return len(self.following)

    def follow_user(self, user_id: str):
        self.following.add(user_id)


# ///// ///// ///// ///// ///// ///// ///// ///// ///// /////
# Use cases for Reels
# \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\ \\\\\

# - Create a new reel
# - Delete reel

# - Watch a reel
# - Like a reel
# - Comment on a reel
# - Favourite a reel
# - Report a reel

# - Nearest (Explore) reels, gets a list of reels based on user's location
# - Followers reels, gets a list of reels from users the user follows
# - User reels, gets all reels for a specific user
# - Search reels, gets a list of reels based on search query
# - Tag reels, gets a list of reels based on a tag

# - For future upgrades
#     - Explore reels, gets a list of reels recommended for the user
#     - Trending reels, gets a list of reels based on popularity


@dataclass(frozen=True)
class Tag:
    id: str
    tag_name: str


@dataclass(frozen=True)
class Comment:
    id: str
    user_id: str
    comment_text: str
    created_at: datetime = field(default_factory=datetime.now)


@dataclass(frozen=True)
class Report:
    id: str
    user_id: str
    report_text: str
    created_at: datetime = field(default_factory=datetime.now)


@dataclass
class Reel:
    id: str
    user_id: str
    video_url: str
    location: Tuple[float, float]
    caption: str
    description: str
    thumbnail_url: str
    banned: bool = False
    tags: Set[Tag] = field(default_factory=set)
    likes: Set[str] = field(default_factory=set)
    views: Set[str] = field(default_factory=set)
    comments: Set[Comment] = field(default_factory=set)
    favourites: Set[str] = field(default_factory=set)
    created_at: datetime = field(default_factory=datetime.now)
    reports: Set[Report] = field(default_factory=set)

    @property
    def likes_count(self):
        return len(self.likes)

    @property
    def comments_count(self):
        return len(self.comments)

    @property
    def favourites_count(self):
        return len(self.favourites)

    def view_reel(self, user_id: str):
        self.views.add(user_id)

    def like_reel(self, user_id: str):
        self.likes.add(user_id)

    def favourite_reel(self, user_id: str):
        self.favourites.add(user_id)

    def comment_reel(self, comment: Comment):
        self.comments.add(comment)

    def report_reel(self, report: Report):
        self.reports.add(report)
