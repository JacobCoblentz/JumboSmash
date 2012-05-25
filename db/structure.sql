CREATE TABLE "checkins" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "description" text, "location" text, "latitude" float, "longitude" float, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "connection_queues" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "message_body" text, "message_type" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "encrypted_lists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "matched" text, "requests" text, "pending" text, "user_id" integer);
CREATE TABLE "friendships" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "friend_id" integer, "status" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "teasers" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "gender" varchar(255), "facebook_id" varchar(255), "picture_url" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "email" varchar(255) DEFAULT '' NOT NULL, "encrypted_password" varchar(255) DEFAULT '' NOT NULL, "reset_password_token" varchar(255), "reset_password_sent_at" datetime, "sign_in_count" integer DEFAULT 0, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar(255), "last_sign_in_ip" varchar(255), "authentication_token" varchar(255), "public_key" text, "private_key" text);
CREATE TABLE "whitelists" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar(255), "name" varchar(255), "gender" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE UNIQUE INDEX "index_users_on_authentication_token" ON "users" ("authentication_token");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120414013032');

INSERT INTO schema_migrations (version) VALUES ('20120414040356');

INSERT INTO schema_migrations (version) VALUES ('20120414040517');

INSERT INTO schema_migrations (version) VALUES ('20120414041219');

INSERT INTO schema_migrations (version) VALUES ('20120414082035');

INSERT INTO schema_migrations (version) VALUES ('20120414095643');

INSERT INTO schema_migrations (version) VALUES ('20120418031240');

INSERT INTO schema_migrations (version) VALUES ('20120418223400');

INSERT INTO schema_migrations (version) VALUES ('20120418223514');

INSERT INTO schema_migrations (version) VALUES ('20120422161123');

INSERT INTO schema_migrations (version) VALUES ('20120427080107');