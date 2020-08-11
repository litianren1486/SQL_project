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
Order by count(staff_id) DESC
LIMIT 1;

#8.	Which customer paid the most rental in August?
SELECT sum(amount), customer_id FROM payment
group by customer_id
order by sum(amount) DESC
LIMIT 1;


#9.	A summary of rental total amount by month.
SELECT sum(amount),month(payment_date) FROM payment
group by month(payment_date);




