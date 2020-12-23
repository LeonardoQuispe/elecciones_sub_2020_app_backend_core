drop function if exists sp_app_abm_conteo;
CREATE OR REPLACE FUNCTION sp_app_abm_conteo(
	accion integer, 
	_id bigint, 
	_votos_validos integer DEFAULT NULL, 
	_votos_nulos integer DEFAULT NULL,
	_votos_blancos integer DEFAULT NULL, 
	_id_mesa bigint DEFAULT NULL, 
	_id_tipo_conteo bigint DEFAULT NULL, 
	_id_plataforma bigint DEFAULT NULL
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
    aux_tipo_conteo varchar;
begin
    case accion	
        -- REGISTRAR
        when 1 then
        begin
	        if _id_tipo_conteo = 1 then
	        	aux_tipo_conteo := 'Presidencial';
	        elsif _id_tipo_conteo = 2 then
	        	aux_tipo_conteo := 'de Diputados';
	        end if;
            --Valida Datos
            perform id from conteo where id_mesa = _id_mesa and id_tipo_conteo = _id_tipo_conteo and estado = 'AC';
            if found then
            	return QUERY select 'error', 'El acta de la Votación '||aux_tipo_conteo||' ya ha sido llenada', '0';
            	return;
           	end if;
            --INSERTA DATOS
            insert into conteo(
				votos_validos
				,votos_nulos
				,votos_blancos
				,id_mesa
				,id_tipo_conteo
				,id_plataforma
				,fecha_registro
				,fecha_modificacion
				,estado
				) 
            values (
				_votos_validos
				,_votos_nulos
				,_votos_blancos
				,_id_mesa
				,_id_tipo_conteo
				,_id_plataforma
				,current_timestamp
				,null
				,'AC'
				)
            RETURNING id INTO v_id;		
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
                return QUERY select 'error', 'El Registro no se pudo Guardar', v_id::text;
            else 
           		return QUERY select 'success', 'OK', v_id::text;
            end if;
           ---------------------------------------------------
        end;

        --MODIFICAR
      	when 2 then
      	begin
            --ACTUALIZA DATOS
            UPDATE conteo SET 
				votos_validos = _votos_validos
				,votos_nulos = _votos_nulos
				,votos_blancos = _votos_blancos
				,id_plataforma = _id_plataforma
				,fecha_modificacion = current_timestamp
			where id = _id;	
	
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
               	return QUERY select 'error', 'El Registro no se pudo Modificar', _id::text;
            else
        		return QUERY select 'success', 'OK', _id::text;
            end if;
           ---------------------------------------------------
        end;
    
        --CAMBIA DE ESTADO
--        when 3 then
--        begin			
--            perform id from conteo where estado = 'BA' and id = _id limit 1;
--            if found then
--                return QUERY select 'error', 'El Registro ya ha sido Eliminado', '0';	
--                return;
--            end if;
--            update conteo
--            set estado = 'BA' 
--		where id = _id;			
--            ------Valida si se afectaron filas----------------
--            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
--            if filasAfectadas = 0 then
--           		return QUERY select 'error', 'El Registro no se pudo Eliminar', '0'; 
--            else
--            	return QUERY select 'success', 'OK', _id::text;
--            end if;
--           ---------------------------------------------------
--        end;
        else 
            return QUERY select 'error', 'Ninguna Accion coincide', '0';
        
    end case;
END;
$function$
;
