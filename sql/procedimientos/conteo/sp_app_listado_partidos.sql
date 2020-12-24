drop function if exists sp_app_listado_partidos;
CREATE OR REPLACE FUNCTION sp_app_listado_partidos()
 RETURNS TABLE(
 	id bigint
 	,nombre varchar
 	,color varchar
 	,logo varchar
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		p.id
		,p.app_nombre as nombre
		,p.color
		,p.app_logo as logo
	from partido p
	where p.estado not in ('BA')
	order by p.id asc;
end;
$function$
;
/*
select * from partido order by id
select * from sp_app_listado_partidos();
*/
