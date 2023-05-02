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