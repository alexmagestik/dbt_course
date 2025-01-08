-- выполняется в БД, к которой подключается dbt (dbt_course или dbt_fligth)

DROP FOREIGN TABLE demo_src.bookings;

CREATE FOREIGN TABLE demo_src.bookings (
	book_ref varchar(8) OPTIONS(column_name 'book_ref') NOT NULL,
	book_date timestamptz OPTIONS(column_name 'book_date') NOT NULL,
	total_amount numeric(10, 2) OPTIONS(column_name 'total_amount') NOT NULL
)
SERVER demo_pg
OPTIONS (schema_name 'bookings', table_name 'bookings');