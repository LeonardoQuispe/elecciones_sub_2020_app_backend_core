drop function if exists rpt_mesas_aperturadas_por_circunscripcion_prueba;
CREATE OR REPLACE FUNCTION rpt_mesas_aperturadas_por_circunscripcion_prueba(    
	_id_departamento bigint,
	_id_circunscripcion bigint,
	_id_municipio bigint
)
RETURNS TABLE(
 	circunscripcion character varying, 
 	nombre_recinto character varying, 
 	total_mesa integer, 
 	mesas_sin_aperturar bigint, 
 	mesas_aperturadas bigint,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql := 'select 
		 r.id_circunscripcion::varchar as circunscripcion,
		 r.nombre as nombre_recinto,
		 r.total_mesa,
		 (select count(*) from mesa me where me.id_recinto = r.id and (me.bandera_apertura is null or me.bandera_apertura = false)) as mesas_sin_aperturar,
		 (select count(*) from mesa m where m.id_recinto = r.id and m.bandera_apertura = true) as mesas_aperturadas,
		 to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
	from recinto r
	inner join municipio m on m.id = r.id_municipio
	inner join provincia p on p.id = m.id_provincia
	where 1=1';
	
	if _id_departamento >  0 then
		sql = sql || ' and p.id_departamento = ' || _id_departamento;
	end if;	
	if _id_circunscripcion >  0 then
		sql = sql || ' and r.id_circunscripcion = ' || _id_circunscripcion;
	end if;	
	if _id_municipio >  0 then
		sql = sql || ' and r.id_municipio = ' || _id_municipio;
	end if;	

	sql := sql || 'order by nombre_recinto';

	raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from recinto where id = 4146
select * from mesa where id_recinto = 4146
select * from recinto where id_circunscripcion = 57
select * from rpt_mesas_aperturadas_por_circunscripcion(57);
select * from rpt_mesas_aperturadas_por_circunscripcion_prueba(7::bigint,57::bigint,0);
*/
