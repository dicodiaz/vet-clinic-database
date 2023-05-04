-- Queries that provide answers to the questions from all projects.
-- 1. Find all animals whose name ends in "mon".
SELECT *
FROM animals
WHERE name LIKE '%mon';

-- 2. List the name of all animals born between 2016 and 2019.
SELECT name
FROM animals
WHERE date_of_birth BETWEEN make_date(2016, 01, 01) AND make_date(2019, 12, 31);

-- 3. List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name
FROM animals
WHERE neutered = TRUE
  AND escape_attempts < 3;

-- 4. List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth
FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- 5. List name and escape attempts of animals that weigh more than 10.5kg
SELECT name,
  escape_attempts
FROM animals
WHERE weight_kg > 10.5;

-- 6. Find all animals that are neutered.
SELECT *
FROM animals
WHERE neutered = TRUE;

-- 7. Find all animals not named Gabumon.
SELECT *
FROM animals
WHERE name != 'Gabumon';

-- 8. Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT *
FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- 9. Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;

UPDATE animals
SET species = 'unspecified';

SELECT *
FROM animals;

ROLLBACK;

SELECT *
FROM animals;

/* 10. Inside a transaction:
 Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
 Update the animals table by setting the species column to pokemon for all animals that don't have species already set.
 Commit the transaction.
 Verify that change was made and persists after commit. */
BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species ISNULL;

SELECT *
FROM animals;

COMMIT;

SELECT *
FROM animals;

/* 11. Now, take a deep breath and... Inside a transaction delete all records in the animals table, then roll back the transaction.
 After the rollback verify if all records in the animals table still exists. After that, you can start breathing as usual ;) */
BEGIN;

DELETE FROM animals;

SELECT *
FROM animals;

ROLLBACK;

SELECT *
FROM animals;

/* 12. Inside a transaction:
 Delete all animals born after Jan 1st, 2022.
 Create a savepoint for the transaction.
 Update all animals' weight to be their weight multiplied by -1.
 Rollback to the savepoint
 Update all animals' weights that are negative to be their weight multiplied by -1.
 Commit transaction */
BEGIN;

DELETE FROM animals
WHERE date_of_birth >= make_date(2022, 01, 01);

SELECT *
FROM animals;

SAVEPOINT SP1;

UPDATE animals
SET weight_kg = animals.weight_kg * -1;

SELECT *
FROM animals;

ROLLBACK TO SAVEPOINT SP1;

SELECT *
FROM animals;

UPDATE animals
SET weight_kg = animals.weight_kg * -1
WHERE weight_kg < 0;

COMMIT;

SELECT *
FROM animals;

-- 13. How many animals are there?
SELECT COUNT(*)
FROM animals;

-- 14. How many animals have never tried to escape?
SELECT COUNT(*)
FROM animals
WHERE escape_attempts = 0;

-- 15. What is the average weight of animals?
SELECT AVG(weight_kg) AS "avg weight"
FROM animals;

-- 16. Who escapes the most, neutered or not neutered animals?
SELECT neutered,
  SUM(escape_attempts) AS "sum of escape attempts"
FROM animals
GROUP BY neutered;

-- 17. What is the minimum and maximum weight of each type of animal?
SELECT species,
  MIN(weight_kg) AS "min weight",
  MAX(weight_kg) AS "max weight"
FROM animals
GROUP BY species;

-- 18. What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species,
  AVG(escape_attempts) AS "avg escape attempts"
FROM animals
WHERE date_of_birth BETWEEN make_date(1990, 01, 01) AND make_date(2000, 12, 31)
GROUP BY species;

-- 19. What animals belong to Melody Pond?
SELECT owners.full_name AS "owner's name",
  animals.name AS "animal's name"
FROM owners
  JOIN animals ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond';

-- 20. List of all animals that are pokemon (their type is Pokemon).
SELECT species.name AS "species",
  animals.name AS "animal's name"
FROM species
  JOIN animals ON animals.species_id = species.id
WHERE species.name = 'Pokemon';

-- 21. List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name AS "owners's name",
  animals.name AS "animal's name"
FROM owners
  LEFT JOIN animals ON animals.owner_id = owners.id;

-- 22. How many animals are there per species?
SELECT species.name AS "species",
  COUNT(animals.id)
FROM species
  JOIN animals ON animals.species_id = species.id
GROUP BY species.id;

-- 23. List all Digimon owned by Jennifer Orwell.
SELECT owners.full_name AS "owner's name",
  species.name AS "species",
  animals.name AS "animal's name"
