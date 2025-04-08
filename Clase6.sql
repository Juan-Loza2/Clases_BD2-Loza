use sakila;

#1-List all the actors that share the last name. Show them in order


select first_name , last_name from actor 
	where last_name in(
	select last_name from actor group by last_name
	having count(*) > 1
) order by last_name;

#2-Find actors that don't work in any film

select actor_id, first_name , last_name from actor 
where actor_id not in (
select actor_id from film_actor where actor_id is not null
);

#3-Find customers that rented only one film

select customer_id , first_name , last_name from customer
where customer_id in(
select customer_id from rental GROUP BY customer_id
HAVING COUNT(*) = 1
);

#4-Find customers that rented more than one film

select customer_id , first_name , last_name from customer
where customer_id in(
select customer_id from rental GROUP BY customer_id
HAVING COUNT(*) > 1
);


#5-List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'

select actor_id, first_name , last_name from actor 
	where actor_id in (
		select actor_id from film_actor 
    where film_id in(
		select film_id from film where title = "BETRAYED REAR" or title = "CATCH AMISTAD"
	)
);

#6-List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'

select actor_id, first_name , last_name from actor 
	where actor_id in (
		select actor_id from film_actor 
				where film_id in(
					select film_id from film where title = "BETRAYED REAR" 
	))
    
	and actor_id not in (
		select actor_id from film_actor 
			where film_id in(
				select film_id from film where title = "CATCH AMISTAD" 
	)
);

#7-List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'

select actor_id, first_name , last_name from actor 
	where actor_id in (
		select actor_id from film_actor 
				where film_id in(
					select film_id from film where title = "BETRAYED REAR" 
	))
    
	and actor_id in (
		select actor_id from film_actor 
			where film_id in(
				select film_id from film where title = "CATCH AMISTAD" 
	)
);
#8-List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'

select actor_id, first_name , last_name from actor 
	where actor_id not in (
		select actor_id from film_actor 
				where film_id in(
					select film_id from film where title = "BETRAYED REAR" 
	))
    
	and actor_id not in (
		select actor_id from film_actor 
			where film_id in(
				select film_id from film where title = "CATCH AMISTAD" 
	)
);



