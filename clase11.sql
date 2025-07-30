use sakila ;
#1
select f.title
from film f
left join inventory i on f.film_id = i.film_id
where i.inventory_id is null;

#2
select f.title, i.inventory_id
from film f
join inventory i on i.film_id = f.film_id
where i.inventory_id not in (
    select inventory_id 
    from rental 
    where inventory_id is not null
);


#3

select  c.first_name , c.last_name, i.store_id ,f.title , r.rental_date , r.return_date from rental r
join customer c on c.customer_id=r.customer_id
join inventory i on i.inventory_id=r.inventory_id
join film f on i.film_id=f.film_id
order by i.store_id , c.last_name
;

#4 
select 
    s.store_id,
    ci.city,
    co.country,
    m.first_name as manager_first_name,
    m.last_name as manager_last_name,
    sum(p.amount) as total_sales
from store s
join address a on s.address_id = a.address_id
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
join staff m on s.manager_staff_id = m.staff_id
join payment p on s.store_id = p.staff_id
group by s.store_id, ci.city, co.country, m.first_name, m.last_name
order by total_sales desc;

#5
select a.actor_id,a.first_name ,a.last_name, count(fa.actor_id) as cant_peliculas from actor a
join film_actor fa on fa.actor_id=a.actor_id 
group by a.actor_id , a.first_name, a.last_name
order by cant_peliculas desc
limit 1 ;


 