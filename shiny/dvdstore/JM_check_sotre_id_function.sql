create or replace function check_store_id(name)
returns smallint
as $$
declare res smallint;
BEGIN
	select case
    	when $1 = 'mike' then 1
        when $1 = 'jon' then 2
        else 0
    end into res;
    
    return res;
END;
$$ language 'plpgsql';


set role postgres;
select check_store_id(current_user);
select check_store_id('web'::name);



set role jon;
select check_store_id(current_user);


-- test na select

