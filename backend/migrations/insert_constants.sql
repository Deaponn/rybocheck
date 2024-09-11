INSERT INTO roles(role_name)
SELECT * FROM (
    VALUES
    ('administrator'),
    ('moderator'),
    ('trusted-user'),
    ('user')
) AS tmp
WHERE NOT EXISTS (
    SELECT NULL FROM roles
);

INSERT INTO user_statuses(status_name)
SELECT * FROM (
    VALUES
    ('active'),
    ('private'),
    ('reported'),
    ('banned'),
    ('deleted')
) AS tmp
WHERE NOT EXISTS (
    SELECT NULL FROM user_statuses
);

INSERT INTO post_statuses(status_name)
SELECT * FROM (
VALUES
    ('public'),
    ('private'),
    ('reported'),
    ('deleted')
) AS tmp
WHERE NOT EXISTS (
    SELECT NULL FROM post_statuses
);

INSERT INTO comment_statuses(status_name)
SELECT * FROM (
    VALUES
    ('public'),
    ('private'),
    ('pinned'),
    ('edited'),
    ('reported'),
    ('deleted')
) AS tmp
WHERE NOT EXISTS (
    SELECT NULL FROM comment_statuses
);