FROM owners
  JOIN animals ON animals.owner_id = owners.id
  JOIN species ON species.id = animals.species_id
WHERE owners.full_name = 'Jennifer Orwell'
  AND species.name = 'Digimon';

-- 24. List all animals owned by Dean Winchester that haven't tried to escape.
SELECT owners.full_name AS "owner's name",
  animals.name AS "animal's name",
  animals.escape_attempts
FROM owners
  JOIN animals ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester'
  AND animals.escape_attempts = 0;

-- 25. Who owns the most animals?
SELECT owners.full_name AS "owner's name",
  COUNT(animals.id)
FROM owners
  JOIN animals ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY COUNT(animals.id) DESC;

-- 26. Who was the last animal seen by William Tatcher?
SELECT vets.name AS "vet's name",
  animals.name AS "animal's name",
  visits.date_of_visit
FROM vets
  JOIN visits ON visits.vet_id = vets.id
  JOIN animals ON animals.id = visits.animal_id
WHERE vets.name = 'William Tatcher'
ORDER BY visits.date_of_visit DESC
LIMIT 1;

-- 27. How many different animals did Stephanie Mendez see?
SELECT vets.name AS "vet's name",
  COUNT(DISTINCT visits.animal_id)
FROM vets
  JOIN visits ON visits.vet_id = vets.id
GROUP BY vets.name
HAVING vets.name = 'Stephanie Mendez';

-- 28. List all vets and their specialties, including vets with no specialties.
SELECT vets.name AS "vet's name",
  species.name AS "specialty"
FROM vets
  LEFT JOIN specializations ON specializations.vet_id = vets.id
  LEFT JOIN species ON species.id = specializations.species_id;

-- 29. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT vets.name AS "vet's name",
  animals.name AS "animal's name",
  visits.date_of_visit
FROM vets
  JOIN visits ON visits.vet_id = vets.id
  JOIN animals ON animals.id = visits.animal_id
WHERE vets.name = 'Stephanie Mendez'
  AND visits.date_of_visit BETWEEN make_date(2020, 04, 01) AND make_date(2020, 08, 30);

-- 30. What animal has the most visits to vets?
SELECT animals.name AS "animal's name",
  COUNT(visits.id)
FROM animals
  JOIN visits ON visits.animal_id = animals.id
GROUP BY animals.name
ORDER BY COUNT(visits.id) DESC
LIMIT 1;

-- 31. Who was Maisy Smith's first visit?
SELECT vets.name AS "vet's name",
  animals.name AS "animal's name",
  visits.date_of_visit
FROM vets
  JOIN visits ON visits.vet_id = vets.id
  JOIN animals ON animals.id = visits.animal_id
WHERE vets.name = 'Maisy Smith'
ORDER BY visits.date_of_visit ASC
LIMIT 1;

-- 32. Details for most recent visit: animal information, vet information, and date of visit.
SELECT filtered_visits.date_of_visit,
  vets.name AS "vet_name",
  vets.age AS "vet_age",
  vets.date_of_graduation,
  animals.name AS "animal_name",
  animals.date_of_birth,
  animals.escape_attempts,
  animals.neutered,
  animals.weight_kg,
  species.name AS "species",
  owners.full_name AS "owner_name"
FROM (
    SELECT *
    FROM visits
    ORDER BY date_of_visit DESC
    LIMIT 1
  ) AS filtered_visits
  JOIN vets ON vets.id = filtered_visits.vet_id
  JOIN animals ON animals.id = filtered_visits.animal_id
  JOIN species ON species.id = animals.species_id
  JOIN owners ON owners.id = animals.owner_id;

-- 33. How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(visits.id)
FROM visits
  JOIN animals ON animals.id = visits.animal_id
  JOIN vets ON vets.id = visits.vet_id
WHERE animals.species_id NOT IN (
    SELECT species_id
    FROM specializations
    WHERE vet_id = vets.id
  );

-- 34. What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name AS "specialty",
  COUNT(visits.id)
FROM (
    SELECT id,
      name
    FROM vets
    WHERE name = 'Maisy Smith'
  ) AS filtered_vets
  JOIN visits ON visits.vet_id = filtered_vets.id
  JOIN animals ON animals.id = visits.animal_id
  JOIN species ON species.id = animals.species_id
GROUP BY species.name
ORDER BY COUNT(visits.id) DESC;