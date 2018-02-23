set role postgres;

revoke all privileges on all tables in schema public from mike;
revoke all privileges on all tables in schema public from jon;

revoke connect on database dvdrental from mike;
revoke connect on database dvdrental from jon;

drop role mike;
drop role jon;

create role mike;
create role jon;

grant connect on database dvdrental to mike;
grant connect on database dvdrental to jon;

grant select on customer 
to mike;

grant select on customer
to jon;


alter user mike with password 'mike123';

alter user jon with password 'jon123';

-- defining row level security policies:
alter table customer ENABLE ROW level SECURITY;

alter policy customer_select on customer
	with check (store_id = (select check_store_id(current_user)));




-- test select:
set role mike;
select distinct store_id from customer;
select * from customer;

set role jon;
select distinct store_id from customer;
select * from customer;


