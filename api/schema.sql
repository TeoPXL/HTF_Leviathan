-- PostgreSQL Schema with optimizations

BEGIN;

-- Enable UUID extension for better IDs
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set timezone
SET timezone = 'UTC';

-- Create enum types for better type safety
CREATE TYPE agerating_type AS ENUM ('r18', 'r15', 'all_ages');
CREATE TYPE language_type AS ENUM ('JP', 'EN', 'CN', 'KR', 'ES');
CREATE TYPE status_type AS ENUM ('pending', 'queued', 'completed');
CREATE TYPE tag_type AS ENUM ('general', 'character', 'series', 'theme');
CREATE TYPE theme_type AS ENUM ('dark', 'light');
CREATE TYPE log_type AS ENUM (
    'login_success', 'login_failure', 'login_error',
    'auth_success', 'auth_failure', 'auth_error',
    'registration_success', 'registration_failure', 'registration_error');

-- Create tables with proper constraints and indexes
CREATE TABLE circles (
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL UNIQUE,
                         romaji VARCHAR(255) NOT NULL,
                         followers INTEGER NOT NULL DEFAULT 0,
                         videos INTEGER NOT NULL DEFAULT 0,
                         created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE logs (
                         id SERIAL PRIMARY KEY,
                         type log_type NOT NULL,
                         ip_address VARCHAR(255) NOT NULL,
                         created TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TYPE subscription_type AS ENUM ('none', 'premium', 'premium_plus');
CREATE TYPE role_type as ENUM ('user', 'moderator', 'administrator');
CREATE TYPE user_status_type as ENUM ('active', 'shadow_banned', 'banned');
CREATE TYPE content_settings_type as ENUM ('explicit', 'explicit_blur', 'safe');

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role role_type NOT NULL DEFAULT 'user',
    subscription subscription NOT NULL DEFAULT 'none',
    free_week BOOLEAN NOT NULL DEFAULT FALSE,


    preferences_content content_settings_type NOT NULL DEFAULT 'safe',
    explicit BOOLEAN NOT NULL DEFAULT TRUE,
    explicit_blur BOOLEAN NOT NULL DEFAULT FALSE,
    loop_videos BOOLEAN NOT NULL DEFAULT FALSE,
    sleep_mode BOOLEAN NOT NULL DEFAULT FALSE,
    personalisation BOOLEAN NOT NULL DEFAULT TRUE,
    email_admin BOOLEAN NOT NULL DEFAULT TRUE,
    email_security BOOLEAN NOT NULL DEFAULT TRUE,
    email_marketing BOOLEAN NOT NULL DEFAULT TRUE,
    email_notifications BOOLEAN NOT NULL DEFAULT TRUE,
    email_other BOOLEAN NOT NULL DEFAULT TRUE,
    font_size VARCHAR(50) NOT NULL DEFAULT 'default',
    haptics BOOLEAN NOT NULL DEFAULT TRUE,
    special BOOLEAN NOT NULL DEFAULT FALSE,
    language VARCHAR(10) NOT NULL DEFAULT 'en',
    theme theme_type NOT NULL DEFAULT 'dark',
    holiday VARCHAR(50) DEFAULT NULL,
    code VARCHAR(255) NOT NULL,
    email_verified BOOLEAN NOT NULL DEFAULT TRUE,
    dev BOOLEAN DEFAULT FALSE,
    developer_mode BOOLEAN NOT NULL DEFAULT FALSE,
    login_date DATE NOT NULL DEFAULT CURRENT_DATE,
    token VARCHAR(255) DEFAULT NULL,
    token_date DATE NOT NULL DEFAULT CURRENT_DATE,
    user_status user_status_type NOT NULL DEFAULT 'active',
    patreon BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);

-- Create a full text search index for users
CREATE INDEX idx_users_search ON users USING gin(to_tsvector('english', username || ' ' || email));

CREATE TABLE queue (
                       id SERIAL PRIMARY KEY,
                       rj_code VARCHAR(255) NOT NULL,
                       title VARCHAR(255) NOT NULL,
                       titlejp VARCHAR(255) NOT NULL,
                       titlecn VARCHAR(255) NOT NULL,
                       url VARCHAR(255) NOT NULL,
                       audio VARCHAR(255) NOT NULL,
                       tagstring VARCHAR(255) NOT NULL,
                       track_titles TEXT NOT NULL DEFAULT '',
                       img VARCHAR(255) NOT NULL,
                       blur VARCHAR(255) NOT NULL,
                       views INTEGER NOT NULL DEFAULT 0,
                       likes INTEGER NOT NULL DEFAULT 0,
                       sub VARCHAR(255) NOT NULL,
                       channel VARCHAR(255) NOT NULL,
                       romaji VARCHAR(255) NOT NULL DEFAULT '',
                       poster VARCHAR(255) NOT NULL,
                       imgapp VARCHAR(255) NOT NULL,
                       posterapp VARCHAR(255) NOT NULL,
                       saves INTEGER NOT NULL DEFAULT 0,
                       approved INTEGER NOT NULL DEFAULT 0,
                       removed INTEGER NOT NULL DEFAULT 0,
                       duration VARCHAR(50) NOT NULL,
                       agerating agerating_type NOT NULL DEFAULT 'r18',
                       language language_type NOT NULL DEFAULT 'JP',
                       flares VARCHAR(50) NOT NULL DEFAULT 'f4m',
                       subtitled BOOLEAN NOT NULL DEFAULT FALSE,
                       autogen BOOLEAN NOT NULL DEFAULT FALSE,
                       autogen_jp VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_en VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_cn VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_kr VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_es VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE INDEX idx_queue_rj_code ON queue(rj_code);
CREATE INDEX idx_queue_channel ON queue(channel);
CREATE INDEX idx_queue_search ON queue USING gin(to_tsvector('english', title || ' ' || tagstring));

CREATE TABLE video (
                       id SERIAL PRIMARY KEY,
                       rj_code VARCHAR(255) NOT NULL,
                       title VARCHAR(255) NOT NULL,
                       titlejp VARCHAR(255) NOT NULL,
                       titlecn VARCHAR(255) NOT NULL,
                       url VARCHAR(255) NOT NULL,
                       audio VARCHAR(255) NOT NULL,
                       img VARCHAR(255) NOT NULL,
                       blur VARCHAR(255) NOT NULL,
                       views INTEGER NOT NULL DEFAULT 0,
                       likes INTEGER NOT NULL DEFAULT 0,
                       sub VARCHAR(255) NOT NULL,
                       channel VARCHAR(255) NOT NULL,
                       romaji VARCHAR(255) NOT NULL DEFAULT '',
                       tags VARCHAR(255) NOT NULL,
                       track_titles TEXT NOT NULL DEFAULT '',
                       poster VARCHAR(255) NOT NULL,
                       imgapp VARCHAR(255) NOT NULL,
                       posterapp VARCHAR(255) NOT NULL,
                       saves INTEGER NOT NULL DEFAULT 0,
                       queueid INTEGER REFERENCES queue(id),
                       duration VARCHAR(50) NOT NULL,
                       language language_type NOT NULL DEFAULT 'JP',
                       agerating agerating_type NOT NULL DEFAULT 'r18',
                       flares VARCHAR(50) NOT NULL DEFAULT 'f4m',
                       subtitled BOOLEAN NOT NULL DEFAULT FALSE,
                       autogen BOOLEAN NOT NULL DEFAULT FALSE,
                       autogen_jp VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_en VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_cn VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_kr VARCHAR(255) NOT NULL DEFAULT '',
                       autogen_es VARCHAR(255) NOT NULL DEFAULT ''
);

CREATE INDEX idx_video_rj_code ON video(rj_code);
CREATE INDEX idx_video_channel ON video(channel);
CREATE INDEX idx_video_search ON video USING gin(to_tsvector('english',
    title || ' ' || titlejp || ' ' || titlecn || ' ' || tags || ' ' ||
    channel || ' ' || romaji || ' ' || track_titles));

CREATE TABLE tagslist (
                          id SERIAL PRIMARY KEY,
                          tag VARCHAR(255) NOT NULL UNIQUE,
                          tagjp VARCHAR(255) NOT NULL,
                          tagsp VARCHAR(255) NOT NULL,
                          agerating INTEGER NOT NULL DEFAULT 1,
                          likes INTEGER DEFAULT 0,
                          type tag_type NOT NULL DEFAULT 'general'
);

CREATE TABLE tags (
                      id SERIAL PRIMARY KEY,
                      tag VARCHAR(255) NOT NULL,
                      tagjp VARCHAR(255) NOT NULL,
                      tagsp VARCHAR(255) NOT NULL,
                      videoid INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE
);

CREATE INDEX idx_tags_videoid ON tags(videoid);
CREATE INDEX idx_tags_tag ON tags(tag);

CREATE TABLE valist (
                        id SERIAL PRIMARY KEY,
                        va VARCHAR(255) NOT NULL UNIQUE,
                        vajp VARCHAR(255) NOT NULL
);

CREATE TABLE va (
                    id SERIAL PRIMARY KEY,
                    va VARCHAR(255) NOT NULL,
                    vajp VARCHAR(255) NOT NULL,
                    videoid INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE
);

CREATE INDEX idx_va_videoid ON va(videoid);
CREATE INDEX idx_va_va ON va(va);

CREATE TABLE tracks (
                        id SERIAL PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        namejp VARCHAR(255) NOT NULL,
                        namecn VARCHAR(255) NOT NULL,
                        videoid INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                        length TIME NOT NULL
);

CREATE INDEX idx_tracks_videoid ON tracks(videoid);

CREATE TABLE usercomments (
                              id SERIAL PRIMARY KEY,
                              post_id INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                              username VARCHAR(255) DEFAULT NULL,
                              comment VARCHAR(240) NOT NULL,
                              replykey INTEGER NOT NULL DEFAULT 0,
                              user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                              likes INTEGER NOT NULL DEFAULT 0,
                              created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_usercomments_post_id ON usercomments(post_id);
CREATE INDEX idx_usercomments_user_id ON usercomments(user_id);
CREATE INDEX idx_usercomments_replykey ON usercomments(replykey);

CREATE TABLE comment_likes (
                               id SERIAL PRIMARY KEY,
                               comment_id INTEGER NOT NULL REFERENCES usercomments(id) ON DELETE CASCADE,
                               user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                               UNIQUE(comment_id, user_id)
);

CREATE TABLE userlikes (
                           id SERIAL PRIMARY KEY,
                           post_id INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                           user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                           created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           UNIQUE(post_id, user_id)
);

CREATE TABLE usersaves (
                           id SERIAL PRIMARY KEY,
                           post_id INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                           user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                           created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                           UNIQUE(post_id, user_id)
);

CREATE TABLE userfollows (
                             id SERIAL PRIMARY KEY,
                             circle_id INTEGER REFERENCES circles(id) ON DELETE CASCADE,
                             user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                             created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             UNIQUE(user_id, circle_id)
);

CREATE TABLE userplaylists (
                               id SERIAL PRIMARY KEY,
                               post_id INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                               playlist VARCHAR(255) NOT NULL,
                               user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                               created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               UNIQUE(post_id, user_id, playlist)
);

CREATE INDEX idx_userplaylists_user_id ON userplaylists(user_id);
CREATE INDEX idx_userplaylists_playlist ON userplaylists(playlist);

CREATE TABLE playlists_favorite (
                                    id SERIAL PRIMARY KEY,
                                    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                    username VARCHAR(255) NOT NULL,
                                    playlist VARCHAR(255) NOT NULL,
                                    UNIQUE(user_id, playlist)
);

CREATE TABLE requests (
                          id SERIAL PRIMARY KEY,
                          user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                          rj_code VARCHAR(255) NOT NULL,
                          circle VARCHAR(255) NOT NULL,
                          agerating agerating_type NOT NULL DEFAULT 'r18',
                          language language_type NOT NULL DEFAULT 'JP',
                          title VARCHAR(255) NOT NULL,
                          title_jp VARCHAR(255) NOT NULL,
                          tags VARCHAR(255) NOT NULL,
                          status status_type NOT NULL DEFAULT 'pending',
                          img VARCHAR(255) NOT NULL,
                          boosted BOOLEAN NOT NULL DEFAULT FALSE,
                          votes INTEGER NOT NULL DEFAULT 0,
                          post_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE INDEX idx_requests_rj_code ON requests(rj_code);
CREATE INDEX idx_requests_user_id ON requests(user_id);
CREATE INDEX idx_requests_status ON requests(status);

CREATE TABLE request_votes (
                               id SERIAL PRIMARY KEY,
                               user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                               request_id INTEGER NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
                               created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                               UNIQUE(user_id, request_id)
);

CREATE TABLE request_boosts (
                                id SERIAL PRIMARY KEY,
                                user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                request_id INTEGER NOT NULL REFERENCES requests(id) ON DELETE CASCADE,
                                boost_date DATE NOT NULL DEFAULT CURRENT_DATE,
                                UNIQUE(user_id, request_id)
);

CREATE TABLE translate_requests (
                                    id SERIAL PRIMARY KEY,
                                    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                    post_id INTEGER NOT NULL REFERENCES video(id) ON DELETE CASCADE,
                                    timestamp DATE NOT NULL DEFAULT CURRENT_DATE,
                                    UNIQUE(user_id, post_id)
);

CREATE TABLE images (
                        id SERIAL PRIMARY KEY,
                        url VARCHAR(255) NOT NULL,
                        foreignkey INTEGER NOT NULL,
                        type INTEGER NOT NULL
);

CREATE INDEX idx_images_foreignkey ON images(foreignkey, type);

CREATE TABLE likely_available (
                                  id SERIAL PRIMARY KEY,
                                  link VARCHAR(255) NOT NULL,
                                  code VARCHAR(255) NOT NULL UNIQUE,
                                  chance INTEGER NOT NULL,
                                  mega VARCHAR(255) NOT NULL,
                                  mf VARCHAR(255) NOT NULL,
                                  yuu VARCHAR(255) NOT NULL,
                                  sharer VARCHAR(255) NOT NULL
);

CREATE TABLE discord (
                         invite VARCHAR(255) NOT NULL
);

CREATE TABLE message (
                         id SERIAL PRIMARY KEY,
                         reason VARCHAR(255) NOT NULL,
                         email VARCHAR(255) NOT NULL,
                         message TEXT NOT NULL,
                         timestamp DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE password_reset (
                                id SERIAL PRIMARY KEY,
                                email VARCHAR(255) NOT NULL,
                                timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                code VARCHAR(255) NOT NULL
);

CREATE INDEX idx_password_reset_email ON password_reset(email);

CREATE TABLE patreon (
                         id SERIAL PRIMARY KEY,
                         userid INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                         token VARCHAR(255) NOT NULL,
                         refresh VARCHAR(255) NOT NULL,
                         data TEXT NOT NULL,
                         membership VARCHAR(50) NOT NULL DEFAULT 'none'
);

CREATE INDEX idx_patreon_userid ON patreon(userid);

-- Create functions for triggers
CREATE OR REPLACE FUNCTION update_comment_likes_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE usercomments SET likes = likes + 1 WHERE id = NEW.comment_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_comment_likes_after_delete()
RETURNS TRIGGER AS $$
BEGIN
UPDATE usercomments SET likes = likes - 1 WHERE id = OLD.comment_id;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_followers_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE circles SET followers = followers + 1 WHERE id = NEW.circle_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_followers_after_delete()
RETURNS TRIGGER AS $$
BEGIN
UPDATE circles SET followers = followers - 1 WHERE id = OLD.circle_id;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_likes_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE video SET likes = likes + 1 WHERE id = NEW.post_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_likes_after_delete()
RETURNS TRIGGER AS $$
BEGIN
UPDATE video SET likes = likes - 1 WHERE id = OLD.post_id;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_request_votes_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE requests SET votes = votes + 1 WHERE id = NEW.request_id;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_request_votes_after_delete()
RETURNS TRIGGER AS $$
BEGIN
UPDATE requests SET votes = votes - 1 WHERE id = OLD.request_id;
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insert_circle_after_insert()
RETURNS TRIGGER AS $$
BEGIN
INSERT INTO circles (name, followers)
VALUES (NEW.channel, 0)
    ON CONFLICT (name) DO NOTHING;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_requests_after_update()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.title IS NOT NULL AND NEW.title <> '' AND NEW.approved <> 1 AND NEW.removed <> 1 THEN
UPDATE requests SET status = 'queued' WHERE LOWER(rj_code) = LOWER(NEW.rj_code);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_requests_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE requests SET status = 'completed' WHERE LOWER(rj_code) = LOWER(NEW.rj_code);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_tagslist_after_insert()
RETURNS TRIGGER AS $$
BEGIN
UPDATE tagslist SET likes = likes + 1 WHERE NEW.tags LIKE '%' || tag || '%';
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_tagslist_after_delete()
RETURNS TRIGGER AS $$
BEGIN
UPDATE tagslist SET likes = likes - 1 WHERE OLD.tags LIKE '%' || tag || '%';
RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Add triggers
CREATE TRIGGER update_comment_likes_after_insert
    AFTER INSERT ON comment_likes
    FOR EACH ROW
    EXECUTE FUNCTION update_comment_likes_after_insert();

CREATE TRIGGER update_comment_likes_after_delete
    AFTER DELETE ON comment_likes
    FOR EACH ROW
    EXECUTE FUNCTION update_comment_likes_after_delete();

CREATE TRIGGER update_followers_after_insert
    AFTER INSERT ON userfollows
    FOR EACH ROW
    EXECUTE FUNCTION update_followers_after_insert();

CREATE TRIGGER update_followers_after_delete
    AFTER DELETE ON userfollows
    FOR EACH ROW
    EXECUTE FUNCTION update_followers_after_delete();

CREATE TRIGGER update_likes_after_insert
    AFTER INSERT ON userlikes
    FOR EACH ROW
    EXECUTE FUNCTION update_likes_after_insert();

CREATE TRIGGER update_likes_after_delete
    AFTER DELETE ON userlikes
    FOR EACH ROW
    EXECUTE FUNCTION update_likes_after_delete();

CREATE TRIGGER update_request_votes_after_insert
    AFTER INSERT ON request_votes
    FOR EACH ROW
    EXECUTE FUNCTION update_request_votes_after_insert();

CREATE TRIGGER update_request_votes_after_delete
    AFTER DELETE ON request_votes
    FOR EACH ROW
    EXECUTE FUNCTION update_request_votes_after_delete();

CREATE TRIGGER insert_circle_after_insert
    AFTER INSERT ON queue
    FOR EACH ROW
    EXECUTE FUNCTION insert_circle_after_insert();

CREATE TRIGGER update_requests_after_update
    AFTER UPDATE ON queue
    FOR EACH ROW
    EXECUTE FUNCTION update_requests_after_update();

CREATE TRIGGER update_requests_after_insert
    AFTER INSERT ON video
    FOR EACH ROW
    EXECUTE FUNCTION update_requests_after_insert();

CREATE TRIGGER update_tagslist_after_insert
    AFTER INSERT ON video
    FOR EACH ROW
    EXECUTE FUNCTION update_tagslist_after_insert();

CREATE TRIGGER update_tagslist_after_delete
    AFTER DELETE ON video
    FOR EACH ROW
    EXECUTE FUNCTION update_tagslist_after_delete();

COMMIT;