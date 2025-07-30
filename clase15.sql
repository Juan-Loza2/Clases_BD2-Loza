-- #1: Crear vista list_of_customers
create or replace view list_of_customers as
select
    c.customer_id,
    concat(c.first_name, ' ', c.last_name) as full_name,
    a.address,
    a.postal_code as zip_code,
    a.phone,
    ci.city,
    co.country,
    case when c.active = 1 then 'active' else 'inactive' end as status,
    c.store_id
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id;

-- #2: Crear vista film_details
create or replace view film_details as
select 
    f.film_id,
    f.title,
    f.description,
    c.name as category,
    f.rental_rate as price,
    f.length,
    f.rating,
    group_concat(concat(a.first_name, ' ', a.last_name) separator ', ') as actors
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
group by f.film_id, f.title, f.description, c.name, f.rental_rate, f.length, f.rating;

-- #3: Crear vista sales_by_film_category
create or replace view sales_by_film_category as
select 
    c.name as category,
    sum(p.amount) as total_rental
from payment p
join rental r on p.rental_id = r.rental_id
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
group by c.name;

-- #4: Crear vista actor_information
create or replace view actor_information as
select 
    a.actor_id,
    a.first_name,
    a.last_name,
    count(fa.film_id) as film_count
from actor a
join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id, a.first_name, a.last_name;

-- #5: Análisis detallado de la vista actor_info
/*
La vista `actor_info` se define así:

select 
    a.actor_id,
    a.first_name,
    a.last_name,
    (
        select group_concat(f.title order by f.title separator ', ')
        from film f
        join film_actor fa2 on f.film_id = fa2.film_id
        where fa2.actor_id = a.actor_id
    ) as film_info
from actor a;

Explicación por partes:

1. FROM actor a:
   - Se parte de la tabla `actor`, lo que significa que se listará un registro por cada actor existente.

2. Columnas seleccionadas:
   - `a.actor_id`, `a.first_name`, `a.last_name`: se muestra la información básica del actor.

3. Subconsulta:
   - Esta parte se ejecuta por cada actor (subconsulta correlacionada).

   (
     select group_concat(f.title order by f.title separator ', ')
     from film f
     join film_actor fa2 on f.film_id = fa2.film_id
     where fa2.actor_id = a.actor_id
   )

   ¿Qué hace?
   - Se obtienen los títulos (`f.title`) de todas las películas asociadas al actor actual (`a.actor_id`).
   - Se une `film` con `film_actor` para obtener los films donde actuó.
   - `where fa2.actor_id = a.actor_id` es la parte clave: vincula al actor externo (de la vista) con el actor interno (de la subconsulta).
   - `group_concat(...)` concatena todos los títulos en un solo string, separados por coma, ordenados alfabéticamente.

   Resultado:
   - Para cada actor, se muestra una lista de las películas en las que participó, como texto en la columna `film_info`.
*/

-- #6: Vistas Materializadas (explicación)
/*
Las vistas materializadas (materialized views) son estructuras que almacenan físicamente el resultado de una consulta compleja.

¿Para qué se usan?
- Para mejorar el rendimiento en consultas que se repiten con frecuencia y que son costosas de calcular.
- Especialmente útiles cuando los datos subyacentes no cambian constantemente.

Características:
- Se pueden actualizar manualmente (con REFRESH).
- Permiten agregaciones, uniones, cálculos costosos, etc.
- Se pueden indexar para búsquedas rápidas.

Alternativas:
- Vistas normales (se ejecutan cada vez que se consultan).
- Tablas temporales o intermedias con datos precalculados.
- Caching en la aplicación.

DBMS que las soportan:
- PostgreSQL permite crear con `CREATE MATERIALIZED VIEW` y actualizar con `REFRESH MATERIALIZED VIEW`.
- Oracle: tiene soporte completo para vistas materializadas, incluso con refresco automático.
- SQL Server: no tiene vistas materializadas como tal, pero ofrece "indexed views" que funcionan de forma similar.
- MySQL: no tiene soporte nativo, pero se pueden simular usando tablas + triggers o procedimientos almacenados.
*/
