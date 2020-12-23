drop function if exists rpt_mesas_aperturadas_por_recinto;
CREATE OR REPLACE FUNCTION rpt_mesas_aperturadas_por_recinto(    
	_id_recinto bigint
)
RETURNS TABLE(
 	nombre_recinto character varying, 
 	usuarios character varying, 
 	numero_mesa int, 
 	fecha_hora_apertura text,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
begin
   	return QUERY 
	select 
		 r.nombre as nombre_recinto,
		 string_agg((coalesce(u.nombre,'---')||' '||coalesce(u.apellido_paterno,'---')||' '||coalesce(u.apellido_materno,'---'))::varchar, ', ')::varchar as usuarios,
		 m.numero_mesa,
		 coalesce(to_char(m.fecha_hora_apertura, 'DD/MM/YYYY HH12:MI PM'),'SIN APERTURAR') as fecha_hora_apertura,
		 to_char(current_timestamp, 'DD/MM/YYYY HH12:MI PM') as fecha_hora_actual
	from mesa m
	inner join recinto r on r.id = m.id_recinto
	inner join det_usuario_recinto dur on dur.id_recinto = r.id
	inner join adm_usuario u on u.id = dur.id_usuario
	where r.id = _id_recinto
	group by r.nombre,m.numero_mesa,m.fecha_hora_apertura
	order by m.numero_mesa asc;
END;
$function$;

/*
select * from rpt_mesas_aperturadas_por_recinto(84)
*/
