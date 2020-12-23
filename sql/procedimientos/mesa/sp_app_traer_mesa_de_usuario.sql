drop function if exists sp_app_traer_mesa_de_usuario;
CREATE OR REPLACE FUNCTION sp_app_traer_mesa_de_usuario(
	_id_usuario bigint,
	_id_mesa bigint
)
 RETURNS TABLE(
 	id bigint, 
 	numero_mesa integer, 
 	bandera_usuario_asignado boolean, 
 	bandera_apertura boolean, 
 	fecha_hora_apertura character varying, 
 	bandera_validado_jefe_recinto boolean, 
 	id_estado_mesa bigint,
 	telefono_centro_computo character varying,
 	id_recinto character varying,
 	nombre_recinto character varying,
 	observacion_conteo character varying,
 	id_imagen_acta bigint,
 	nombre_imagen_acta character varying,
 	imagen_acta_content_type character varying,
 	habilitados int
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	aux_telefono_centro_computo varchar;
begin
	aux_telefono_centro_computo := coalesce((select p.telefono_centro_computo from parametros p),'0')::varchar;
	
		sql := 'select
					m.id
					, m.numero_mesa
					, coalesce(m.bandera_usuario_asignado, false)
					, coalesce(m.bandera_apertura, false)
					, to_char(m.fecha_hora_apertura,''HH12:MI AM'')::varchar as fecha_hora_apertura
					, coalesce(m.bandera_validado_jefe_recinto, false)
					, m.id_estado_mesa
					, '''||aux_telefono_centro_computo||'''::varchar as telefono_centro_computo
					, r.codigo_oep as id_recinto
					, r.nombre as nombre_recinto	
					, m.observacion_conteo		
					, i.id as id_imagen_acta	
					, i.nombre as nombre_imagen_acta	
					, i.content_type as imagen_acta_content_type
					, coalesce(m.habilitados,0)
				from mesa m
				inner join recinto r on r.id = m.id_recinto
				left join imagen_acta i on m.id = i.id_mesa and i.estado = ''AC''
				where m.estado = ''AC''';			
		if(_id_mesa <> 0) then
			sql := sql || 'and m.id = '||_id_mesa;
		else 
			sql := sql || 'and m.id_usuario = '||_id_usuario;
		end if;
		sql = sql || ' limit 1';
	
	raise notice 'Value: %', sql;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select * from sp_app_traer_mesa_de_usuario(5936, 31627)
select * from sp_app_traer_mesa_de_usuario(37982, 0)

*/
