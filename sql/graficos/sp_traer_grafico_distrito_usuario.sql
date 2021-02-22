drop function if exists sp_traer_grafico_distrito_usuario;
CREATE OR REPLACE FUNCTION sp_traer_grafico_distrito_usuario(
	_id_usuario bigint
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
			d.id codigo
			,p.id id_partido
			,p.sigla 
			,d.nombre
			,p.color 
			,coalesce(sum(dcp.total_voto ),0)  as total_voto
			from municipio m
			inner join distrito d on d.id_municipio  = m.id 
			inner join det_municipio_partido dmp  on dmp.id_municipio = m.id
			inner join partido p on p.id  = dmp.id_partido 
			inner join recinto r on r.id_distrito = d.id
			inner join mesa me on me.id_recinto = r.id
			left join conteo c on c.id_mesa  = me.id and c.id_tipo_conteo  = 1 and c.estado = ''AC''  and me.id_estado_mesa  = 2
			left join det_conteo_partido dcp on c.id  = dcp.id_conteo and dcp.id_partido = p.id 
			where 1 = 1
				and me.estado in (''AC'')';
	

	-- and me.id_estado_mesa = 2
	
	if _id_usuario >  0 then
		sql = sql || ' and d.id_usuario = ' || _id_usuario;
	end if;
	

	sql = sql || ' group by d.nombre, p.sigla, d.id, dmp.id, p.id, p.color ';
	sql = sql || ' order by d.id, dmp.id';
	
	
	RETURN QUERY EXECUTE sql;
	
end
$function$
;




-- select *from sp_traer_grafico_distrito_usuario(44081);


