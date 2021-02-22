drop function if exists sp_traer_informacion_previo;
CREATE OR REPLACE FUNCTION sp_traer_informacion_previo(
)
 RETURNS TABLE(
	 habilitados bigint
	,procesados bigint
	,mesa_total bigint
	,mesa_escrutadas bigint
	,mesa_porcentaje integer
	,participacion integer
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	--id_circunscripcion bigint;
begin

return query  

select 
   (select sum(me.habilitados) from mesa me 
   inner join recinto r on me.id_recinto = r.id
   inner join municipio m on r.id_municipio = m.id 
   inner join provincia p on m.id_provincia = p.id 
   inner join departamento d on p.id_departamento  = d.id 
   where d.id = 7
   ) as habilitados
  ,(
  	select coalesce(sum(c.votos_validos + c.votos_nulos + c.votos_blancos),0) from conteo c
inner join mesa me on c.id_mesa = me.id 
inner join recinto r on me.id_recinto = r.id
inner join municipio mu on r.id_municipio = mu.id
inner join provincia p on mu.id_provincia = p.id
inner join departamento d on p.id_departamento = d.id
inner join pais pa on d.id_pais = pa.id
 where pa.id = 1 and d.id  = 7
and  me.estado in ('AC')
and me.id_estado_mesa = 2 
and (me.bandera_validado_jefe_recinto = true or me.bandera_validado_centro_computo=true)
  ) as procesados
  ,(select count(me.id) from mesa me
	inner join recinto r on me.id_recinto = r.id and r.estado  = 'AC'
	inner join municipio mu on r.id_municipio = mu.id
	inner join provincia p on mu.id_provincia = p.id
	inner join departamento d on p.id_departamento = d.id
	inner join pais pa on d.id_pais = pa.id
		where pa.id = 1 and d.id = 7 and me.estado='AC') as mesa_total
  ,(select count(me.id) from mesa me
	inner join recinto r on me.id_recinto = r.id
	inner join municipio mu on r.id_municipio = mu.id
	inner join provincia p on mu.id_provincia = p.id
	inner join departamento d on p.id_departamento = d.id
	inner join pais pa on d.id_pais = pa.id
		where pa.id = 1 and d.id = 7 and me.estado = 'AC'
    and  me.estado in ('AC')
	and me.id_estado_mesa = 2 
	and (me.bandera_validado_jefe_recinto = true or me.bandera_validado_centro_computo=true)) as mesa_escrutadas
  ,0 as mesa_porcentaje
  ,0 as participacion ;
  
 
 --select * from departamento d 
	
end
$function$
;

--  select * from sp_traer_informacion_previo ()