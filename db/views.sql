
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

CREATE VIEW "SelectorsView" AS
SELECT
	Selectors.id as id,
	Selectors.name as name,
	Selectors.version as version,
	Categories.name as category
FROM Selectors, Categories
WHERE
	Selectors.category_id = Categories.id;
