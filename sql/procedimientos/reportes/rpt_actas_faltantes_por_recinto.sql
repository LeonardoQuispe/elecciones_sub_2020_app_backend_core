drop function if exists rpt_actas_faltantes_por_recinto;
CREATE OR REPLACE FUNCTION rpt_actas_faltantes_por_recinto(    
	_id_circunscripcion bigint
)
RETURNS TABLE( 
 	nombre_recinto character varying, 
 	total_mesas bigint,
 	total_mesas_faltantes bigint,
 	mesas_faltantes character varying, 
 	jefe_recinto character varying,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql := 'with aux_faltantes as 
			(
				select 
					 r.id as id_recinto,
					 r.nombre as nombre_recinto,
					 count(m.numero_mesa) as total_mesas_faltantes,
					 string_agg(m.numero_mesa::varchar, '', '')::varchar as mesas_faltantes
				from mesa m
				inner join recinto r on r.id = m.id_recinto
				where r.id_circunscripcion = '||_id_circunscripcion|| 
						'and (m.bandera_acta_recepcionada is null or m.bandera_acta_recepcionada = false)
				group by r.id,r.nombre
				order by r.nombre asc
			)';

	sql := sql||'select 
				a1.nombre_recinto,
				(
					select 
						count(*) total_mesas
					from mesa m
					where id_recinto = a1.id_recinto
				) as total_mesas,
				a1.total_mesas_faltantes,
				a1.mesas_faltantes,
				(
					select string_agg(
							(coalesce(u.nombre,''---'')||'' ''||
							coalesce(u.apellido_paterno,''---'')||'' ''||
							coalesce(u.apellido_materno,''---'')||'' (Telf: ''||coalesce(u.telefono1,''---'')||'', ''||coalesce(u.telefono2,''---'')||'')''), ''; '')::varchar as usuarios
					from det_usuario_recinto dur
					inner join adm_usuario u on u.id = dur.id_usuario
					where dur.id_recinto = a1.id_recinto
				) as jefe_recinto,
				to_char(current_timestamp, ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
			from aux_faltantes a1';


	
		 

	raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*

select distinct m.id, m.numero_mesa, r.nombre,m.bandera_acta_recepcionada  
from mesa m inner join recinto r on r.id = m.id_recinto 
where r.id_circunscripcion = 44 and (bandera_acta_recepcionada is null OR bandera_acta_recepcionada = false) 
order by r.nombre;
select * from rpt_actas_faltantes_por_recinto(44)
*/


/*

				(
					select coalesce(u.nombre,''---'')||'' ''||
							coalesce(u.apellido_paterno,''---'')||'' ''||
							coalesce(u.apellido_materno,''---'')||'' (Telf: ''||coalesce(u.telefono1,''---'')||'', ''||coalesce(u.telefono2,''---'')||'')''
					from adm_usuario u
					inner join circunscripcion c on c.id_usuario = u.id
					where c.id = '||_id_circunscripcion||
				') as jefe_circunscripcion,
*/
