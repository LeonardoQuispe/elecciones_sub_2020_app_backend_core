drop function if exists sp_app_abm_mesa;
CREATE OR REPLACE FUNCTION sp_app_abm_mesa(
	_id_mesa bigint
	,_observacion_conteo character varying
	,_id_estado_mesa bigint
	,_bandera_validado_jefe_recinto bool
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
   	aux_nro_conteo int;
   	aux_nro_conteo_por_rol int;
begin
    update mesa set 
    	observacion_conteo = _observacion_conteo
    	,id_estado_mesa = _id_estado_mesa
    	,bandera_validado_jefe_recinto = _bandera_validado_jefe_recinto
    	,fecha_modificacion = current_timestamp
    where id = _id_mesa;		       
    ------Valida si se afectaron filas----------------
    GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
    if filasAfectadas = 0 then
        return QUERY select 'error', 'El Registro no se pudo Guardar', v_id::text;
    else 
   		return QUERY select 'success', 'OK', _id_mesa::text;
    end if;
END;
$function$
;
