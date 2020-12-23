drop function if exists sp_app_limpiar_mesa;
CREATE OR REPLACE FUNCTION sp_app_limpiar_mesa(
	_id_mesa bigint
)
 RETURNS TABLE(
 	status text, 
 	response text, 
 	numsec text
)
 LANGUAGE plpgsql
AS $function$
declare
    filasAfectadas bigint;
    v_id bigint;
begin
	
	with cte_conteo as (
	    select id
	    from conteo c
	    where id_mesa = _id_mesa
	)	
	update det_conteo_partido
	set 
		estado = 'BA'
		,fecha_modificacion = current_timestamp
	-- delete from det_conteo_partido
	where id_conteo in (select id from cte_conteo);


	update conteo 	
	set 
		estado = 'BA'
		,fecha_modificacion = current_timestamp
	-- delete from conteo
	where id_mesa = _id_mesa;

	update imagen_acta
	set 
		estado = 'BA'
		,fecha_modificacion = current_timestamp
	-- delete from det_conteo_partido
	where id_mesa = _id_mesa;


	-- 1. Actualiza el Estado de la mesa
    UPDATE mesa SET 
		id_estado_mesa = 1
		,bandera_validado_jefe_recinto = false
		,observacion = null
		,observacion_conteo = null
		,fecha_modificacion = current_timestamp
	where id = _id_mesa;
	
    ------Valida si se afectaron filas----------------
    GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
    if filasAfectadas = 0 then
       return QUERY select 'error', 'La Mesa no se pudo Limpiar', _id_mesa::text;	
    else
    	return QUERY select 'success', 'OK', _id_mesa::text;
    end if;

END;
$function$
;
