drop table if exists reels cascade;
drop table if exists users cascade;
drop table if exists followers cascade;
drop table if exists reels_tags cascade;
drop table if exists tags cascade;
drop table if exists likes cascade;
drop table if exists views cascade;
drop table if exists comments cascade;
drop table if exists favourites cascade;
drop table if exists reports cascade;

-- drop type if exists bot_state_enum cascade;

-- create type bot_state_enum as enum ('IDLE', 'RUNNING', 'FINISHED', 'TERMINATED');

create table users (
    id uuid,
    full_name varchar(500),
    user_name varchar(500),
    email varchar(500),
    phone_number varchar(500),
    profile_text varchar(500),
    location point,
    avatar_url varchar(500),
    following numeric,
    followers numeric,

    primary key (id)
);

create table reels (
    id uuid,
    user_id uuid,
    video_url varchar(500),
    location point,
    spot_name varchar(500),
    caption varchar(500),
    description varchar(500),
    thumbnail_url varchar(500),
    banned boolean,
    created_at timestamp with time zone,
    likes numeric,
    views numeric,
    comments numeric,
    favourites numeric,

    primary key (id),
    foreign key (user_id)
        references users(id)
);

create table followers (
    from_id uuid,
    to_id uuid,

    primary key (from_id, to_id),
    foreign key (from_id)
        references users(id),
    foreign key (to_id)
        references users(id)
);

create table reels_tags (
    reel_id uuid,
    tag_id uuid,

    primary key (reel_id, tag_id),
    foreign key (reel_id)
        references reels(id)
);

create table tags (
    id uuid,
    tag_name varchar(500),

    primary key (id)
);

create table likes (
    user_id uuid,
    reel_id uuid,

    primary key (user_id, reel_id),
    foreign key (user_id)
        references users(id),
    foreign key (reel_id)
        references reels(id)
);

create table views (
    user_id uuid,
    reel_id uuid,

    primary key (user_id, reel_id),
    foreign key (user_id)
        references users(id),
    foreign key (reel_id)
        references reels(id)
);

create table favourites (
    user_id uuid,
    reel_id uuid,

    primary key (user_id, reel_id),
    foreign key (user_id)
        references users(id),
    foreign key (reel_id)
        references reels(id)
);

create table comments (
    id uuid,
    user_id uuid,
    reel_id uuid,
    comment_text varchar(500),
    created_at timestamp with time zone,

    primary key (id),
    foreign key (user_id)
        references users(id),
    foreign key (reel_id)
        references reels(id)
);

create table reports (
    id uuid,
    user_id uuid,
    reel_id uuid,
    report_text varchar(500),
    created_at timestamp with time zone,

    primary key (id),
    foreign key (user_id)
        references users(id),
    foreign key (reel_id)
        references reels(id)
);