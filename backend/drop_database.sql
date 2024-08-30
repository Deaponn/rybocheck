-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-08-19 22:02:25.766

-- foreign keys
ALTER TABLE comments
    DROP CONSTRAINT comment_statuses_comments;

ALTER TABLE comments
    DROP CONSTRAINT comments_comments;

ALTER TABLE comment_likes
    DROP CONSTRAINT comments_comments_likes;

ALTER TABLE comment_likes
    DROP CONSTRAINT comments_likes_users;

ALTER TABLE post_tags
    DROP CONSTRAINT post_tags_tags;

ALTER TABLE comments
    DROP CONSTRAINT posts_comments;

ALTER TABLE post_likes
    DROP CONSTRAINT posts_post_likes;

ALTER TABLE posts
    DROP CONSTRAINT posts_post_statuses;

ALTER TABLE post_tags
    DROP CONSTRAINT posts_post_tags;

ALTER TABLE users
    DROP CONSTRAINT roles_users;

ALTER TABLE users
    DROP CONSTRAINT user_statuses_users;

ALTER TABLE comments
    DROP CONSTRAINT users_comments;

ALTER TABLE user_data
    DROP CONSTRAINT users_data_users;

ALTER TABLE post_likes
    DROP CONSTRAINT users_post_likes;

ALTER TABLE posts
    DROP CONSTRAINT users_posts;

-- tables
DROP TABLE comment_likes;

DROP TABLE comment_statuses;

DROP TABLE comments;

DROP TABLE post_likes;

DROP TABLE post_statuses;

DROP TABLE post_tags;

DROP TABLE posts;

DROP TABLE roles;

DROP TABLE tags;

DROP TABLE user_data;

DROP TABLE user_statuses;

DROP TABLE users;

-- End of file.

