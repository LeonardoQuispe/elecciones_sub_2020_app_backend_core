CREATE OR REPLACE function sp_app_abm_imagen_acta(
	accion integer
	,_id_mesa bigint
	,_nombre character varying DEFAULT NULL
	,_tamano bigint DEFAULT NULL
	,_content_type character varying DEFAULT NULL
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
    case accion	
        -- REGISTRAR
        when 1 then
        begin
            --Valida Datos
            -- SELECT *FROM imagen_acta limit 1
            
            --INSERTA DATOS}
            insert into imagen_acta(
				nombre
				,tamano
				,content_type
				,archivo
				,fecha_registro
				,fecha_modificacion
				,estado
				,id_mesa
				) 
            values (
				trim(_nombre)
				,_tamano
				,trim(_content_type)
				,null
				,current_timestamp
				,null
				,'AC'
				,_id_mesa
				)
            RETURNING id INTO v_id;		
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
                return QUERY select 'error', 'El Registro no se pudo Guardar', '0';
            else 
           		return QUERY select 'success', 'OK', v_id::text;
            end if;
           ---------------------------------------------------
        end;

        --MODIFICAR
      	when 2 then
      	begin
        	--ACTUALIZA DATOS
            UPDATE imagen_acta SET 
				nombre = trim(_nombre)
				,tamano = _tamano
				,content_type = trim(_content_type)
				,archivo = null
				,fecha_modificacion = current_timestamp
			where id_mesa = _id_mesa;			
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
               return QUERY select 'error', 'El Registro no se pudo Modificar', '0';	
            else
            	return QUERY select 'success', 'OK', v_id::text;
            end if;
           ---------------------------------------------------
        end;
        else 
            return QUERY select 'error', 'Ninguna Accion coincide', '0';
        
    end case;
END;
$function$
;
