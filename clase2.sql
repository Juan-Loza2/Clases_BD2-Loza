create database imdb;
use imdb;

create table actor (
  actor_id smallint unsigned not null auto_increment,
  first_name varchar(45) not null,
  last_name varchar(45) not null,  
  last_update timestamp not null default current_timestamp on update current_timestamp,
  primary key (actor_id)
);

create table film (
  film_id smallint unsigned not null auto_increment,
  title varchar(255) not null,
  description text default null,
  release_year year default null,
  last_update timestamp not null default current_timestamp on update current_timestamp,
  primary key (film_id)
);

create table film_actor (
  actor_id smallint unsigned not null,
  film_id smallint unsigned not null,
  last_update timestamp not null default current_timestamp on update current_timestamp,
  primary key (actor_id, film_id),
  constraint fk_film_actor_actor foreign key (actor_id) references actor (actor_id) 
    on delete restrict on update cascade,
  constraint fk_film_actor_film foreign key (film_id) references film (film_id) 
    on delete restrict on update cascade
);

insert into actor (first_name, last_name) values
('leonardo', 'dicaprio'),
('robert', 'downey jr.'),
('scarlett', 'johansson');

insert into film (title, description, release_year) values
('inception', 'a mind-bending thriller about dreams.', 2010),
('iron man', 'the origin story of tony stark.', 2008),
('lucy', 'a woman gains extraordinary abilities.', 2014);

insert into film_actor (actor_id, film_id) values
(1, 1), 
(2, 2), 
(3, 3);

