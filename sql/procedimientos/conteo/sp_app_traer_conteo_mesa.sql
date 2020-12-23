drop function if exists sp_app_traer_conteo_mesa;
CREATE OR REPLACE FUNCTION sp_app_traer_conteo_mesa(
	_id_mesa bigint
)
 RETURNS TABLE(
 	id bigint,
 	id_tipo_conteo bigint
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		c.id
		,c.id_tipo_conteo
	from conteo c
	where id_mesa = _id_mesa
	and c.estado not in ('BA');
end;
$function$
;
/*
select * from sp_app_traer_conteo_mesa(31642)
*/
