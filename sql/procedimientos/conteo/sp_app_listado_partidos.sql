drop function if exists sp_app_listado_partidos;
CREATE OR REPLACE FUNCTION sp_app_listado_partidos(
	id_mesa bigint
	,id_tipo_conteo bigint
)
 RETURNS TABLE(
 	id bigint
 	,nombre varchar
 	,color varchar
 	,logo varchar
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	aux_id_municipio bigint;
begin	
	select 
		r.id_municipio into aux_id_municipio
	from mesa m
	inner join recinto r on r.id = m.id_recinto and r.estado = 'AC'
	where m.estado = 'AC';
	
    RETURN QUERY select 
		p.id
		,p.app_nombre as nombre
		,p.color
		,p.app_logo as logo
	from det_conteo_partido dcp
	inner join partido p on p.id = dcp.id_partido and p.estado = 'AC'
	where dcp.estado = 'AC'
	order by p.id asc;
end;
$function$
;
/*
select *from recinto
select * from partido order by id
select * from sp_app_listado_partidos();
*/
