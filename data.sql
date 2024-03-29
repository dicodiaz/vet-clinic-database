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

INSERT INTO vets(name, age, date_of_graduation)
VALUES -- Vet William Tatcher is 45 years old and graduated Apr 23rd, 2000.
  ('William Tatcher', 45, make_date(2000, 04, 23)),
  -- Vet Maisy Smith is 26 years old and graduated Jan 17th, 2019.
  ('Maisy Smith', 26, make_date(2019, 01, 17)),
  -- Vet Stephanie Mendez is 64 years old and graduated May 4th, 1981.
  ('Stephanie Mendez', 64, make_date(1981, 05, 04)),
  -- Vet Jack Harkness is 38 years old and graduated Jun 8th, 2008.
  ('Jack Harkness', 38, make_date(2008, 06, 08));

INSERT INTO specializations(species_id, vet_id)
VALUES -- Vet William Tatcher is specialized in Pokemon.
  (
    (
      SELECT species.id
      FROM species
      WHERE name = 'Pokemon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'William Tatcher'
    )
  ),
  -- Vet Stephanie Mendez is specialized in Digimon and Pokemon.
  (
    (
      SELECT species.id
      FROM species
      WHERE name = 'Digimon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    )
  ),
  (
    (
      SELECT species.id
      FROM species
      WHERE name = 'Pokemon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    )
  ),
  -- Vet Jack Harkness is specialized in Digimon.
  (
    (
      SELECT species.id
      FROM species
      WHERE name = 'Digimon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Jack Harkness'
    )
  );

INSERT INTO visits(animal_id, vet_id, date_of_visit)
VALUES -- Agumon visited William Tatcher on May 24th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Agumon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'William Tatcher'
    ),
    make_date(2020, 05, 04)
  ),
  -- Agumon visited Stephanie Mendez on Jul 22th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Agumon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    ),
    make_date(2020, 07, 22)
  ),
  -- Gabumon visited Jack Harkness on Feb 2nd, 2021.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Gabumon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Jack Harkness'
    ),
    make_date(2021, 02, 02)
  ),
  -- Pikachu visited Maisy Smith on Jan 5th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Pikachu'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2020, 01, 05)
  ),
  -- Pikachu visited Maisy Smith on Mar 8th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Pikachu'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2020, 03, 08)
  ),
  -- Pikachu visited Maisy Smith on May 14th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Pikachu'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2020, 05, 14)
  ),
  -- Devimon visited Stephanie Mendez on May 4th, 2021.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Devimon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    ),
    make_date(2021, 05, 04)
  ),
  -- Charmander visited Jack Harkness on Feb 24th, 2021.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Charmander'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Jack Harkness'
    ),
    make_date(2021, 02, 24)
  ),
  -- Plantmon visited Maisy Smith on Dec 21st, 2019.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Plantmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2019, 12, 21)
  ),
  -- Plantmon visited William Tatcher on Aug 10th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Plantmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'William Tatcher'
    ),
    make_date(2020, 08, 10)
  ),
  -- Plantmon visited Maisy Smith on Apr 7th, 2021.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Plantmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2021, 04, 07)
  ),
  -- Squirtle visited Stephanie Mendez on Sep 29th, 2019.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Squirtle'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    ),
    make_date(2019, 09, 29)
  ),
  -- Angemon visited Jack Harkness on Oct 3rd, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Angemon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Jack Harkness'
    ),
    make_date(2020, 10, 03)
  ),
  -- Angemon visited Jack Harkness on Nov 4th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Angemon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Jack Harkness'
    ),
    make_date(2020, 11, 04)
  ),
  -- Boarmon visited Maisy Smith on Jan 24th, 2019.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Boarmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2019, 01, 24)
  ),
  -- Boarmon visited Maisy Smith on May 15th, 2019.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Boarmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2019, 05, 15)
  ),
  -- Boarmon visited Maisy Smith on Feb 27th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Boarmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2020, 02, 27)
  ),
  -- Boarmon visited Maisy Smith on Aug 3rd, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Boarmon'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Maisy Smith'
    ),
    make_date(2020, 08, 03)
  ),
  -- Blossom visited Stephanie Mendez on May 24th, 2020.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Blossom'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'Stephanie Mendez'
    ),
    make_date(2020, 05, 24)
  ),
  -- Blossom visited William Tatcher on Jan 11th, 2021.
  (
    (
      SELECT id
      FROM animals
      WHERE name = 'Blossom'
    ),
    (
      SELECT id
      FROM vets
      WHERE name = 'William Tatcher'
    ),
    make_date(2021, 01, 11)
  );

INSERT INTO visits (animal_id, vet_id, date_of_visit)
SELECT *
FROM (
    SELECT id
    FROM animals
  ) animal_ids,
  (
    SELECT id
    FROM vets
  ) vets_ids,
  generate_series('1980-01-01'::TIMESTAMP, '2021-01-01', '4 hours') visit_timestamp;

INSERT INTO owners (full_name, email)
SELECT 'Owner ' || generate_series(1, 2500000),
  'owner_' || generate_series(1, 2500000) || '@mail.com';