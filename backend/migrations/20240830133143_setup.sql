-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-08-30 14:21:37.786

-- tables
-- Table: comment_likes
CREATE TABLE comment_likes (
    user_id integer  NOT NULL,
    comment_id integer  NOT NULL,
    liked_at timestamp  NOT NULL DEFAULT current_timestamp,
    CONSTRAINT comments_likes_pk PRIMARY KEY (user_id,comment_id)
);

CREATE INDEX comments_likes_user_id on comment_likes (user_id ASC);

CREATE INDEX comments_likes_comment_id on comment_likes (comment_id ASC);

-- Table: comment_statuses
CREATE TABLE comment_statuses (
    status_id serial  NOT NULL,
    status_name varchar(64)  NOT NULL,
    CONSTRAINT comment_statuses_pk PRIMARY KEY (status_id)
);

-- Table: comments
CREATE TABLE comments (
    comment_id serial  NOT NULL,
    user_id integer  NOT NULL,
    post_id integer  NOT NULL,
    reply_to integer  NULL,
    body text  NOT NULL,
    status_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT current_timestamp,
    CONSTRAINT comments_pk PRIMARY KEY (comment_id)
);

CREATE INDEX comments_user_id on comments (user_id ASC);

CREATE INDEX comments_post_id on comments (post_id ASC);

CREATE INDEX comments_status_id on comments (status_id ASC);

CREATE INDEX comments_reply_to on comments (reply_to ASC);

-- Table: post_likes
CREATE TABLE post_likes (
    user_id integer  NOT NULL,
    post_id integer  NOT NULL,
    liked_at timestamp  NOT NULL,
    CONSTRAINT post_likes_pk PRIMARY KEY (user_id,post_id)
);

CREATE UNIQUE INDEX post_likes_user_id on post_likes (user_id ASC);

CREATE INDEX post_likes_post_id on post_likes (post_id ASC);

-- Table: post_statuses
CREATE TABLE post_statuses (
    status_id serial  NOT NULL,
    status_name varchar(64)  NOT NULL,
    CONSTRAINT post_statuses_pk PRIMARY KEY (status_id)
);

-- Table: post_tags
CREATE TABLE post_tags (
    post_id int  NOT NULL,
    tag_id int  NOT NULL,
    CONSTRAINT post_tags_pk PRIMARY KEY (post_id,tag_id)
);

CREATE INDEX post_tags_post_id on post_tags (post_id ASC);

CREATE INDEX post_tags_tag_id on post_tags (tag_id ASC);

-- Table: posts
CREATE TABLE posts (
    post_id serial  NOT NULL,
    user_id int  NOT NULL,
    title varchar(255)  NOT NULL,
    description text  NULL,
    location varchar(32)  NOT NULL,
    is_location_verified bool  NOT NULL,
    photo_path varchar(255)  NULL,
    status_id int  NOT NULL,
    tag_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT current_timestamp,
    CONSTRAINT posts_pk PRIMARY KEY (post_id)
);

CREATE INDEX posts_status_id on posts (status_id ASC);

CREATE INDEX posts_user_id on posts (user_id ASC);

-- Table: roles
CREATE TABLE roles (
    role_id serial  NOT NULL,
    role_name varchar(64)  NOT NULL,
    CONSTRAINT roles_pk PRIMARY KEY (role_id)
);

-- Table: tags
CREATE TABLE tags (
    tag_id serial  NOT NULL,
    tag_name int  NOT NULL,
    CONSTRAINT tags_pk PRIMARY KEY (tag_id)
);

-- Table: user_data
CREATE TABLE user_data (
    user_id int  NOT NULL,
    email varchar(255)  NULL,
    phone_number varchar(32)  NOT NULL,
    description text  NULL,
    profile_picture_path varchar(255)  NULL,
    settings text  NULL,
    CONSTRAINT users_data_pk PRIMARY KEY (user_id)
);

-- Table: user_statuses
CREATE TABLE user_statuses (
    status_id serial  NOT NULL,
    status_name varchar(64)  NOT NULL,
    CONSTRAINT user_statuses_pk PRIMARY KEY (status_id)
);

-- Table: users
CREATE TABLE users (
    user_id serial  NOT NULL,
    username varchar(255)  NOT NULL,
    password_hash varchar(255)  NOT NULL,
    role_id int  NOT NULL,
    status_id int  NOT NULL,
    created_at timestamp  NOT NULL DEFAULT current_timestamp,
    CONSTRAINT users_pk PRIMARY KEY (user_id)
);

CREATE INDEX users_role_id on users (role_id ASC);

CREATE INDEX users_status_id on users (status_id ASC);

-- foreign keys
-- Reference: comment_statuses_comments (table: comments)
ALTER TABLE comments ADD CONSTRAINT comment_statuses_comments
    FOREIGN KEY (status_id)
    REFERENCES comment_statuses (status_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: comments_comments (table: comments)
ALTER TABLE comments ADD CONSTRAINT comments_comments
    FOREIGN KEY (reply_to)
    REFERENCES comments (comment_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: comments_comments_likes (table: comment_likes)
ALTER TABLE comment_likes ADD CONSTRAINT comments_comments_likes
    FOREIGN KEY (comment_id)
    REFERENCES comments (comment_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: comments_likes_users (table: comment_likes)
ALTER TABLE comment_likes ADD CONSTRAINT comments_likes_users
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: post_tags_tags (table: post_tags)
ALTER TABLE post_tags ADD CONSTRAINT post_tags_tags
    FOREIGN KEY (tag_id)
    REFERENCES tags (tag_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: posts_comments (table: comments)
ALTER TABLE comments ADD CONSTRAINT posts_comments
    FOREIGN KEY (post_id)
    REFERENCES posts (post_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: posts_post_likes (table: post_likes)
ALTER TABLE post_likes ADD CONSTRAINT posts_post_likes
    FOREIGN KEY (post_id)
    REFERENCES posts (post_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: posts_post_statuses (table: posts)
ALTER TABLE posts ADD CONSTRAINT posts_post_statuses
    FOREIGN KEY (status_id)
    REFERENCES post_statuses (status_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: posts_post_tags (table: post_tags)
ALTER TABLE post_tags ADD CONSTRAINT posts_post_tags
    FOREIGN KEY (post_id)
    REFERENCES posts (post_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: roles_users (table: users)
ALTER TABLE users ADD CONSTRAINT roles_users
    FOREIGN KEY (role_id)
    REFERENCES roles (role_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: user_statuses_users (table: users)
ALTER TABLE users ADD CONSTRAINT user_statuses_users
    FOREIGN KEY (status_id)
    REFERENCES user_statuses (status_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_comments (table: comments)
ALTER TABLE comments ADD CONSTRAINT users_comments
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_data_users (table: user_data)
ALTER TABLE user_data ADD CONSTRAINT users_data_users
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_post_likes (table: post_likes)
ALTER TABLE post_likes ADD CONSTRAINT users_post_likes
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: users_posts (table: posts)
ALTER TABLE posts ADD CONSTRAINT users_posts
    FOREIGN KEY (user_id)
    REFERENCES users (user_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

