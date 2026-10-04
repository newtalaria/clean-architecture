BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "stored_book" ADD COLUMN "favorite" boolean NOT NULL DEFAULT false;

--
-- MIGRATION VERSION FOR shelf
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('shelf', '20261004011101484', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261004011101484', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();


COMMIT;
