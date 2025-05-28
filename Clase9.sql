
use sakila;

# Obtener la cantidad de ciudades por país. Ordenar por nombre de país y country_id.
select c.country_id, c.country, count(ci.city_id) as city_count
from country c
join city ci on c.country_id = ci.country_id
group by c.country_id, c.country
order by c.country, c.country_id;

# Obtener la cantidad de ciudades por país con más de 10 ciudades. Ordenar de mayor a menor cantidad.
select c.country_id, c.country, count(ci.city_id) as city_count
from country c
join city ci on c.country_id = ci.country_id
group by c.country_id, c.country
having count(ci.city_id) > 10
order by city_count desc;

# Generar un reporte con nombre del cliente, dirección, cantidad total de películas alquiladas y dinero total gastado.
# Mostrar primero los que más dinero gastaron.
select cu.first_name, cu.last_name, a.address,
       count(r.rental_id) as total_rentals,
       sum(p.amount) as total_spent
from customer cu
join address a on cu.address_id = a.address_id
join rental r on cu.customer_id = r.customer_id
join payment p on r.rental_id = p.rental_id
group by cu.customer_id, cu.first_name, cu.last_name, a.address
order by total_spent desc;

# Mostrar las categorías de películas con mayor duración promedio. Ordenar de mayor a menor duración.
select cat.name as category, avg(f.length) as average_duration
from film f
join film_category fc on f.film_id = fc.film_id
join category cat on fc.category_id = cat.category_id
group by cat.name
order by average_duration desc;

# Mostrar ventas totales por clasificación de película (rating).
select f.rating, sum(p.amount) as total_sales
from film f
join inventory i on f.film_id = i.film_id
join rental r on i.inventory_id = r.inventory_id
join payment p on r.rental_id = p.rental_id
group by f.rating
order by total_sales desc;
