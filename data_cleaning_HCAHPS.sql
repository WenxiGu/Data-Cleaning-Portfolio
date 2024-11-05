--select * from "postgres"."Hospital_Data".hcahps_data
CREATE TABLE "postgres"."Hospital_Data".Tableau_File as
with hospital_beds_clean as
(
select 
    lpad(provider_ccn::text,6,'0') as provider_ccn,
	hospital_name,
	to_date(fiscal_year_begin_date, 'MM/DD/YYYY') as fiscal_year_begin_date,
	to_date(fiscal_year_end_date, 'MM/DD/YYYY') as fiscal_year_end_date,
	number_of_beds,
	row_number()over(partition by provider_ccn order by to_date(fiscal_year_end_date, 'MM/DD/YYYY')desc ) as nth_row
	
from "postgres"."Hospital_Data".hospital_beds
)
--检查是否每个医院只对应一行
-- select provider_ccn, count(*) as num_rows
--   from hospital_beds_clean
--   where nth_row =1
--   group by provider_ccn
--   order by num_rows desc
 

select 
     lpad(facility_id::text,6,'0') as provider_ccn,
     to_date(start_date, 'MM/DD/YYYY') as start_date_converted,
	 to_date(end_date, 'MM/DD/YYYY') as end_date_converted,
	 hcahps.*,
	 beds.number_of_beds,
	 beds.fiscal_year_begin_date as beds_start_report_period,
	 fiscal_year_end_date as beds_end_report_period
	 
from "postgres"."Hospital_Data".hcahps_data as hcahps
left join hospital_beds_clean as beds -- its a many to one join, rows should remain the same amount 
  on lpad(facility_id::text,6,'0') = beds.provider_ccn
  and beds.nth_row = 1

