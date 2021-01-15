drop function if exists sp_app_traer_parametros;
CREATE OR REPLACE FUNCTION sp_app_traer_parametros()
 RETURNS TABLE(
 	fecha_hora_servidor text
 )
 LANGUAGE plpgsql
AS $function$
begin
	SET TIMEZONE='America/La_Paz';
--	SET timezone=-4;

	return query select to_char(current_timestamp , 'yyyy-MM-dd HH24:MI');
end;
$function$
;
/*
select * from sp_app_traer_parametros()
*/
