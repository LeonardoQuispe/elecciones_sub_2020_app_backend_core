drop function if exists sp_traer_grafico_municipios_localidad;
CREATE OR REPLACE FUNCTION sp_traer_grafico_municipios_localidad(
	_id_usuario bigint, 
	_id_municipio bigint
)
 RETURNS TABLE(	
    codigo bigint
	,id_partido bigint
	,sigla character varying	
	,nombre character varying	
	,color character varying
	,total_voto bigint	
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	aux_idrol bigint;
begin
	--Si se trata de una busqueda con un parametro y valor variable
	-- select au.id_rol into aux_idrol from adm_usuario au  where au.id  = 1;
	
	sql = 'select 
			ls.id codigo
			,p.id id_partido
			,p.sigla 
			,ls.nombre
			,p.color 
			,coalesce(sum(dcp.total_voto ),0)  as total_voto
			from municipio m
			inner join localidad_seccion ls on ls.id_municipio  = m.id 
			inner join det_municipio_partido dmp  on dmp.id_municipio = m.id
			inner join partido p on p.id  = dmp.id_partido 
			inner join recinto r on r.id_localidad_seccion = ls.id
			inner join mesa me on me.id_recinto = r.id
			left join conteo c on c.id_mesa  = me.id and c.id_tipo_conteo  = 1 and c.estado = ''AC''  and me.id_estado_mesa  = 2
			left join det_conteo_partido dcp on c.id  = dcp.id_conteo and dcp.id_partido = p.id 
			where 1 = 1
				and me.estado in (''AC'')';
	

	-- and me.id_estado_mesa = 2
	
	if _id_usuario >  0 then
		sql = sql || ' and m.id_usuario = ' || _id_usuario;
	end if;
	
	if _id_municipio >  0 then
		sql = sql || ' and m.id = ' || _id_municipio;
	end if;


	sql = sql || ' group by ls.nombre, p.sigla, ls.id, dmp.id, p.id, p.color ';
	sql = sql || ' order by ls.id, dmp.id';
	
	
	RETURN QUERY EXECUTE sql;
	
end
$function$
;




-- select *from sp_traer_grafico_municipios_localidad(263,0);
-- select * from municipio m  where id= 70102

