use sakila;

-- 1) función que devuelve la cantidad de copias de una película en una tienda

delimiter $$

create function contar_copias_pelicula(
    p_film_id int,
    p_store_id int
)
returns int
deterministic
reads sql data
begin
    declare total_copias int default 0;

    select count(*)
    into total_copias
    from inventory inv
    where inv.store_id = p_store_id
      and inv.film_id = p_film_id;

    return total_copias;
end$$

delimiter ;

-- ejemplo de uso:
select contar_copias_pelicula(2, 1) as 'cantidad de copias';



-- 2) procedimiento con cursor para listar clientes por país

delimiter $$

create procedure listar_clientes_por_pais(
    in p_country varchar(50),
    out p_lista text
)
begin
    declare v_done int default 0;
    declare v_nombre_completo varchar(150);
    declare cur_clientes cursor for
        select concat(c.first_name, ' ', c.last_name)
        from customer c
        join address a on c.address_id = a.address_id
        join city ci on a.city_id = ci.city_id
        join country co on ci.country_id = co.country_id
        where co.country = p_country;
    
    declare continue handler for not found set v_done = 1;

    set p_lista = '';

    open cur_clientes;

    leer_clientes: loop
        fetch cur_clientes into v_nombre_completo;
        if v_done then
            leave leer_clientes;
        end if;
        set p_lista = concat(p_lista, v_nombre_completo, '; ');
    end loop;

    close cur_clientes;
end$$

delimiter ;

-- ejemplo de uso:
call listar_clientes_por_pais('Canada', @resultado);
select @resultado as 'clientes en el país';



-- 3a) explicación: función inventory_in_stock

/*
la función inventory_in_stock(p_inventory_id) sirve para saber si una copia de película está disponible.
1. cuenta cuántas veces se alquiló ese inventory_id.
2. si nunca fue alquilado devuelve true (disponible).
3. si fue alquilado, revisa si no se devolvió aún (return_date is null).
4. si no se devolvió devuelve false (no disponible), si se devolvió devuelve true.
*/

show create function inventory_in_stock;

-- ejemplo de uso:
select inventory_id, inventory_in_stock(inventory_id) as disponible
from inventory
where store_id = 1
limit 10;



-- 3b) explicación: procedimiento film_in_stock

/*
el procedimiento film_in_stock(p_film_id, p_store_id, out p_film_count)
devuelve cuántas copias de una película están disponibles en una tienda específica.

1. filtra la tabla inventory por film_id y store_id.
2. usa inventory_in_stock() para ver si cada copia está disponible.
3. devuelve la cantidad total disponible en p_film_count.
*/

show create procedure film_in_stock;

-- ejemplo de uso:
call film_in_stock(5, 2, @cantidad);
select @cantidad as 'copias disponibles';
