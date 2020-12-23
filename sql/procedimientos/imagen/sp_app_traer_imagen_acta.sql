drop function if exists sp_app_traer_imagen_acta;
CREATE OR REPLACE FUNCTION sp_app_traer_imagen_acta(
	_id_imagen_acta bigint
)
 RETURNS TABLE(
 	nombre  character varying,
 	content_type character varying,
 	archivo bytea
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		i.nombre
		,i.content_type
		,i.archivo
	from imagen_acta i
	where id = _id_imagen_acta
	and estado in ('AC');
end;
$function$
;
/*
select * from sp_app_traer_imagen_acta(399)
*/
