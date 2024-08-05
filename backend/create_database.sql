-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-08-05 18:16:41.804

-- tables
-- Table: comment_statuses
CREATE TABLE comment_statuses (
    status_id int  NOT NULL AUTO_INCREMENT,
    status_name varchar(63)  NOT NULL,
    CONSTRAINT comment_statuses_pk PRIMARY KEY (status_id)
);

-- Table: comments
CREATE TABLE comments (
    comment_id integer  NOT NULL AUTO_INCREMENT,
    user_id integer  NOT NULL,
    post_id integer  NOT NULL,
    reply_to integer  NOT NULL,
    body text  NOT NULL,
    status_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT comments_pk PRIMARY KEY (comment_id)
);

-- Table: comments_likes
CREATE TABLE comments_likes (
    user_id integer  NOT NULL,
    comment_id integer  NOT NULL,
    liked_at timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT comments_likes_pk PRIMARY KEY (user_id,comment_id)
);

-- Table: post_likes
CREATE TABLE post_likes (
    user_id integer  NOT NULL,
    post_id integer  NOT NULL,
    liked_at timestamp  NOT NULL,
    CONSTRAINT post_likes_pk PRIMARY KEY (user_id,post_id)
);

-- Table: post_statuses
CREATE TABLE post_statuses (
    status_id int  NOT NULL AUTO_INCREMENT,
    status_name varchar(63)  NOT NULL,
    CONSTRAINT post_statuses_pk PRIMARY KEY (status_id)
);

-- Table: posts
CREATE TABLE posts (
    post_id int  NOT NULL AUTO_INCREMENT,
    user_id int  NOT NULL,
    title varchar(255)  NOT NULL,
    description text  NULL,
    location varchar(31)  NOT NULL,
    is_location_verified bool  NOT NULL,
    photo_path varchar(255)  NULL,
    status_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT posts_pk PRIMARY KEY (post_id)
);

-- Table: roles
CREATE TABLE roles (
    role_id int  NOT NULL AUTO_INCREMENT,
    role_name varchar(63)  NOT NULL,
    CONSTRAINT roles_pk PRIMARY KEY (role_id)
) COMMENT '''''user'''',''''moderator'''',''''administrator''''';

-- Table: user_statuses
CREATE TABLE user_statuses (
    status_id int  NOT NULL AUTO_INCREMENT,
    status_name varchar(63)  NOT NULL,
    CONSTRAINT user_statuses_pk PRIMARY KEY (status_id)
) COMMENT '''''untrusted'''',''''trusted'''',''''deleted'''',''''banned''''';

-- Table: users
CREATE TABLE users (
    user_id int  NOT NULL AUTO_INCREMENT,
    username varchar(255)  NOT NULL,
    role_id int  NOT NULL,
    status_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    CONSTRAINT users_pk PRIMARY KEY (user_id)
);

-- Table: users_data
CREATE TABLE users_data (
    user_id int  NOT NULL,
    email varchar(255)  NULL,
    description text  NULL,
    profile_picture_path varchar(255)  NULL,
    settings text  NULL,
    CONSTRAINT users_data_pk PRIMARY KEY (user_id)
);

-- foreign keys
-- Reference: FK_0 (table: posts)
ALTER TABLE posts ADD CONSTRAINT FK_0 FOREIGN KEY FK_0 (user_id)
    REFERENCES users (user_id);

-- Reference: FK_1 (table: comments)
ALTER TABLE comments ADD CONSTRAINT FK_1 FOREIGN KEY FK_1 (user_id)
    REFERENCES users (user_id);

-- Reference: FK_2 (table: post_likes)
ALTER TABLE post_likes ADD CONSTRAINT FK_2 FOREIGN KEY FK_2 (user_id)
    REFERENCES users (user_id);

-- Reference: FK_3 (table: comments_likes)
ALTER TABLE comments_likes ADD CONSTRAINT FK_3 FOREIGN KEY FK_3 (user_id)
    REFERENCES users (user_id);

-- Reference: FK_4 (table: post_likes)
ALTER TABLE post_likes ADD CONSTRAINT FK_4 FOREIGN KEY FK_4 (post_id)
    REFERENCES posts (post_id);

-- Reference: FK_5 (table: comments)
ALTER TABLE comments ADD CONSTRAINT FK_5 FOREIGN KEY FK_5 (post_id)
    REFERENCES posts (post_id);

-- Reference: FK_6 (table: comments_likes)
ALTER TABLE comments_likes ADD CONSTRAINT FK_6 FOREIGN KEY FK_6 (comment_id)
    REFERENCES comments (comment_id);

-- Reference: comment_statuses_comments (table: comments)
ALTER TABLE comments ADD CONSTRAINT comment_statuses_comments FOREIGN KEY comment_statuses_comments (status_id)
    REFERENCES comment_statuses (status_id);

-- Reference: post_statuses_posts (table: posts)
ALTER TABLE posts ADD CONSTRAINT post_statuses_posts FOREIGN KEY post_statuses_posts (status_id)
    REFERENCES post_statuses (status_id);

-- Reference: reply_ref (table: comments)
ALTER TABLE comments ADD CONSTRAINT reply_ref FOREIGN KEY reply_ref (comment_id)
    REFERENCES comments (comment_id);

-- Reference: roles_users (table: users)
ALTER TABLE users ADD CONSTRAINT roles_users FOREIGN KEY roles_users (role_id)
    REFERENCES roles (role_id);

-- Reference: statuses_users (table: users)
ALTER TABLE users ADD CONSTRAINT statuses_users FOREIGN KEY statuses_users (status_id)
    REFERENCES user_statuses (status_id);

-- Reference: users_users_data (table: users)
ALTER TABLE users ADD CONSTRAINT users_users_data FOREIGN KEY users_users_data (user_id)
    REFERENCES users_data (user_id);

-- End of file.

