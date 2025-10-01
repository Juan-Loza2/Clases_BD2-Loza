	SET profiling = 1;


-- 1) Address: consultas con postal_code


-- 1.a Query con IN
SELECT address_id, address, postal_code 
FROM address 
WHERE postal_code IN ('52137', '85310', '97604');

-- 1.b Query con NOT IN
SELECT address_id, address, postal_code 
FROM address 
WHERE postal_code NOT IN ('52137', '85310');

-- 1.c Query con JOIN a city y country
SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code = '52137';

SHOW PROFILES;

-- Crear índice en postal_code
CREATE INDEX idx_postal_code ON address(postal_code);

-- Repetir queries para comparar
SELECT address_id, address, postal_code 
FROM address 
WHERE postal_code IN ('52137', '85310', '97604');

SELECT address_id, address, postal_code 
FROM address 
WHERE postal_code NOT IN ('52137', '85310');

SELECT a.address_id, a.address, a.postal_code, c.city, co.country
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE a.postal_code = '52137';

SHOW PROFILES;

-- Explicación:
-- Antes del índice: full table scan (MySQL recorre todas las filas).
-- Después del índice: index range scan, mucho más rápido.
-- En sakila (tabla pequeña) la diferencia es baja, pero en tablas grandes se nota mucho.



-- 2) Actor: búsquedas por nombre


-- Buscar por first_name
SELECT * FROM actor WHERE first_name = 'PENELOPE';

-- Buscar por last_name
SELECT * FROM actor WHERE last_name = 'GUINESS';

-- Crear índices
CREATE INDEX idx_actor_first_name ON actor(first_name);
CREATE INDEX idx_actor_last_name ON actor(last_name);

-- Repetir queries con índices
SELECT * FROM actor WHERE first_name = 'PENELOPE';
SELECT * FROM actor WHERE last_name = 'GUINESS';

SHOW PROFILES;

-- Explicación:
-- Inicialmente se hace un full scan, ya que no hay índices.
-- Con índices, las búsquedas son más rápidas.
-- El índice en last_name suele ser más eficiente porque tiene más variedad de valores (más selectividad).



-- 3) Film: LIKE vs FULLTEXT


-- Búsqueda con LIKE en description (film)
SELECT film_id, title, description
FROM film
WHERE description LIKE '%girl%';

-- Búsqueda con FULLTEXT en film_text
SELECT film_id, title, description
FROM film_text
WHERE MATCH(description) AGAINST('girl');

-- Búsqueda avanzada con boolean mode
SELECT film_id, title, description
FROM film_text
WHERE MATCH(description) AGAINST('+girl -boy' IN BOOLEAN MODE);

SHOW PROFILES;

-- Explicación:
-- LIKE con %palabra% no puede usar índice → full table scan → lento.
-- FULLTEXT usa un índice especial optimizado para búsquedas semánticas → mucho más rápido y con ranking de relevancia.
