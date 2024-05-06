Create Table foods (
	  food_id bigint
	, item_name varchar(255)
	, storage_type varchar(255)
	, package_size int
	, package_size_uom varchar(255)
	, brand_name varchar(255)
	, package_price decimal(10,2)
	, price_last_update_ts timestamp without time zone 	
) 
;

Create Table drinks (
	  drink_id bigint
	, item_name varchar(255)
	, storage_type varchar(255)
	, package_size int
	, package_size_uom varchar(255)
	, brand_name varchar(255)
	, package_price decimal(10,2)
	, price_last_updated_ts timestamp without time zone
	
)
;

/*
	count the number of foods records
*/

Select
	*
from
	foods
/*
	Where brand_name is null
*/
	
Select
	  f.food_id
	, f.item_name
	, f.storage_type
	, f.package_size
	, f.package_size_uom as package_size_unit_of_measurement
	, f.brand_name
	, f.package_price
	, f.price_last_update_ts
	,
	Case 
		when item_name ilike '%canned%'
			then 'Y'
		else 'N'
	End As is_canned_YN
From
	foods as f
where
	brand_name is null


select
	distinct storage_type
From
	foods

/* 
	Updating out dataset to rename all null values as Unknown
*/
	
update foods 
	set storage_type = 'Unknown'
		Where storage_type is null

Select
	*
From
	foods
where 
	(
	food_id = 13
	or food_id = 15
	or food_id = 17
	)
	and brand_name ilike 'h-e-b (private label)'

Select
	  brand_name
	, storage_type
	, count(*) as record_count
From
	foods
Group by 
	  brand_name  
	, storage_type

/*
	Get the percentage of private label 

	stops
	1. get the total number of records that are heb private label 
	2. get the total number of records across the table
	3. take #1 divided by #2
*/

select 
	cast(n.heb_records as decimal(10,2)) / cast(d.total_records as decimal(10,2))
from
	(
		select
			count(*) as heb_records
		from
			foods as f
		where
			f.brand_name ilike 'h-e-b (private label)'
	) as n --numerator
	cross join
	(
		select
			count(*) total_records
		from
			foods as f
	) as d --denominator

--
Select
	  f.food_id
	, f.item_name
	, f.storage_type
	, f.package_size
	, f.package_size_uom as package_size_unit_of_measurement
	, f.brand_name
	, f.package_price
	, f.price_last_update_ts at time zone 'America/Los_Angeles' as price_last_updated_cst_ts
	, current_timestamp
	, (
		current_timestamp - (f.price_last_Update_ts at time zone 'America/Los_Angeles')
			) As days_since_price_last_updated
	, current_date
	, (
		current_date - cast(f.price_last_Update_ts at time zone 'America/Los_Angeles' as date)
			) As days_of_last_adjustment
	, Case 
		when current_date - cast(f.price_last_Update_ts at time zone 'America/Los_Angeles' as date) >= 500
			then 'Update Prices'
		else 'Leave as be'
	  End As Does_it_need_an_update
from
	foods as f


/*
	Output the drinks and the food items in a single result set
*/
select
	  f.food_id -- if this record is from the food table, fill out this column. if not, leave blank
	, null as drink_id -- if this record is from the drink table, fill out this column. if not, leave blank
	, f.item_name
	, f.storage_type
	, f.package_size
	, f.package_size_uom as foods_package_size_unit_of_measurement
	, f.brand_name
	, f.package_price
	, f.price_last_update_ts
	, 'foods data' as source_table
From
	foods as f
Union All
Select
	  null as food_id -- if this record is from the food table, fill out this column. if not, leave blank
	, d.drink_id -- if this record is from the drink table, fill out the column. if not, leave blank
	, d.item_name
	, d.storage_type
	, d.package_size
	, d.package_size_uom as Drinks_package_size_unit_of_measurement
	, d.brand_name
	, d.package_price
	, d.price_last_updated_ts
	, 'drinks data' as source_table
From
	drinks as d

Create Table food_inventories(
	  food_inventory_id bigint
	, food_item_id bigint
	, quantity int
	, inventory_dt date
)

/*
	1. get the max inventory date
*/

Select
	max(inventory_dt) as max_inventory_date
From
	food_inventories

/* 
	2. Get the latest inventory date
*/

Select
	  f.food_inventory_id
	, f.food_item_id
	, f.quantity
	, f.inventory_dt
From
	food_inventories as f
where
	f.inventory_dt = (
	Select
		max(inventory_dt) as max_inventory_date
	From
	food_inventories
	)

/*
	3. Get all of the food items, and join with the latest 
		inventory data
*/

Select
	  f.food_id
	, f.item_name
	, f.storage_type
	, f.package_size
	, f.package_size_uom 
	, f.brand_name
	, f.package_price
	, f.price_last_update_ts
	, i.quantity as inventory_quantity
From 
	foods as f
	left join(
	-- food inventory to date for the latest date
	Select
		  i.food_inventory_id
		, i.food_item_id
		, i.quantity
		, i.inventory_dt
	From
		food_inventories as i
	where
		i.inventory_dt = (
							-- max inventory to date
								Select
									max(inventory_dt) as max_inventory_date
								From
									food_inventories	
						) 
	) as i
		on f.food_id = i.food_item_id


	
























