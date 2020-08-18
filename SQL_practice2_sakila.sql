USE sakila;
##1.	Which actors have the first name 'Scarlett'?
SELECT * FROM actor
WHERE first_name = "Scarlett";

#2.	Which actors have the last name 'Johansson'
SELECT * FROM actor
WHERE last_name = "Johansson";

#3.	How many distinct actors last names are there?
SELECT count(distinct last_name) FROM actor;#121

#4.	Which last names appear more than once?
SELECT b.times, b.lastname FROM 
(SELECT count(*) as times, last_name as lastname FROM actor
GROUP by last_name)  as b
WHERE b.times>1;

#5.	How many total rentals occured in May?
SELECT count(*) FROM rental
WHERE rental_date like "%2005-05%"; #1156

#6.	How many staff processed rentals in May?
SELECT count(distinct staff_id) FROM rental
WHERE rental_date like "%2005-05%" or  return_date like "%2005-05%"; #2

#7.	Which staff processed the most rentals in May?
SELECT staff_id FROM rental 
WHERE rental_date like "%2005-05%" or  return_date like "%2005-05%"
Group by staff_id
Order by count(staff_id) DESC;
#LIMIT 1;

#8.	Which customer paid the most rental in August?
SELECT sum(amount), customer_id FROM payment
group by customer_id
order by sum(amount) DESC
LIMIT 1;


#9.	A summary of rental total amount by month.
SELECT sum(amount),month(payment_date) FROM payment
group by month(payment_date);

#10.Which actor has appeared in the most films? （Try to use SET keyboard）
SELECT actor.first_name, actor.last_name, count(film_actor.actor_id)
FROM actor
Join film_actor
On actor.actor_id = film_actor.actor_id
Group by actor.actor_id
Order by count(film_actor.actor_id) DESC
LIMIT 1;

#11.	Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address.
SELECT first_name, last_name, address FROM staff
Join address
On staff.address_id = address.address_id;

#12.	List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.film_id, film.title, count(film_actor.actor_id)
FROM film inner join film_actor
On film.film_id = film_actor.film_id
Group by film_actor.film_id;

#13.	How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT inventory.film_id, count(inventory.inventory_id) as copy_num
FROM film  Join inventory
on film.film_id = inventory.film_id
Group by film.film_id
having film.film_id in
(
    SELECT film_id FROM film
    WHERE title like ("%Hunchback Impossible%")
);

#14.	Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
SELECT sum(amount), payment.customer_id, customer.first_name, customer.last_name from payment
Join customer
on payment.customer_id = customer.customer_id
group by customer.customer_id
order by customer.last_name;
#List the customers alphabetically by last name:

