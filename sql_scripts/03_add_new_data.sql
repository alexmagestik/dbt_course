drop table if exists new_fligth_tickets;
drop table if exists new_tickets;

-- Добавление строк в таблицу с перелетами bookings.flights
insert into bookings.flights
(
	flight_id,
	flight_no,
	scheduled_departure,
	scheduled_arrival,
	departure_airport,
	arrival_airport,
	status,
	aircraft_code,
	actual_departure,
	actual_arrival
)
with numbered_fligths as (
	select
		max(flight_id) over() + dense_rank() over(order by flight_no) as flight_id,
		flight_no,
		scheduled_departure,
		scheduled_arrival,
		departure_airport,
		arrival_airport,
		status,
		aircraft_code,
		actual_departure,
		actual_arrival,
		row_number() over(partition by flight_no order by scheduled_departure desc) as rn
	from
		bookings.flights
)
select
	flight_id,
	flight_no,
	scheduled_departure + interval '1' day as scheduled_departure,
	scheduled_arrival + interval '1' day as scheduled_arrival,
	departure_airport,
	arrival_airport,
	'Arrived' as status,
	aircraft_code,
	scheduled_departure + make_interval(0,0,0,0,0,random(0, 20)) as actual_departure,
	scheduled_arrival + make_interval(0,0,0,0,0,random(0, 20)) as actual_arrival
from 
	numbered_fligths
where rn = 1;



create temporary table new_fligth_tickets as 
with numbered_fligths as (
	select
		flight_id,
		flight_no,
		aircraft_code,
		actual_departure,
		actual_arrival,
		row_number() over(partition by flight_no order by scheduled_departure desc) as rn
	from
		bookings.flights
),
fligths_wo_tickets as (
	select
		f.flight_id,
		f.flight_no,
		f.aircraft_code
	from 
		numbered_fligths f
		left join ticket_flights tf
			on f.flight_id = tf.flight_id 
	where rn = 1
	group by
		f.flight_id,
		f.flight_no,
		f.aircraft_code
	having 
		count(tf.flight_id) = 0
),
max_ticket_no as (
	select 
		max(tf.ticket_no)::bigint as max_ticket_no
	from 
		ticket_flights tf 
)
select 
	to_char(m.max_ticket_no + row_number() over(), '000000000000')::bpchar(13) as ticket_no,
	f.flight_id,
	s.fare_conditions,
	case 	
		when s.fare_conditions = 'Business' then random(9, 110) * 1000
		when s.fare_conditions = 'Comfort' then random(20, 50) * 1000
		when s.fare_conditions = 'Economy' then random(3, 33) * 1000
	end as amount
from 
	fligths_wo_tickets f
	inner join seats s 
		on f.aircraft_code = s.aircraft_code
	cross join max_ticket_no m
where random(0, 10) > 3;



ALTER TABLE bookings.bookings ALTER column book_ref type varchar(8);
ALTER TABLE bookings.tickets ALTER column book_ref type varchar(8);



create temporary table new_tickets as 
with passengers_dist as (
	select distinct
		t.passenger_id,
		t.passenger_name,
		t.contact_data
	from 
		tickets t
),
passengers_rn as (
	select
		t.passenger_id,
		t.passenger_name,
		t.contact_data,
		row_number() over(order by t.passenger_id) as rn
	from 
		passengers_dist t
),
max_booking_ref as (
	select
		max(('0x' || b.book_ref)::bigint) as max_book_ref_big_int
	from 
		bookings.bookings b 
),
rn_passanger as (
	select random(1, 829071) as rn_passanger
),
rn_bookings as (
	select 
		ft.ticket_no,
		p.passenger_id,
		p.passenger_name,
		p.contact_data, 
		br.max_book_ref_big_int,
		row_number() over() as rn
	from 
		new_fligth_tickets ft,
		passengers_rn p,
		max_booking_ref br,
		rn_passanger 
	where p.rn = rn_passanger.rn_passanger
)
select 
	ticket_no,
	cast(to_hex(max_book_ref_big_int + rn) as text) as book_ref,
	passenger_id,
	passenger_name,
	contact_data 
from
	rn_bookings r;

insert into bookings.bookings
(
	book_ref,
	book_date,
	total_amount
)
select 
	book_ref,
	f.scheduled_departure - make_interval(0,0,0,0,0,random(0, 60)) as book_date,
	ft.amount
from 
	new_tickets t
	inner join new_fligth_tickets ft
		on t.ticket_no = ft.ticket_no
	inner join flights f
		on f.flight_id = ft.flight_id;


insert into bookings.tickets
(
	ticket_no,
	book_ref,
	passenger_id,
	passenger_name,
	contact_data
)
select
	ticket_no,
	book_ref,
	passenger_id,
	passenger_name,
	contact_data
from
	new_tickets;

INSERT INTO bookings.ticket_flights
(
	ticket_no, 
	flight_id, 
	fare_conditions, 
	amount
)
select
	ticket_no, 
	flight_id, 
	fare_conditions, 
	amount
from 
	new_fligth_tickets;

drop table if exists new_fligth_tickets;
drop table if exists new_tickets;