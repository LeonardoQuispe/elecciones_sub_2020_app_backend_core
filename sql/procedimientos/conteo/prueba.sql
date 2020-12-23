drop function if exists prueba;
CREATE OR REPLACE FUNCTION prueba(
	accion bigint
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
		    update adm_usuario set
				nombre = 'nombre'
			where id=2;
			return QUERY select 'success', 'OK', v_id::text;
		end;
        when 2 then
        begin
		    update adm_usuario set
				apellido_paterno = 'apellido paterno'
			where id=2;
			return QUERY select 'success', 'OK', v_id::text;
		end;
        when 3 then
        begin
		    update adm_usuario set
				apellido_materno = 'apellido materno'
			where id=2;
			return QUERY select 'success', 'OK', v_id::text;
		end;
	end case;
END;
$function$
;
select * from prueba(1);
