-- 1. clientes que viven en argentina
select 
    concat(c.first_name, ' ', c.last_name) as full_name,
    a.address,
    ci.city
from customer c
join address a on c.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where co.country = 'argentina';

-- 2. películas con idioma y rating en texto completo
select 
    f.title,
    l.name as language,
    case f.rating
        when 'g' then 'general audiences – all ages admitted'
        when 'pg' then 'parental guidance suggested – some material may not be suitable for children'
        when 'pg-13' then 'parents strongly cautioned – some material may be inappropriate for children under 13'
        when 'r' then 'restricted – under 17 requires accompanying parent or adult guardian'
        when 'nc-17' then 'adults only – no one 17 and under admitted'
    end as rating_description
from film f
join language l on f.language_id = l.language_id;

-- 3. películas por actor (nombre ingresado por el usuario)
set @actor_name = 'tom hanks';
select 
    f.title,
    f.release_year
from film f
join film_actor fa on f.film_id = fa.film_id
join actor a on fa.actor_id = a.actor_id
where concat(a.first_name, ' ', a.last_name) like concat('%', trim(@actor_name), '%');

-- 4. rentas en mayo y junio con indicador de devolución
select 
    f.title,
    concat(c.first_name, ' ', c.last_name) as customer_name,
    case 
        when r.return_date is not null then 'yes'
        else 'no'
    end as returned
from rental r
join inventory i on r.inventory_id = i.inventory_id
join film f on i.film_id = f.film_id
join customer c on r.customer_id = c.customer_id
where month(r.rental_date) in (5, 6);

-- 5. cast y convert ejemplos en mysql
select cast(123.45 as char) as as_text;
select convert(123.45, char) as as_text;


select title, cast(length as char) as length_text
from film;

-- 6. nvl, isnull, ifnull, coalesce en mysql
select ifnull(null, 'sin valor') as ejemplo_ifnull;
select coalesce(null, null, 'tercero') as ejemplo_coalesce;


select 
    concat(first_name, ' ', last_name) as customer_name,
    ifnull(email, 'no email') as email_display
from customer;
