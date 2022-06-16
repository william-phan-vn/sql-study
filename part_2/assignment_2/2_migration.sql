--------------------------------------------------------------------
--------------------------  DATA MIGRATION -------------------------
--------------------------------------------------------------------
-------------------- 1. Migrate users: 100 records-----------
-- Migrate users that have posts: 100 records
INSERT INTO users (username)
SELECT DISTINCT bp.username
FROM bad_posts bp
ORDER BY bp.username;

-- Migrate users that don't have post but have upvote: 1,000 records
WITH upvote_users
AS (
	SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(bp.upvotes, ',') upvote_user
	FROM bad_posts bp
	)
INSERT INTO users (username)
SELECT DISTINCT uu.upvote_user
FROM upvote_users uu
WHERE NOT EXISTS (
		SELECT username
		FROM users u
		WHERE uu.upvote_user = u.username
		)
ORDER BY uu.upvote_user;

-- Migrate users that don't have post but have downvote: 0 records
WITH downvote_users
AS (
	SELECT DISTINCT REGEXP_SPLIT_TO_TABLE(bp.downvotes, ',') downvote_user
	FROM bad_posts bp
	)
INSERT INTO users (username)
SELECT DISTINCT du.downvote_user
FROM downvote_users du
WHERE NOT EXISTS (
		SELECT username u
		FROM users u
		WHERE du.downvote_user = u.username
		)
ORDER BY du.downvote_user;

-- Migrate users that don't have post/vote but have comment(s): 9,977 records
WITH comment_users
AS (
	SELECT DISTINCT username comment_user
	FROM bad_comments
	)
INSERT INTO users (username)
SELECT DISTINCT cu.comment_user
FROM comment_users cu
WHERE NOT EXISTS (
		SELECT username u
		FROM users u
		WHERE cu.comment_user = u.username
		)
ORDER BY cu.comment_user;

-- Check
SELECT *
FROM users LIMIT 5;

SELECT *
FROM bad_comments u
WHERE u.username = 'Liliane.Lakin40';

SELECT count(*)
FROM users LIMIT 5;

-------------- 2. Migrate topics: 8,844 records ---------------
INSERT INTO topics (
	name
	,username
	)
SELECT DISTINCT bp.topic
	,username
FROM bad_posts bp
ORDER BY bp.topic
	,bp.username;

-- Check
SELECT *
FROM topics LIMIT 5;

-------------- 3. Migrate posts: 50,000 records ---------------
INSERT INTO posts (
	id
	,title
	,url
	,text_content
	,topic_name
	,username
	)
SELECT bp.id
	,SUBSTRING(bp.title, 1, 100) title
	,bp.url
	,bp.text_content
	,bp.topic
	,bp.username
FROM bad_posts bp
ORDER BY bp.topic
	,bp.username;

-- Check
SELECT *
FROM posts LIMIT 5;

-------------- 4. Migrate comments: 100,000 records -----------
INSERT INTO comments (
	id
	,username
	,post_id
	,text_content
	)
SELECT *
FROM bad_comments;

-------------- 5. Migrate votes: ------------------------------
-- Migrate upvotes: 249,799 records
INSERT INTO votes (
	vote
	,post_id
	,username
	)
SELECT 1 upvote_value
	,bp.id
	,REGEXP_SPLIT_TO_TABLE(bp.upvotes, ',') upvote_user
FROM bad_posts bp
ORDER BY bp.username
	,bp.id;

-- Migrate downvotes: 249,911 records
INSERT INTO votes (
	vote
	,post_id
	,username
	)
SELECT - 1 downvote_value
	,bp.id
	,REGEXP_SPLIT_TO_TABLE(bp.downvotes, ',') downvote_user
FROM bad_posts bp
ORDER BY bp.username
	,bp.id;

-- Check
SELECT *
FROM votes LIMIT 5;
