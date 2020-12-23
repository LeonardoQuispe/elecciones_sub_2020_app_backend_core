drop function if exists rpt_mesas_reportadas_por_circunscripcion;
CREATE OR REPLACE FUNCTION rpt_mesas_reportadas_por_circunscripcion(    
	_id_departamento bigint,
	_id_circunscripcion bigint
)
RETURNS TABLE(
 	departamento character varying, 
 	circunscripcion bigint, 
 	nombre_recinto character varying, 
 	numero_mesa int, 
 	observacion character varying, 
 	fecha_hora_actual text,
 	total_observados bigint
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql := 'with tabla_aux as (select 
		 d.nombre as departamento,
		 r.id_circunscripcion as circunscripcion,
		 r.nombre as nombre_recinto,
		 me.numero_mesa,
		 coalesce(me.observacion, ''SIN OBSERVACIÓN'') as observacion,
		 to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
	from mesa me
	inner join recinto r on r.id = me.id_recinto
	inner join municipio m on m.id = r.id_municipio
	inner join provincia p on p.id = m.id_provincia
	inner join departamento d on d.id = p.id_departamento
	where d.id_pais = 1';
	
	if _id_departamento >  0 then
		sql = sql || ' and p.id_departamento = ' || _id_departamento;
	end if;	
	if _id_circunscripcion >  0 then
		sql = sql || ' and r.id_circunscripcion = ' || _id_circunscripcion;
	end if;

	sql := sql || 'order by d.nombre,r.id_circunscripcion,r.nombre,me.numero_mesa
		) 
		select
			*,
			(select count(*) from tabla_aux where observacion != ''SIN OBSERVACIÓN'') as total_observados
		from tabla_aux';

	raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from recinto where id = 4146
select * from mesa where id_recinto = 4146
select * from recinto where id_circunscripcion = 57
select * from rpt_mesas_reportadas_por_circunscripcion(7::bigint,0::bigint);
*/
