require "yaml"
require "mysql"

db_config = YAML.parse(File.read("config/database.yml"))["development"]

connection = MySQL.connect(
  db_config["host"].as_s,
  db_config["username"].as_s,
  db_config["password"].as_s,
  db_config["database"].as_s,
  db_config["port"].as_s.to_i || 3306,
  nil
)

# Recreate users table
connection.query(%{
  DROP TABLE IF EXISTS articles,comments,favorites,follows,taggings,tags,users
})

connection.query(%{
  CREATE TABLE articles (
    id              INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    title           VARCHAR(255),
    slug            VARCHAR(255),
    body            TEXT,
    description     VARCHAR(255),
    favorites_count INT,
    user_id         INT,
    created_at      DATETIME     NOT NULL,
    updated_at      DATETIME     NOT NULL
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE comments (
    id         INT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    body       TEXT,
    user_id    INT,
    article_id INT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE favorites (
    id         INT      NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id    INT,
    article_id INT,
    created_at DATETIME NOT NULL,
    updated_at DATETIME NOT NULL
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE follows (
    id              INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    followable_id   INT          NOT NULL,
    followable_type VARCHAR(255) NOT NULL,
    follower_id     INT          NOT NULL,
    follower_type   VARCHAR(255) NOT NULL,
    blocked         TINYINT(1)   NOT NULL DEFAULT 0,
    created_at      DATETIME,
    updated_at      DATETIME
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE taggings (
    id            INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    tag_id        INT,
    taggable_id   INT,
    taggable_type VARCHAR(255),
    tagger_id     INT,
    tagger_type   VARCHAR(255),
    context       VARCHAR(128),
    created_at    DATETIME
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE tags (
    id             INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(255),
    taggings_count INT          DEFAULT 0
  ) ENGINE=InnoDB
})
connection.query(%{
  CREATE TABLE users (
    id                 INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email              VARCHAR(255) NOT NULL DEFAULT "",
    encrypted_password VARCHAR(255) NOT NULL DEFAULT "",
    password_salt      VARCHAR(255) NOT NULL DEFAULT "",
    username           VARCHAR(255),
    bio                TEXT,
    image              VARCHAR(255),
    created_at         DATETIME     NOT NULL,
    updated_at         DATETIME     NOT NULL
  ) ENGINE=InnoDB
})
