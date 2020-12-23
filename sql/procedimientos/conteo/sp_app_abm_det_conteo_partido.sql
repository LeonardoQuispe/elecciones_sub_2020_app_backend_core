drop function if exists sp_app_abm_det_conteo_partido;
CREATE OR REPLACE FUNCTION sp_app_abm_det_conteo_partido(
	accion integer, 
	_id bigint, 
	_id_conteo bigint DEFAULT NULL, 
	_id_partido bigint DEFAULT NULL, 
	_total_voto integer DEFAULT NULL
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
            --INSERTA DATOS}
            insert into det_conteo_partido(
				id_conteo
				,id_partido
				,total_voto
				,fecha_registro
				,fecha_modificacion
				,estado
				) 
            values (
            	_id_conteo
				,_id_partido
				,_total_voto
				,current_timestamp
				,null
				,'AC'
				)
            RETURNING id INTO v_id;		
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
                return QUERY select 'error', 'El Registro no se pudo Guardar', v_id;
            else 
           		return QUERY select 'success', 'OK', v_id::text;
            end if;
           ---------------------------------------------------
        end;

        --MODIFICAR
      	when 2 then
      	begin
          	--ACTUALIZA DATOS
          	update det_conteo_partido set
          		total_voto = _total_voto
          		,fecha_modificacion = current_timestamp
          	where id = _id;	
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
                return QUERY select 'error', 'El Registro no se pudo Actualizar', _id::text;
            else 
           		return QUERY select 'success', 'OK', _id::text;
            end if;
           ---------------------------------------------------
        end;
    
        --Eliminar
        when 3 then
        begin			
	      	--ELIMINA LOS DATOS
	      	delete from det_conteo_partido where id_conteo = _id_conteo;
            ------Valida si se afectaron filas----------------
            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
            if filasAfectadas = 0 then
           		return QUERY select 'error', 'El Registro no se pudo Eliminar', '0'; 
            else
            	return QUERY select 'success', 'OK', '0';
            end if;
           ---------------------------------------------------
        end;
        else 
            return QUERY select 'error', 'Ninguna Accion coincide', '0';
        
    end case;
END;
$function$
;
