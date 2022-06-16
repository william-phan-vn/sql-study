-- 1. Create Users table
CREATE TABLE "users" (
	username VARCHAR(25) PRIMARY KEY
	,last_login TIMESTAMP
	,created_at TIMESTAMP DEFAULT NOW()
	,CHECK (LENGTH(TRIM("username")) > 0)
	);

CREATE INDEX "user_by_last_login_index" ON "users" ("last_login");

-- 2. Create Topics table
CREATE TABLE "topics" (
	name VARCHAR(30) NOT NULL
	,username VARCHAR(25) NOT NULL
	,description VARCHAR(500) DEFAULT NULL
	,created_at TIMESTAMP DEFAULT NOW()
	,CHECK (LENGTH(TRIM(name)) > 0)
	,CONSTRAINT unique_topic_user UNIQUE (
		name
		,username
		)
	,PRIMARY KEY (
		name
		,username
		)
	,FOREIGN KEY ("username") REFERENCES "users" ("username") ON DELETE
	SET NULL
	);

CREATE INDEX "topics_by_name_index" ON "topics" ("name");

CREATE INDEX "topics_by_user_index" ON "topics" ("username");

-- 3. Create Posts table
CREATE TABLE "posts" (
	id SERIAL PRIMARY KEY
	,topic_name VARCHAR(30) NOT NULL
	,username VARCHAR(25) NOT NULL
	,title VARCHAR(100) NOT NULL
	,url VARCHAR(4000) DEFAULT NULL
	,text_content TEXT DEFAULT NULL
	,created_at TIMESTAMP DEFAULT NOW()
	,CHECK (LENGTH(TRIM("title")) > 0)
	,CHECK (
		(
			url IS NOT NULL
			AND text_content IS NULL
			)
		OR (
			url IS NULL
			AND text_content IS NOT NULL
			)
		)
	,FOREIGN KEY (
		topic_name
		,username
		) REFERENCES "topics" (
		name
		,username
		) ON DELETE CASCADE
	,FOREIGN KEY (username) REFERENCES "users" (username) ON DELETE SET
	NULL
	);

CREATE INDEX "posts_by_user_index" ON "posts" ("username");

CREATE INDEX "posts_by_topic_index" ON "posts" ("topic_name");

CREATE INDEX "posts_by_url_index" ON "posts" ("url");

-- 4. Create Comments table
CREATE TABLE "comments" (
	id SERIAL PRIMARY KEY
	,text_content TEXT NOT NULL
	,created_at TIMESTAMP DEFAULT NOW()
	,thread_id INTEGER
	,post_id INTEGER NOT NULL
	,username VARCHAR(25) NOT NULL
	,FOREIGN KEY ("thread_id") REFERENCES "comments" ("id") ON DELETE
	CASCADE
	,FOREIGN KEY ("post_id") REFERENCES "posts" ("id") ON DELETE CASCADE
	,FOREIGN KEY ("username") REFERENCES "users" ("username") ON DELETE
	SET NULL
	,CHECK (LENGTH(TRIM("text_content")) > 0)
	);

CREATE INDEX "comments_by_user_index" ON "comments" ("username");

CREATE INDEX "comments_by_post_index" ON "comments" ("post_id");

CREATE INDEX "comments_by_thread_index" ON "comments" ("thread_id");

-- 5. Create votes table
CREATE TABLE "votes" (
	username VARCHAR(25) NOT NULL
	,post_id INTEGER NOT NULL
	,vote SMALLINT CHECK (
		vote IN (
			1::SMALLINT
			,- 1::SMALLINT
			)
		)
	,created_at TIMESTAMP DEFAULT NOW()
	,PRIMARY KEY (
		username
		,post_id
		)
	,FOREIGN KEY ("username") REFERENCES "users" ("username") ON DELETE
	SET NULL
	,FOREIGN KEY ("post_id") REFERENCES "posts" ("id") ON DELETE CASCADE
	);

CREATE INDEX "votes_by_user_index" ON "votes" ("username");

CREATE INDEX "votes_by_post_index" ON "votes" ("post_id");
