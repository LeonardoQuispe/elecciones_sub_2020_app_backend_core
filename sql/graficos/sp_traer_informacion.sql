
drop function if exists sp_traer_informacion;
CREATE OR REPLACE FUNCTION sp_traer_informacion(
)
 RETURNS TABLE(
	 habilitados bigint
	,procesados bigint
	,mesa_total bigint
	,mesa_escrutadas bigint
	,mesa_porcentaje numeric
	,participacion numeric
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	--id_circunscripcion bigint;
begin

return query  

select 
i.habilitados
,i.procesados
,i.mesa_total
,i.mesa_escrutadas
,round(((i.mesa_escrutadas::decimal / i.mesa_total::decimal)*100)) as mesa_porcentaje
--,(( i.procesados/i.habilitados) * 100)as  participacion
,round((( i.procesados::decimal /i.habilitados::decimal ) * 100),3)as  participacion
from sp_traer_informacion_previo() as i
;


	
end
$function$
;

--  select * from sp_traer_informacion ()




