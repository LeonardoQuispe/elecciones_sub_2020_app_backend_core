drop function if exists sp_app_traer_recinto;
CREATE OR REPLACE FUNCTION sp_app_traer_recinto(
	_id_usuario bigint
)
 RETURNS TABLE(
 	nombre_recinto character varying
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	sql := 'select
				r.nombre as nombre_recinto
			from det_usuario_recinto d
			inner join recinto r on r.id = d.id_recinto
			where r.estado in (''AC'', ''FC'')
			and d.id_usuario = '||_id_usuario||' limit 1';

	--raise notice 'Value: %', <;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select * from sp_app_traer_recinto(30415)
*/
