use sakila;

# 1a.Displaying the frist and last names of all actors from the table 'actor'
select * from actor; 
select first_name, last_name
from actor;

# 1b. Displaying fristname and last name in single column as 'Actor Name'
select concat(first_name, ' ', last_name)  as Actor_name
from actor;

# 2a.Finding the ID, frist and last name from the first name only;
select actor_id, first_name, last_name
from actor
where first_name = "joe";

# 2b. Finding all actors whose last name contains the letters 'GEN':
select actor_id,first_name,last_name
from actor
where last_name like "%GEN%";

# 2c. Finding all actors whose last name contains the letters "LI":
select last_name,first_name
from actor 
where last_name like "%LI%";

# 2d. Using 'IN" display country_id and country of following countries:
select country_id,country from country where country in ("Afghanistan","Bangladesh","China");

#3a Creating a column description in actor table:
ALTER TABLE actor
ADD column description BLOB not null;
select * from actor;

#3b Deleting the description column:
alter table actor
drop column description;
select * from actor;

#4a Listing the count and last names of actors:
select last_name, count(last_name) as "Numbers_of_actors"
from actor
group by last_name;

# 4b Listing last names and no of actors shared by two actors:
select last_name, count(last_name) as "Numbers_of_actors"
from actor
group by last_name
having count(last_name) >=2;


#4c Updating the correct name for actor Hapro williams:
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" and last_name = "WILLIAMS";

#4D Rechanging the name to original correct name:
SELECT actor_id
from actor
where first_name = "HARPO" and last_name = "WILLIAMS";
   
update actor
set first_name = "GROUCHO"
where actor_id =172;
select * from actor where actor_id = 172;

# 5a. Recreate address table in sakila_db;
SHOW CREATE TABle address;
	
  #  "CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

# 6a. Joining the staff and address table:
select first_name, last_name, address
from staff 
join address
on staff.address_id = address.address_id;

# 6b Displaying the total amount rung up in August 2005:
select first_name, last_name, sum(amount)
from staff
join payment
on staff.staff_id = payment.staff_id and payment_date like "2005-08%";


# 6c Listing each film and no of actors for that film:
select title, count(actor_id)
from film
join film_actor
on film.film_id = film_actor.film_id
group by title;

# 6d Copies of film "hunchback impossible"
select title, (
select count(*) from inventory
where film.film_id = inventory.film_id
) as "Number of Copies"
from film
where title ="Hunchback Impossible";

# 6e Total paid by each customer:

select last_name,first_name, sum(amount)
from customer
join payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name asc;

# 7a Displaying the names of english movies starting with letters 'k' and 'Q'

select title, name
from film 
join language
on film.language_id = language.language_id
where title like "k%" or title like "q";

# 7b Displaying all actors who apperas in film"Alone Trip":

select first_name,last_name
from actor
where actor_id in
(
select actor_id
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
)
);

# 7c Information for Canadian citizens;
#

select customer_id,first_name,last_name,email
from customer
join address
on address.address_id = customer.address_id
join city
on city.city_id = address.city_id
join country
on country.country_id = city.country_id
where country = 'Canada';


# 7d. Identifying all movies categorized as 'family_films':

select title, description
from film
where film_id in
(
select film_id
from category
where name = 'Family'
);

# 7e Display most frequently rented movies in descending order:

select f.title, count(rental_id) as "Times Rented"
from rental r
join inventory i
on (r.inventory_id = i.inventory_id)
join film f
on (i.film_id = f.film_id)
group by f.title
order by count(rental_id) desc;

# 7f Business each store bought in:
select s.store_id,sum(amount)
from payment p
join rental r
on p.rental_id = r.rental_id
join inventory i 
on (i.inventory_id = r.inventory_id)
join store s
on (s.store_id = i.store_id)
group by s.store_id;

# 7g Display each store Id ,city and country:
select s.store_id,c.city,country.country
from store s
join address a 
on s.address_id = a.address_id
join city c
on c.city_id = a.city_id
join country
on (country.country_id = c.country_id);

# 7H List the top five genres in gross revenue:
select c.name as "Genre", sum(p.amount) AS 'Gross'
from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on i.inventory_id=r.inventory_id
join payment p 
on r.rental_id = p.rental_id
group by c.name order by Gross limit 5;

# 8a Viewing the top 5 Generes by gross:

create view top_five_genre_by_revenue as 
select c.name as "Genre", sum(p.amount) AS 'Gross'
from category c
join film_category fc
on c.category_id = fc.category_id
join inventory i
on fc.film_id = i.film_id
join rental r
on i.inventory_id=r.inventory_id
join payment p 
on r.rental_id = p.rental_id
group by c.name order by Gross limit 5;

# 8b Displaying the view:
select * from top_five_genre_by_revenue;


# 8c Deleting the view created:
drop view top_five_genre_by_revenue;





