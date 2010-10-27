CREATE VIEW "ReleasesView" AS
SELECT
  Releases.id as id,
  Releases.version as version,
  Architectures.name as architecture,
  Distributions.name as distribution
FROM
  Releases,
  Architectures,
  Distributions
WHERE
  Releases.architecture_id = Architectures.id and
  Releases.distribution_id = Distributions.id;

CREATE VIEW "SelectorsCategoryView" AS
SELECT
  Selectors.id as id,
  Selectors.name as name,
  Selectors.version as version,
  Categories.name as category
FROM Selectors, Categories
WHERE
  Selectors.category_id = Categories.id;

CREATE VIEW "ProjectSelectorsView" AS
SELECT
  Projects.name as name,
  Projects.id as project_id,
  Selectors.id as selector_id
FROM
  Selectors
JOIN
  Projects
USING
  (name);

CREATE VIEW "ProjectStatisticsView" AS
SELECT
  ProjectSelectorsView.project_id as id,
  ProjectSelectorsView.name as name,
  SelectorStatistics.installations as installations
FROM
  ProjectSelectorsView
JOIN
  SelectorStatistics
USING
  (selector_id);
