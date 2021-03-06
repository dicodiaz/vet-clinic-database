/* Populate database with sample data. */
INSERT INTO
  animals (
    name,
    date_of_birth,
    weight_kg,
    neutered,
    escape_attempts
  )
VALUES
  (
    'Agumon',
    TO_DATE('2020-02-03', 'YYYY-MM-DD'),
    10.23,
    TRUE,
    0
  ),
  (
    'Gabumon',
    TO_DATE('2018-11-15', 'YYYY-MM-DD'),
    8,
    TRUE,
    2
  ),
  (
    'Pikachu',
    TO_DATE('2021-01-07', 'YYYY-MM-DD'),
    15.04,
    FALSE,
    1
  ),
  (
    'Devimon',
    TO_DATE('2017-05-12', 'YYYY-MM-DD'),
    11,
    TRUE,
    5
  );

-- Insert more data.
INSERT INTO
  animals (
    name,
    date_of_birth,
    weight_kg,
    neutered,
    escape_attempts
  )
VALUES
  (
    'Charmander',
    TO_DATE('2020-02-08', 'YYYY-MM-DD'),
    -11,
    FALSE,
    0
  ),
  (
    'Plantmon',
    TO_DATE('2022-11-15', 'YYYY-MM-DD'),
    -5.7,
    TRUE,
    2
  ),
  (
    'Squirtle',
    TO_DATE('1993-04-02', 'YYYY-MM-DD'),
    -12.13,
    FALSE,
    3
  ),
  (
    'Angemon',
    TO_DATE('2005-06-12', 'YYYY-MM-DD'),
    -45,
    TRUE,
    1
  ),
  (
    'Boarmon',
    TO_DATE('2005-06-07', 'YYYY-MM-DD'),
    20.4,
    TRUE,
    7
  ),
  (
    'Blossom',
    TO_DATE('1998-10-13', 'YYYY-MM-DD'),
    17,
    TRUE,
    3
  );

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that species columns went back to the state before tranasction.
BEGIN;

UPDATE
  animals
SET
  species = 'unspecified';

SELECT
  *
FROM
  animals;

ROLLBACK;

SELECT
  *
FROM
  animals;

/* Inside a transaction:
 Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
 Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
 Commit the transaction.
 Verify that change was made and persists after commit. */
BEGIN;

UPDATE
  animals
SET
  species = 'digimon'
WHERE
  name LIKE '%mon';

UPDATE
  animals
SET
  species = 'pokemon'
WHERE
  species IS NULL;

COMMIT;

SELECT
  *
FROM
  animals;

ROLLBACK;

SELECT
  *
FROM
  animals;

/* Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
 After the roll back verify if all records in the animals table still exist. After that you can start breath as usual ;). */
BEGIN;

TRUNCATE animals;

SELECT
  *
FROM
  animals;

ROLLBACK;

SELECT
  *
FROM
  animals;

/* Inside a transaction:
 Delete all animals born after Jan 1st, 2022.
 Create a savepoint for the transaction.
 Update all animals' weight to be their weight multiplied by -1.
 Rollback to the savepoint
 Update all animals' weights that are negative to be their weight multiplied by -1.
 Commit transaction. */
BEGIN;

DELETE FROM
  animals
WHERE
  date_of_birth >= TO_DATE('2022-01-01', 'YYYY-MM-DD');

SAVEPOINT my_savepoint;

UPDATE
  animals
SET
  weight_kg = weight_kg * -1;

ROLLBACK TO SAVEPOINT my_savepoint;

UPDATE
  animals
SET
  weight_kg = weight_kg * -1
WHERE
  weight_kg < 0;

COMMIT;

-- Insert data to new tables.
INSERT INTO
  owners(full_name, age)
VALUES
  ('Sam Smith', 34),
  ('Jennifer Orwell', 19),
  ('Bob', 45),
  ('Melody Pond', 77),
  ('Dean Winchester', 14),
  ('Jodie Whittaker', 38);

INSERT INTO
  species(name)
VALUES
  ('Pokemon'),
  ('Digimon');

-- Modify your inserted animals so it includes the species_id value.
BEGIN;

UPDATE
  animals
SET
  species_id = (
    SELECT
      id
    FROM
      species
    WHERE
      name = 'Digimon'
  )
WHERE
  name LIKE '%mon';

UPDATE
  animals
SET
  species_id = (
    SELECT
      id
    FROM
      species
    WHERE
      name = 'Pokemon'
  )
WHERE
  species_id IS NULL;

COMMIT;

-- Modify your inserted animals to include owner information (owner_id).
BEGIN;

UPDATE
  animals
SET
  owner_id = (
    SELECT
      id
    FROM
      owners
    WHERE
      full_name = 'Sam Smith'
  )
WHERE
  name = 'Agumon';

UPDATE
  animals
SET
  owner_id = (
    SELECT
      id
    FROM
      owners
    WHERE
      full_name = 'Jennifer Orwell'
  )
WHERE
  name IN ('Gabumon', 'Pikachu');

UPDATE
  animals
SET
  owner_id = (
    SELECT
      id
    FROM
      owners
    WHERE
      full_name = 'Bob'
  )
WHERE
  name IN ('Devimon', 'Plantmon');

UPDATE
  animals
SET
  owner_id = (
    SELECT
      id
    FROM
      owners
    WHERE
      full_name = 'Melody Pond'
  )
WHERE
  name IN ('Charmander', 'Squirtle', 'Blossom');

UPDATE
  animals
SET
  owner_id = (
    SELECT
      id
    FROM
      owners
    WHERE
      full_name = 'Dean Winchester'
  )
WHERE
  name IN ('Angemon', 'Boarmon');

COMMIT;

-- Insert data into vets.
INSERT INTO
  vets(name, age, date_of_graduation)
VALUES
  (
    'William Tatcher',
    45,
    TO_DATE('2000-04-23', 'YYYY-MM-DD')
  ),
  (
    'Maisy Smith',
    26,
    TO_DATE('2019-01-17', 'YYYY-MM-DD')
  ),
  (
    'Stephanie Mendez',
    64,
    TO_DATE('1981-05-04', 'YYYY-MM-DD')
  ),
  (
    'Jack Harkness',
    38,
    TO_DATE('2008-06-08', 'YYYY-MM-DD')
  );

-- Insert data into specializations.
INSERT INTO
  specializations(vet_id, species_id)
VALUES
  (
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'William Tatcher'
    ),
    (
      SELECT
        id
      FROM
        species
      WHERE
        name = 'Pokemon'
    )
  ),
  (
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    (
      SELECT
        id
      FROM
        species
      WHERE
        name = 'Digimon'
    )
  ),
  (
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    (
      SELECT
        id
      FROM
        species
      WHERE
        name = 'Pokemon'
    )
  ),
  (
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Jack Harkness'
    ),
    (
      SELECT
        id
      FROM
        species
      WHERE
        name = 'Digimon'
    )
  );

-- Insert data into visits.
INSERT INTO
  visits(animal_id, vet_id, date_of_visit)
VALUES
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Agumon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'William Tatcher'
    ),
    TO_DATE('May 24 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Agumon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    TO_DATE('Jul 22 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Gabumon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Jack Harkness'
    ),
    TO_DATE('Feb 2 2021', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Pikachu'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('Jan 5 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Pikachu'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('Mar 8 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Pikachu'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('May 14 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Devimon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    TO_DATE('May 4 2021', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Charmander'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Jack Harkness'
    ),
    TO_DATE('Feb 24 2021', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Squirtle'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    TO_DATE('Sep 29 2019', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Angemon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Jack Harkness'
    ),
    TO_DATE('Oct 3 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Angemon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Jack Harkness'
    ),
    TO_DATE('Nov 4 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Boarmon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('Jan 24 2019', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Boarmon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('May 15 2019', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Boarmon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('Feb 27 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Boarmon'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Maisy Smith'
    ),
    TO_DATE('Aug 3 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Blossom'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'Stephanie Mendez'
    ),
    TO_DATE('May 24 2020', 'Mon DD YYYY')
  ),
  (
    (
      SELECT
        id
      FROM
        animals
      WHERE
        name = 'Blossom'
    ),
    (
      SELECT
        id
      FROM
        vets
      WHERE
        name = 'William Tatcher'
    ),
    TO_DATE('Jan 11 2021', 'Mon DD YYYY')
  );

-- Run after inserting or deleting from visits table. This is needed because of denormalization.
UPDATE
  animals
SET
  count_of_visits = (
    SELECT
      COUNT(visits.animal_id)
    FROM
      visits
    WHERE
      visits.animal_id = animals.id
  );