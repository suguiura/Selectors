-- Creator:       MySQL Workbench 5.2.28/ExportSQLite plugin 2009.12.02
-- Author:        Rafael S. Suguiura
-- Caption:       LDTM DB Model
-- Project:       Linux Distributions Treasure Map
-- Changed:       2010-10-26 19:12
-- Created:       2010-07-28 13:51
PRAGMA foreign_keys = OFF;

-- Schema: Linux Distribution Treasure Map
BEGIN;
CREATE TABLE "Distributions"(
--   Table of Linux Distributions
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,-- Distribution name.
  "url" VARCHAR(255),-- Official URL
  CONSTRAINT "uq_distributions"
    UNIQUE("name")
);
CREATE TABLE "FileServers"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "url" VARCHAR(255) NOT NULL,
  "repository" VARCHAR(255),
  CONSTRAINT "uq_fileservers"
    UNIQUE("url")
);
CREATE TABLE "Architectures"(
--   List of processor architectures.
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,-- Name of the architecture.
  CONSTRAINT "uq_architectures"
    UNIQUE("name")
);
CREATE TABLE "Maintainers"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255),
  CONSTRAINT "uq_maintainers"
    UNIQUE("email","name")
);
CREATE TABLE "Projects"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  CONSTRAINT "uq_projects"
    UNIQUE("name")
);
CREATE TABLE "Mimetypes"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  CONSTRAINT "uq_mimetypes"
    UNIQUE("name")
);
CREATE TABLE "Releases"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "distribution_id" INTEGER NOT NULL,
  "architecture_id" INTEGER NOT NULL,
  "version" VARCHAR(255) NOT NULL,
  "date" DATE NOT NULL,
  "codename" VARCHAR(255),
  "status" VARCHAR(255),
  "description" VARCHAR(255),
  CONSTRAINT "uq_versions"
    UNIQUE("distribution_id","architecture_id","version","date","status"),
  CONSTRAINT "fk_distributions"
    FOREIGN KEY("distribution_id")
    REFERENCES "Distributions"("id"),
  CONSTRAINT "fk_architectures"
    FOREIGN KEY("architecture_id")
    REFERENCES "Architectures"("id")
);
CREATE INDEX "Releases.fk_distributions" ON "Releases"("distribution_id");
CREATE INDEX "Releases.fk_architectures" ON "Releases"("architecture_id");
CREATE TABLE "EquivalenceClasses"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  CONSTRAINT "uq_equivalenceclasses"
    UNIQUE("name")
);
CREATE TABLE "Files"(
--   Files table, which represents a file, either a project package, a media, a patch, etc.
  "id" INTEGER PRIMARY KEY NOT NULL,
  "mimetype_id" INTEGER NOT NULL,
  "filename" VARCHAR(255) NOT NULL,
  "size" INTEGER,
  "md5sum" VARCHAR(255),
  "sha1" VARCHAR(255),
  "sha256" VARCHAR(255),
  CONSTRAINT "uq_files"
    UNIQUE("filename"),
  CONSTRAINT "fk_mimetypes"
    FOREIGN KEY("mimetype_id")
    REFERENCES "Mimetypes"("id")
);
CREATE INDEX "Files.fk_mimetypes" ON "Files"("mimetype_id");
CREATE TABLE "Categories"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "equivalenceclass_id" INTEGER,
  "name" VARCHAR(255) NOT NULL,
  CONSTRAINT "uq_categories"
    UNIQUE("name"),
  CONSTRAINT "fk_equivalenceclasses"
    FOREIGN KEY("equivalenceclass_id")
    REFERENCES "EquivalenceClasses"("id")
);
CREATE INDEX "Categories.fk_equivalenceclasses" ON "Categories"("equivalenceclass_id");
CREATE TABLE "FileServers_have_Files"(
  "fileserver_id" INTEGER NOT NULL,
  "file_id" INTEGER NOT NULL,
  PRIMARY KEY("fileserver_id","file_id"),
  CONSTRAINT "fk_fileservers"
    FOREIGN KEY("fileserver_id")
    REFERENCES "FileServers"("id"),
  CONSTRAINT "fk_files"
    FOREIGN KEY("file_id")
    REFERENCES "Files"("id")
);
CREATE INDEX "FileServers_have_Files.fk_files" ON "FileServers_have_Files"("file_id");
CREATE TABLE "Selectors"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "category_id" INTEGER NOT NULL,
  "maintainer_id" INTEGER NOT NULL,
  "name" VARCHAR(255) NOT NULL,
  "version" VARCHAR(255) NOT NULL,
  "origin" VARCHAR(255),
  "homepage" VARCHAR(255),
  "description" TEXT,
  CONSTRAINT "uq_selectors"
    UNIQUE("name","version","maintainer_id"),
  CONSTRAINT "fk_categories"
    FOREIGN KEY("category_id")
    REFERENCES "Categories"("id"),
  CONSTRAINT "fk_maintainers"
    FOREIGN KEY("maintainer_id")
    REFERENCES "Maintainers"("id")
);
CREATE INDEX "Selectors.fk_categories" ON "Selectors"("category_id");
CREATE INDEX "Selectors.fk_maintainers" ON "Selectors"("maintainer_id");
CREATE TABLE "Selectors_require_Files"(
  "selector_id" INTEGER NOT NULL,
  "file_id" INTEGER NOT NULL,
  PRIMARY KEY("selector_id","file_id"),
  CONSTRAINT "fk_selectors"
    FOREIGN KEY("selector_id")
    REFERENCES "Selectors"("id"),
  CONSTRAINT "fk_files"
    FOREIGN KEY("file_id")
    REFERENCES "Files"("id")
);
CREATE INDEX "Selectors_require_Files.fk_files" ON "Selectors_require_Files"("file_id");
CREATE TABLE "Releases_have_Selectors"(
  "release_id" INTEGER NOT NULL,
  "selector_id" INTEGER NOT NULL,
  PRIMARY KEY("release_id","selector_id"),
  CONSTRAINT "fk_releases"
    FOREIGN KEY("release_id")
    REFERENCES "Releases"("id"),
  CONSTRAINT "fk_selectors"
    FOREIGN KEY("selector_id")
    REFERENCES "Selectors"("id")
);
CREATE INDEX "Releases_have_Selectors.fk_selectors" ON "Releases_have_Selectors"("selector_id");
CREATE TABLE "Projects_have_Categories"(
  "project_id" INTEGER NOT NULL,
  "category_id" INTEGER NOT NULL,
  PRIMARY KEY("project_id","category_id"),
  CONSTRAINT "fk_projects"
    FOREIGN KEY("project_id")
    REFERENCES "Projects"("id"),
  CONSTRAINT "fk_categories"
    FOREIGN KEY("category_id")
    REFERENCES "Categories"("id")
);
CREATE INDEX "Projects_have_Categories.fk_categories" ON "Projects_have_Categories"("category_id");
CREATE TABLE "Medias"(
  "id" INTEGER PRIMARY KEY NOT NULL,
  "release_id" INTEGER NOT NULL,
  "file_id" INTEGER NOT NULL,
  "type" VARCHAR(255),
  "number" INTEGER,
  "total" INTEGER,
  CONSTRAINT "uq_medias"
    UNIQUE("release_id","type","number","total"),
  CONSTRAINT "fk_files"
    FOREIGN KEY("file_id")
    REFERENCES "Files"("id"),
  CONSTRAINT "fk_releases1"
    FOREIGN KEY("release_id")
    REFERENCES "Releases"("id")
);
CREATE INDEX "Medias.fk_files" ON "Medias"("file_id");
CREATE INDEX "Medias.fk_releases" ON "Medias"("release_id");
CREATE TABLE "FileStatistics"(
  "id" VARCHAR(255) PRIMARY KEY NOT NULL,
  "fileserver_id" INTEGER NOT NULL,
  "file_id" INTEGER NOT NULL,
  "interval_begin" DATE NOT NULL,
  "interval_days" INTEGER NOT NULL,
  "hits" INTEGER,
  "total_transfer" INTEGER,
  CONSTRAINT "uq_filestatistics"
    UNIQUE("interval_begin","interval_days","fileserver_id","file_id"),
  CONSTRAINT "fk_fileservers_have_files"
    FOREIGN KEY("fileserver_id","file_id")
    REFERENCES "FileServers_have_Files"("fileserver_id","file_id")
);
CREATE INDEX "FileStatistics.fk_fileservers_have_files" ON "FileStatistics"("fileserver_id","file_id");
CREATE TABLE "SelectorStatistics"(
  "id" VARCHAR(255) PRIMARY KEY NOT NULL,
  "selector_id" INTEGER NOT NULL,
  "date" DATE,
  "installations" INTEGER,
  CONSTRAINT "uq_packagestatistics"
    UNIQUE("selector_id","date"),
  CONSTRAINT "fk_selectors"
    FOREIGN KEY("selector_id")
    REFERENCES "Selectors"("id")
);
CREATE INDEX "SelectorStatistics.fk_selectors" ON "SelectorStatistics"("selector_id");
COMMIT;
