set role postgres;

/*revoke all privileges on all tables in schema public from mike;
revoke all privileges on all tables in schema public from jon;

revoke connect on database dvdrental from mike;
revoke connect on database dvdrental from jon;

drop role mike;
drop role jon;
*/

create role mike with login;
create role jon with login;
create role web with login;

grant connect on database dvdrental to mike;
grant connect on database dvdrental to jon;

grant select on customer 
to mike;

grant select on customer
to jon;

grant select on customer
	to web;


alter user mike with password 'mike123';

alter user jon with password 'jon123';

alter user web with password 'web';



-- defining row level security policies:
alter table customer ENABLE ROW level SECURITY;

create policy customer_select on customer
	using (store_id = (select check_store_id(current_user)));


create policy view_all_customer to web
	using(true)
	with check(true);


-- test select:
set role mike;
select distinct store_id from customer;
select * from customer;

set role jon;
select distinct store_id from customer;
select * from customer;


