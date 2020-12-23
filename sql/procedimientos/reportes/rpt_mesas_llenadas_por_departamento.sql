drop function if exists rpt_mesas_llenadas_por_departamento;
CREATE OR REPLACE FUNCTION rpt_mesas_llenadas_por_departamento(    
	_id_departamento bigint
)
RETURNS TABLE(
 	departamento character varying, 
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
   	sql :=
		'with tabla_aux1 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_totales
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;
	
	sql := sql ||
		' 	group by d.nombre
			order by d.nombre
		), tabla_aux2 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_llenadas 
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1 and me.id_estado_mesa = 2';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;

	sql := sql ||
		'	group by d.nombre
			order by d.nombre
		)
		select 
			t1.departamento,
			round(((t2.mesas_llenadas*100)/t1.mesas_totales::numeric),2) as porcentaje_llenadas,
			t2.mesas_llenadas,
			t1.mesas_totales,
			to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
		from tabla_aux1 t1
		inner join tabla_aux2 t2 on t1.departamento = t2.departamento';

	--raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from rpt_mesas_llenadas_por_departamento(0);
*/
