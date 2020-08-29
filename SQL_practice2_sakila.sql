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
#LIMIT 1

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

#15. Select all the rentals in May whose amount is higher than the 
#average May payment amount
Set @avg_amount = (select avg(amount) from payment where month(payment_date)= 5);
select * from payment
where amount > @avg_amount
and month(payment_date)= 5 ;





#16. 
#Part1 -- Is 'Academy Dinosaur' available for rent from Store 1?
SELECT inventory_id from inventory 
WHERE film_id in 
(
SELECT film_id from film WHERE title = 'Academy Dinosaur'
)
and store_id = 1;

# Insert a record to represent Mary Smith renting 'Academy Dinosaur' from Mike Hillyer at Store 1 today .
INSERT INTO rental(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
    Values(rental_id,'2020-08-25 13:20:00', 1, 1, '2020-08-25 13:20:00', 1, '2020-08-25 13:20:00');
    
#-- When is 'Academy Dinosaur' due?
SET @rental_duration = rental.return_date - rental.rental_date;

#What is that average length of all the films in the sakila DB?
SELECT avg(length) from film;

#What is the average length of films by category?
SELECT b.avg_length, name from
(SELECT avg(length) as avg_length, category_id from film_category
join film
on film_category.film_id = film.film_id
group by  category_id) as b
join category as a
on b.category_id = a.category_id;

#Which film categories are long? Long = lengh is longer than the average film length
SET @avgamount = (select avg(avg_length) from
(
SELECT avg(length) as avg_length, category_id from film_category
join film
on film_category.film_id = film.film_id
group by  category_id) as b
);
SELECT c.avg_length as avglength, c.name as Name from
(
    SELECT b.avg_length, name from
(SELECT avg(length) as avg_length, category_id from film_category
join film
on film_category.film_id = film.film_id
group by  category_id) as b
join category as a
on b.category_id = a.category_id
) as c
WHERE c.avg_length > @avgamount;






#PART2
#1A Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
from actor;
#1b Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT 
group_concat(upper(first_name)," ", upper(last_name)) as 'Actor Name'
FROM actor
Group by actor_id;


#2A you need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe."
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'Joe';
#2b. Find all actors whose last name contain the letters GEN:
SELECT * 
FROM actor
WHERE last_name like "%GEN%";
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT * 
FROM actor
WHERE last_name like "%LI%"
Order by last_name ASC, first_name ASC;
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country 
FROM country
WHERE country in ('Afghanistan', 'Bangladesh', 'China');


# 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
Alter Table actor
add column middle_name VARCHAR(30) not null
After first_name;
#3b You realize that some of these actors have tremendously long last names.
##Change the data type of the middle_name column to blobs.
Alter Table actor
modify column middle_name blob;
#3c. Now delete the middle_name column.
Alter Table actor
drop column middle_name;


## 4a List the last names of actors, as well as how many actors have that last name.
SELECT distinct(last_name), count(actor_id)
FROM actor
group by last_name;
## 4b List last names of actors and the number of actors who have that last name,
##but only for names that are shared by at least two actors
SELECT b.lastname, b.number FROM
(SELECT distinct(last_name) as lastname, count(actor_id) as number
FROM actor
GROUP BY last_name) as b
WHERE b.number > 1;
## 4cOh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS,
##	the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
SET SQL_SAFE_UPDATES = 0;
update actor
Set first_name = 'HARPO'
WHERE first_name = 'GROUCHO';
SET SQL_SAFE_UPDATES = 1;
## 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct
-- name after all!
-- In a single query, if the first name of the actor is currently HARPO,
-- change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what
-- the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR
-- TO MUCHO GROUCHO, HOWEVER!
SET SQL_SAFE_UPDATES = 0;
update actor
set first_name = 
case
    when first_name="HARPO" then "GROUCHO"
    when first_name="GROUCHO" then "MUCHO GROUCHO"
    else first_name
end;
SET SQL_SAFE_UPDATES = 1;


##5A You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW columns From sakila.address;
##describe

## 6a Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address
FROM staff
Join address
On staff.address_id = address.address_id
group by staff_id;
##6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT staff.staff_id, sum(amount) 
FROM staff
join payment
On staff.staff_id = payment.staff_id
Group by staff.staff_id;
##6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.film_id, title, count(actor_id) 
FROM film
inner join film_actor
on film.film_id = film_actor.film_id
group by film.film_id;
##6c How many copies of the film Hunchback Impossible exist in the inventory system?
## #13
##6d Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- 	List the customers alphabetically by last name:
## #14


## 7a The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence,
--  films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of
--  movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title like 'K%' 
or title like 'Q%'
and language_id in 
(
    SELECT language_id from language
    WHERE name = 'English'
);
## 7b Use subqueries to display all actors who appear in the film Alone Trip.
SELECT *
FROM actor 
WHERE actor_id in 
(
    SELECT actor_id FROM film_actor
    WHERE film_id in 
    (
        SELECT film_id from film
        WHere title = 'Alone Trip'
    )
);
## 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- 	email addresses of all Canadian customers.
-- 	Use joins to retrieve this information.
SELECT first_name, last_name, email
FROM country as a
join city b on a.country_id = b.country_id
join address c on b.city_id = c.city_id
join customer d on c.address_id = d.address_id
WHERE a.country = 'Canada';
## 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
--  Identify all movies categorized as famiy films.
SELECT * FROM film
WHERE film_id in
(
    SELECT film_id FROM film_category
    WHERE category_id in 
        (
        SELECT category_id FROM category
        WHERE name = 'Family'
        )
);
## 7e. Display the most frequently rented movies in descending order.
with temp as
(select count(rental_id) as num, inventory_id
from rental 
group by inventory_id)
SELECT sum(num) as sumnum, film.film_id, title from temp
join inventory 
on inventory.inventory_id = temp.inventory_id
join film on film.film_id = inventory.film_id
GROUP by film_id
Order by sumnum DESC;
## 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT sum(amount), store_id 
FROM payment
Join staff
on payment.staff_id = staff.staff_id
Group by store_id 
order by sum(amount) DESC;
## 7gWrite a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
join address on address.address_id = store.address_id
join city on city.city_id = address.city_id
join country on country.country_id = city.country_id;
## 7h. List the top five genres in gross revenue in descending order.
SELECT category.name, sum(amount)
FROM category 
join film_category on film_category.category_id = category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on inventory.inventory_id = rental.inventory_id
join payment on rental.rental_id = payment.rental_id
group by category.name
Order by sum(amount) DESC
LIMIT 5;


## 8a In your new role as an executive, you would like to have an easy way of viewing
--  	the Top five genres by gross revenue. Use the solution from the problem above to create a view.
--  	If you haven't solved 7h, you can substitute another query to create a view.
CREATE view Top5genres as 
    SELECT category.name, sum(amount)
    FROM category 
    join film_category on film_category.category_id = category.category_id
    join inventory on inventory.film_id = film_category.film_id
    join rental on inventory.inventory_id = rental.inventory_id
    join payment on rental.rental_id = payment.rental_id
    group by category.name
    Order by sum(amount) DESC
    LIMIT 5;
## 8b. How would you display the view that you created in 8a?
SELECT *
FROM top5genres;
##8c You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP view if exists top5genres;
SHOW CREATE view Top5genres;
