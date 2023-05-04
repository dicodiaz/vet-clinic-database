-- Populate database with sample data.
INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
  )
VALUES -- Animal: His name is Agumon. He was born on Feb 3rd, 2020, and currently weighs 10.23kg. He was neutered and he has never tried to escape.
  (
    'Agumon',
    make_date(2020, 02, 03),
    0,
    TRUE,
    10.23
  ),
  -- Animal: Her name is Gabumon. She was born on Nov 15th, 2018, and currently weighs 8kg. She is neutered and she has tried to escape 2 times.
  (
    'Gabumon',
    make_date(2018, 11, 15),
    2,
    TRUE,
    8
  ),
  -- Animal: His name is Pikachu. He was born on Jan 7th, 2021, and currently weighs 15.04kg. He was not neutered and he has tried to escape once.
  (
    'Pikachu',
    make_date(2021, 01, 07),
    1,
    FALSE,
    15.04
  ),
  -- Animal: Her name is Devimon. She was born on May 12th, 2017, and currently weighs 11kg. She is neutered and she has tried to escape 5 times.
  (
    'Devimon',
    make_date(2017, 05, 12),
    5,
    TRUE,
    11
  );

INSERT INTO animals (
    name,
    date_of_birth,
    escape_attempts,
    neutered,
    weight_kg
  )
VALUES -- Animal: His name is Charmander. He was born on Feb 8th, 2020, and currently weighs -11kg. He is not neutered and he has never tried to escape.
  (
    'Charmander',
    make_date(2020, 02, 08),
    0,
    FALSE,
    -11
  ),
  -- Animal: Her name is Plantmon. She was born on Nov 15th, 2021, and currently weighs -5.7kg. She is neutered and she has tried to escape 2 times.
  (
    'Plantmon',
    make_date(2021, 11, 15),
    2,
    TRUE,
    -5.7
  ),
  -- Animal: His name is Squirtle. He was born on Apr 2nd, 1993, and currently weighs -12.13kg. He was not neutered and he has tried to escape 3 times.
  (
    'Squirtle',
    make_date(1993, 04, 02),
    3,
    FALSE,
    -12.13
  ),
  -- Animal: His name is Angemon. He was born on Jun 12th, 2005, and currently weighs -45kg. He is neutered and he has tried to escape once.
  (
    'Angemon',
    make_date(2005, 06, 12),
    1,
    TRUE,
    -45
  ),
  -- Animal: His name is Boarmon. He was born on Jun 7th, 2005, and currently weighs 20.4kg. He is neutered and he has tried to escape 7 times.
  (
    'Boarmon',
    make_date(2005, 06, 07),
    7,
    TRUE,
    20.4
  ),
  -- Animal: Her name is Blossom. She was born on Oct 13th, 1998, and currently weighs 17kg. She is neutered and she has tried to escape 3 times.
  (
    'Blossom',
    make_date(1998, 10, 13),
    3,
    TRUE,
    17
  ),
  -- Animal: His name is Ditto. He was born on May 14th, 2022, and currently weighs 22kg. He is neutered and he has tried to escape 4 times.
  (
    'Ditto',
    make_date(2022, 05, 14),
    4,
    TRUE,
    22
  );

INSERT INTO owners(full_name, age)
VALUES -- Sam Smith 34 years old.
  ('Sam Smith', 34),
  -- Jennifer Orwell 19 years old.
  ('Jennifer Orwell', 19),
  -- Bob 45 years old.
  ('Bob', 45),
  -- Melody Pond 77 years old.
  ('Melody Pond', 77),
  -- Dean Winchester 14 years old.
  ('Dean Winchester', 14),
  -- Jodie Whittaker 38 years old.
  ('Jodie Whittaker', 38);

INSERT INTO species(name)
VALUES ('Pokemon'),
  ('Digimon');

-- Modify your inserted animals so it includes the species_id value:
-- If the name ends in "mon" it will be Digimon
UPDATE animals
SET species_id = (
    SELECT id
    FROM species
    WHERE name = 'Digimon'
  )
WHERE name LIKE '%mon';

-- All other animals are Pokemon
UPDATE animals
SET species_id = (
    SELECT id
    FROM species
    WHERE name = 'Pokemon'
  )
WHERE species_id ISNULL;

-- Modify your inserted animals to include owner information (owner_id):
-- Sam Smith owns Agumon.
UPDATE animals
SET owner_id = (
    SELECT id
    FROM owners
    WHERE full_name = 'Sam Smith'
  )
WHERE name = 'Agumon';

-- Jennifer Orwell owns Gabumon and Pikachu.
UPDATE animals
SET owner_id = (
    SELECT id
    FROM owners
    WHERE full_name = 'Jennifer Orwell'
  )
WHERE name IN ('Gabumon', 'Pikachu');

-- Bob owns Devimon and Plantmon.
UPDATE animals
SET owner_id = (
    SELECT id
    FROM owners
    WHERE full_name = 'Bob'
  )
WHERE name IN ('Devimon', 'Plantmon');

-- Melody Pond owns Charmander, Squirtle, and Blossom.
UPDATE animals
SET owner_id = (
    SELECT id
    FROM owners
    WHERE full_name = 'Melody Pond'
  )
WHERE name IN ('Charmander', 'Squirtle', 'Blossom');

-- Dean Winchester owns Angemon and Boarmon.
UPDATE animals
SET owner_id = (
    SELECT id
    FROM owners
    WHERE full_name = 'Dean Winchester'
  )
WHERE name IN ('Angemon', 'Boarmon');