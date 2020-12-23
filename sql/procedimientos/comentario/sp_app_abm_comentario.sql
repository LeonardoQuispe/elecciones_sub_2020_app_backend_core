drop function if exists sp_app_abm_comentario;
CREATE OR REPLACE FUNCTION sp_app_abm_comentario(
	_nombre character varying, 
	_carnet character varying, 
	_comentario character varying
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
    
	--INSERTA DATOS}
	insert into comentario(nombre,carnet,comentario) 
	values (trim(_nombre),_carnet,trim(_comentario));	
	------Valida si se afectaron filas----------------
	GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
	if filasAfectadas = 0 then
	    return QUERY select 'error', 'El Registro no se pudo Guardar', '0';
	else 
		return QUERY select 'success', 'OK', '0';
	    end if;
	   ---------------------------------------------------
        
END;
$function$
;
