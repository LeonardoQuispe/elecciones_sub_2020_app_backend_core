drop function if exists rpt_mesas_llenadas_por_recinto;
CREATE OR REPLACE FUNCTION rpt_mesas_llenadas_por_recinto(    
	_id_circunscripcion bigint
)
RETURNS TABLE(
 	id_circunscripcion bigint, 
 	recinto character varying, 
 	numero_mesa int,
 	bandera_llenada bool,
 	bandera_acta bool,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	return query select 
			r.id_circunscripcion,
			r.nombre as recinto,
			me.numero_mesa,
			(case when me.id_estado_mesa = 2 then true else false end) as bandera_llenada,
			coalesce(me.bandera_acta_recepcionada, false) as bandera_acta,
			to_char((current_timestamp - '4 hour'::interval), 'DD/MM/YYYY HH12:MI PM') as fecha_hora_actual
		from mesa me
		inner join recinto r on r.id = me.id_recinto
		inner join municipio m on m.id = r.id_municipio
		inner join provincia p on p.id = m.id_provincia
		inner join departamento d on d.id = p.id_departamento
		where r.id_circunscripcion = _id_circunscripcion
		group by r.id_circunscripcion,r.nombre,me.numero_mesa,me.bandera_acta_recepcionada,bandera_llenada,me.id_estado_mesa
		order by r.nombre,me.numero_mesa;
END;
$function$;

/*
select * from recinto where nombre like '%ARREDONDO%'
select * from rpt_mesas_llenadas_por_recinto(44);
*/
