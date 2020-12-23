drop function if exists rpt_mesas_llenadas_por_circunscripcion;
CREATE OR REPLACE FUNCTION rpt_mesas_llenadas_por_circunscripcion(    
	_id_circunscripcion bigint
)
RETURNS TABLE(
 	id_circunscripcion bigint, 
 	recinto character varying, 
 	porcentaje_llenadas numeric,
 	mesas_llenadas bigint, 
 	mesas_totales bigint,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	return query with tabla_aux1 as 
	(
		select 
			r.id_circunscripcion,
			r.nombre as recinto,
			count(me.id) as mesas_totales
		from mesa me
		inner join recinto r on r.id = me.id_recinto
		inner join municipio m on m.id = r.id_municipio
		inner join provincia p on p.id = m.id_provincia
		inner join departamento d on d.id = p.id_departamento
		where r.id_circunscripcion = _id_circunscripcion
		group by r.id_circunscripcion,r.nombre
		order by r.nombre
	), tabla_aux2 as 
	(
		select 
			r.id_circunscripcion,
			r.nombre as recinto,
			count(me.id) as mesas_llenadas 
		from mesa me
		inner join recinto r on r.id = me.id_recinto
		inner join municipio m on m.id = r.id_municipio
		inner join provincia p on p.id = m.id_provincia
		inner join departamento d on d.id = p.id_departamento
		where r.id_circunscripcion = _id_circunscripcion and me.id_estado_mesa = 2
		group by r.id_circunscripcion,r.nombre
		order by r.nombre
	)
	select 
		t1.id_circunscripcion,
		t1.recinto,
		round(((t2.mesas_llenadas*100)/t1.mesas_totales::numeric),2) as porcentaje_llenadas,
		t2.mesas_llenadas,
		t1.mesas_totales,
		to_char((current_timestamp - '4 hour'::interval), 'DD/MM/YYYY HH12:MI PM') as fecha_hora_actual
	from tabla_aux1 t1
	inner join tabla_aux2 t2 on t1.recinto = t2.recinto;
END;
$function$;

/*
select * from rpt_mesas_llenadas_por_circunscripcion(44);
*/
