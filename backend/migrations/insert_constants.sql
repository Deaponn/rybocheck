INSERT INTO roles(role_name)
VALUES
('administrator'),
('moderator'),
('trusted-user'),
('user');

INSERT INTO user_statuses(status_name)
VALUES
('active'),
('private'),
('reported'),
('banned'),
('deleted');

INSERT INTO post_statuses(status_name)
VALUES
('public'),
('private'),
('reported'),
('deleted');

INSERT INTO comment_statuses(status_name)
VALUES
('public'),
('private'),
('pinned'),
('edited'),
('reported'),
('deleted');
