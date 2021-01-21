drop function if exists sp_app_listado_partidos;
CREATE OR REPLACE FUNCTION sp_app_listado_partidos(
	_id_mesa bigint
	,_id_tipo_conteo bigint
	,_id_municipio bigint
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
begin
	
	
    RETURN QUERY select 
		p.id
		,p.app_nombre as nombre
		,p.color
		,p.app_logo as logo
	from det_municipio_partido dmp 
	inner join partido p on p.id = dmp.id_partido and p.estado = 'AC'
	where dmp.estado = 'AC' and dmp.id_municipio = _id_municipio
	order by dmp.id asc;
end;
$function$
;
/*
select *from recinto
select * from partido order by id
select * from sp_app_listado_partidos(25452,1);
*/
