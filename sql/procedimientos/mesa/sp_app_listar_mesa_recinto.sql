drop function if exists sp_app_listar_mesa_recinto;
CREATE OR REPLACE FUNCTION sp_app_listar_mesa_recinto(
	_id_usuario bigint
)
 RETURNS TABLE(
 	id bigint, 
 	numero_mesa integer, 
 	bandera_usuario_asignado boolean, 
 	bandera_apertura boolean, 
 	fecha_hora_apertura character varying, 
 	bandera_validado_jefe_recinto boolean, 
 	id_estado_mesa bigint
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	sql := 'select
				m.id
				, m.numero_mesa
				, coalesce(m.bandera_usuario_asignado, false)
				, coalesce(m.bandera_apertura, false)
				, to_char(m.fecha_hora_apertura,''HH12:MI AM'')::varchar as fecha_hora_apertura
				, coalesce(m.bandera_validado_jefe_recinto, false)
				, m.id_estado_mesa
			from mesa m
			inner join det_usuario_recinto d on d.id_recinto = m.id_recinto
			where m.estado = ''AC''
			and d.id_usuario = '||_id_usuario||' order by m.numero_mesa';

	--raise notice 'Value: %', sql;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select current_timestamp
select * from sp_app_listar_mesa_recinto(5936)
update mesa set fecha_hora_apertura = null, bandera_apertura = null where id = 31638
**/
