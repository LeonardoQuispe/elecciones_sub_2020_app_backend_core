drop function if exists sp_app_traer_parametros;
CREATE OR REPLACE FUNCTION sp_app_traer_parametros()
 RETURNS TABLE(
 	fecha_hora_servidor timestamp
 )
 LANGUAGE plpgsql
AS $function$
begin
	return query select current_timestamp::timestamp;
end;
$function$
;
/*
select * from sp_app_traer_parametros()
*/
