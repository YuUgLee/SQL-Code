-- NOT expression
SELECT name, year_released
    FROM movies
WHERE NOT(year_released = 2000 AND RANK >8);

-- DeMorgan's Law
SELECT name, year_released
    FROM movies
WHERE year_released <> 2000 OR rank <= 8;


-- LIKE operators
-- '' '' allows to put apostrophes in the quote
SELECT *
    FROM actors
WHERE first_name LIKE 'Sydney ''Big Dawg''';

-- Percent sign % matches any number of characters
SELECT *
    FROM actors
WHERE first_name LIKE 'Sydney%';

-- IN operator
SELECT name, year_released
    FROM movies
WHERE year_released IN (2000,1999) AND rank > 8;

-- NULLS
SELECT *
    FROM movies
WHERE rank >=7 or rank IS NULL;

-- Set difference: {all genres} - {genres describing movies}
SELECT *
    FROM genres
EXCEPT
SELECT genre
    FROM movies_genres;

SELECT name as genre
    FROM genres
EXCEPT
SELECT genre
    FROM movies_genres;

-- underscore _ match one character exactly in the specified position
SELECT *
    FROM actors
WHERE first_name LIKE 'Sydney _Big Dawg_';

SELECT name, id
    FROM movies m RIGHT OUTER JOIN movies_genres mg on m.id=mg.movie_id;