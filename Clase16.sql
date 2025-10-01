-- 1. crear tabla employees
drop table if exists employees;

create table employees (
  employeenumber int primary key,
  lastname varchar(50) not null,
  firstname varchar(50) not null,
  extension varchar(10),
  email varchar(100) not null,
  officecode varchar(10) not null,
  jobtitle varchar(50) not null
);

-- intento de insert con null en email (fallará por restricción not null)
insert into employees (employeenumber, lastname, firstname, extension, email, officecode, jobtitle)
values (1001, 'smith', 'john', 'x123', null, '1', 'sales rep');
-- resultado esperado: error 1048 (23000): column 'email' cannot be null


-- 2. updates sobre pk employeenumber
-- esto restará 20 a todos los employeenumber
update employees set employeenumber = employeenumber - 20;

-- esto volverá a sumar 20 a todos los employeenumber
update employees set employeenumber = employeenumber + 20;


-- 3. agregar columna age con restricción
alter table employees 
add age int check (age between 16 and 70);

-- ejemplo que falla (edad fuera de rango)
insert into employees (employeenumber, lastname, firstname, extension, email, officecode, jobtitle, age)
values (1002, 'lopez', 'ana', 'x456', 'ana@example.com', '2', 'manager', 15);
-- resultado esperado: error 3819 (hy000): check constraint violated


-- 4. integridad referencial en sakila
-- relación film - actor - film_actor (muchos a muchos)
-- film_actor tiene claves foráneas hacia film y actor

/*
create table film_actor (
  actor_id smallint not null,
  film_id smallint not null,
  last_update timestamp not null,
  primary key (actor_id, film_id),
  constraint fk_film_actor_actor foreign key (actor_id) references actor(actor_id) 
    on delete restrict on update cascade,
  constraint fk_film_actor_film foreign key (film_id) references film(film_id) 
    on delete restrict on update cascade
);
*/


-- 5. columna lastupdate y triggers
alter table employees 
  add lastupdate timestamp default current_timestamp on update current_timestamp,
  add lastupdateuser varchar(50);

delimiter $$

create trigger trg_employees_insert
before insert on employees
for each row
begin
  set new.lastupdate = now();
  set new.lastupdateuser = user();
end$$

create trigger trg_employees_update
before update on employees
for each row
begin
  set new.lastupdate = now();
  set new.lastupdateuser = user();
end$$

delimiter ;


-- 6. triggers de sakila relacionados con film_text
-- existen tres triggers: ins_film, upd_film, del_film
-- aseguran que film_text siempre esté sincronizado con film

/*
create trigger ins_film after insert on film
for each row
begin
  insert into film_text (film_id, title, description)
  values (new.film_id, new.title, new.description);
end;

create trigger upd_film after update on film
for each row
begin
  update film_text
  set title = new.title,
      description = new.description
  where film_id = new.film_id;
end;

create trigger del_film after delete on film
for each row
begin
  delete from film_text where film_id = old.film_id;
end;
*/
