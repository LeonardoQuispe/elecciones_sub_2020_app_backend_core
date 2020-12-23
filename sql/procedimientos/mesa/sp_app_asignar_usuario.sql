drop function if exists sp_app_asignar_usuario;
CREATE OR REPLACE function sp_app_asignar_usuario(
	_id bigint, 
	_nombre character varying DEFAULT NULL::character varying, 
	_apellido_paterno character varying DEFAULT NULL::character varying,
	_apellido_materno character varying DEFAULT NULL::character varying, 
	_carnet_identidad character varying DEFAULT NULL::character varying, 
	_telefono1 character varying DEFAULT NULL::character varying,
	_telefono2 character varying DEFAULT NULL::character varying, 
	_correo character varying DEFAULT NULL::character varying
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
            
    --ACTUALIZA DATOS USUARIO
    UPDATE adm_usuario SET 
		nombre = trim(_nombre)					
		,apellido_paterno = trim(_apellido_paterno)
		,apellido_materno = trim(_apellido_materno)
		,carnet_identidad = trim(_carnet_identidad)
		,telefono1 = trim(_telefono1)
		,telefono2 = trim(_telefono2)
		,correo = trim(_correo)
		,estado = 'AC'  --EN MIGRACION DE EXCEL PONER ESTADO IN (INACTIVO)
	where id = _id;	

	--ACTUALIZA DATOS MESA CON ID USUARIO
	--select * from mesa where id_usuario=3			
	UPDATE mesa SET 
		bandera_usuario_asignado = true,
		fecha_modificacion = current_timestamp
	where id_usuario = _id;	

    ------Valida si se afectaron filas----------------
    GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
    if filasAfectadas = 0 then
       return QUERY select 'error', 'El Registro no se pudo Modificar', '0';	
    else
    	return QUERY select 'success', 'OK', _id::text;
    end if;
   ---------------------------------------------------
END;
$function$
;
