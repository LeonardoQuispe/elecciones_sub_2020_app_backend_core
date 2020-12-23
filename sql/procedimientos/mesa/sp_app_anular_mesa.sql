drop function if exists sp_app_anular_mesa;
CREATE OR REPLACE FUNCTION sp_app_anular_mesa(    
	_id_mesa bigint
	,_observacion character varying
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
   
    --ACTUALIZA DATOS
    UPDATE mesa SET 
		id_estado_mesa = 3
		,observacion = _observacion
		,fecha_modificacion = current_timestamp
	where id = _id_mesa;
    ------Valida si se afectaron filas----------------
    GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
    if filasAfectadas = 0 then
       return QUERY select 'error', 'La Mesa no se pudo Anular', _id_mesa::text;	
    else
    	return QUERY select 'success', 'OK', _id_mesa::text;
    end if;

END;
$function$;

/*

*/
