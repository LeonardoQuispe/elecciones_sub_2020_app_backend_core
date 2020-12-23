drop function if exists sp_app_registrar_usuario_recinto;
CREATE OR REPLACE function sp_app_registrar_usuario_recinto(
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
    aux_id_usuario bigint;
begin
            
	aux_id_usuario := coalesce((
								SELECT u.id 
								FROM adm_usuario u
								INNER JOIN det_usuario_recinto dur on dur.id_usuario = u.id
								inner join recinto r on r.id = dur.id_recinto
								where r.estado = 'FC'
							),0);
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
	where id = aux_id_usuario;	
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
