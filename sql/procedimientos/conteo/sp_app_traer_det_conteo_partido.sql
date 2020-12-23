drop function if exists sp_app_traer_det_conteo_partido;
CREATE OR REPLACE FUNCTION sp_app_traer_det_conteo_partido(
	_id_conteo bigint
)
 RETURNS TABLE(
 	id_det_conteo_partido bigint,
 	id_partido bigint,
 	total_voto int
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		d.id as id_det_conteo_partido
		,d.id_partido
		,d.total_voto
	from det_conteo_partido d
	inner join partido p on p.id = d.id_partido
	where id_conteo = _id_conteo
	and d.estado in ('AC') and p.estado in ('AC')
	order by id_partido;
end;
$function$;
/*
select * from sp_app_traer_det_conteo_partido(17)
*/
