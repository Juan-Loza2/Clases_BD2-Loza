use sakila;

#Find the films with less duration, show the title and rating.

select title , rating , length from film 
	where length = (select min(length) from film);
    
#Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset

SELECT title FROM film
	WHERE length = (SELECT MIN(length) FROM film)
	AND (SELECT COUNT(*) FROM film WHERE length = (SELECT MIN(length) FROM film)) = 1;

#Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.

SELECT c.customer_id, c.first_name, c.last_name, a.address, MIN(p.amount) AS lowest_payment FROM customer c
	JOIN payment p ON c.customer_id = p.customer_id
	JOIN address a ON c.address_id = a.address_id
	GROUP BY c.customer_id, c.first_name, c.last_name, a.address;


#Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

SELECT c.customer_id, c.first_name, c.last_name, a.address,
       MAX(p.amount) AS highest_payment,
       MIN(p.amount) AS lowest_payment
FROM customer c
	JOIN payment p ON c.customer_id = p.customer_id
	JOIN address a ON c.address_id = a.address_id
	GROUP BY c.customer_id, c.first_name, c.last_name, a.address;

