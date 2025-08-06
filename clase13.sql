-- ===========================================
-- 1. Agregar un nuevo cliente
-- Almacenar en la tienda 1.
-- Usar una dirección existente: la que tenga el mayor address_id de Estados Unidos.
-- ===========================================
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)
VALUES (
    1,
    'John',
    'Doe',
    'john.doe@email.com',
    (
        SELECT MAX(address_id)
        FROM address
        JOIN city ON address.city_id = city.city_id
        JOIN country ON city.country_id = country.country_id
        WHERE country.country = 'United States'
    ),
    1,
    NOW()
);

-- ===========================================
-- 2. Agregar un alquiler
-- Seleccionar una película por título (no usar ID).
-- Usar el inventory_id más alto disponible para esa película.
-- Usar cualquier staff_id de la tienda 2.
-- ===========================================
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    (
        SELECT MAX(inventory_id)
        FROM inventory
        WHERE film_id = (
            SELECT film_id FROM film WHERE title = 'Film Title'
        )
    ),
    (
        SELECT MAX(customer_id) FROM customer
    ),
    (
        SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1
    )
);

-- ===========================================
-- 3. Actualizar año de publicación según clasificación
-- Usamos el siguiente mapeo:
-- 'G' => 2001
-- 'PG' => 2002
-- 'PG-13' => 2003
-- 'R' => 2004
-- 'NC-17' => 2005
-- ===========================================
UPDATE film SET release_year = 2001 WHERE rating = 'G';
UPDATE film SET release_year = 2002 WHERE rating = 'PG';
UPDATE film SET release_year = 2003 WHERE rating = 'PG-13';
UPDATE film SET release_year = 2004 WHERE rating = 'R';
UPDATE film SET release_year = 2005 WHERE rating = 'NC-17';

-- ===========================================
-- 4. Devolver una película
-- Buscar el último alquiler no devuelto.
-- Usar ese rental_id y establecer la fecha de devolución.
-- ===========================================
UPDATE rental
SET return_date = NOW()
WHERE rental_id = (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
);

-- ===========================================
-- 5. Intentar eliminar una película
-- Si se intenta:
-- DELETE FROM film WHERE title = 'Film Title';
-- Fallará por restricciones de claves foráneas.
-- Por lo tanto, se deben eliminar todas sus referencias primero.
-- ===========================================

-- Eliminar alquileres relacionados (vía inventory)
DELETE FROM rental
WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = (
        SELECT film_id FROM film WHERE title = 'Film Title'
    )
);

-- Eliminar inventario
DELETE FROM inventory
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'Film Title'
);

-- Eliminar actores asociados
DELETE FROM film_actor
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'Film Title'
);

-- Eliminar categorías asociadas
DELETE FROM film_category
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'Film Title'
);

-- Finalmente, eliminar la película
DELETE FROM film
WHERE title = 'Film Title';

-- ===========================================
-- 6. Alquilar una película (seleccionando manualmente un inventory_id disponible)
-- Buscar un inventory_id que no esté alquilado actualmente.
-- Luego usarlo para agregar el alquiler y el pago.
-- ===========================================

-- (Ejemplo: obtenemos manualmente un inventory_id disponible)
-- SELECT inventory_id FROM inventory
-- WHERE inventory_id NOT IN (
--     SELECT inventory_id FROM rental WHERE return_date IS NULL
-- )
-- LIMIT 1;

-- Supongamos que elegimos el ID 999 (este número debe obtenerse antes)

-- Insertar alquiler
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (
    NOW(),
    999,
    (SELECT MAX(customer_id) FROM customer),
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1)
);

-- Insertar pago
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (
    (SELECT MAX(customer_id) FROM customer),
    (SELECT staff_id FROM staff WHERE store_id = 2 LIMIT 1),
    (SELECT MAX(rental_id) FROM rental),
    5.99,
    NOW()
);

-- ===========================================
-- 7. Restaurar la base de datos a su estado original
-- Usar el script de carga del ejercicio de la clase 3 (populate script)
-- Esto puede hacerse en consola con:
-- mysql -u root -p sakila < sakila_populate.sql
-- O desde el cliente MySQL con:
-- SOURCE /ruta/al/archivo/sakila_populate.sql;
-- ===========================================
