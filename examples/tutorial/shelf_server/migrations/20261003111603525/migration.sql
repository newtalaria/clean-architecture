BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stored_book" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "title" text NOT NULL,
    "authorName" text NOT NULL,
    "status" text NOT NULL,
    "shelfId" uuid,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "stored_book_shelf_id_idx" ON "stored_book" USING btree ("shelfId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stored_shelf" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL,
    "capacity" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR shelf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shelf', '20261003111603525', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261003111603525', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
