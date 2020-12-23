
---------------------Jefes de Recinto en Santa Cruz----------------------
select 
	'C-'||r.id_circunscripcion as circunscripcion,
	r.nombre as recinto, 
	coalesce(u.nombre, 'SIN ASIGNAR') as nombre, 
	coalesce(u.apellido_paterno, 'SIN ASIGNAR') as apellido_paterno, 
	coalesce(u.apellido_materno, 'SIN ASIGNAR') as apellido_materno,
	coalesce(u.telefono1, 'SIN ASIGNAR') as telefono1,
	coalesce(u.telefono2, 'SIN ASIGNAR') as telefono2,
	coalesce(u.carnet_identidad, 'SIN ASIGNAR') as carnet_identidad
from det_usuario_recinto dur
inner join adm_usuario u on u.id = dur.id_usuario
inner join recinto r on r.id = dur.id_recinto
inner join municipio m on m.id = r.id_municipio
inner join provincia p on p.id = m.id_provincia
where p.id_departamento = 7 
order by r.id_circunscripcion, r.nombre;

------------------------Delegados de Mesa en Santa Cruz-------------------------
select 
	'C-'||r.id_circunscripcion as circunscripcion,
	r.nombre as recinto, 
	me.numero_mesa,
	coalesce(u.nombre, 'SIN ASIGNAR') as nombre,
	coalesce(u.apellido_paterno, 'SIN ASIGNAR') as apellido_paterno, 
	coalesce(u.apellido_materno, 'SIN ASIGNAR') as apellido_materno,
	coalesce(u.telefono1, 'SIN ASIGNAR') as telefono1,
	coalesce(u.telefono2, 'SIN ASIGNAR') as telefono2,
	coalesce(u.carnet_identidad, 'SIN ASIGNAR') as carnet_identidad
from mesa me
inner join recinto r on r.id = me.id_recinto
inner join adm_usuario u on u.id = me.id_usuario
inner join municipio m on m.id = r.id_municipio
inner join provincia p on p.id = m.id_provincia
where p.id_departamento = 7 
order by r.id_circunscripcion, r.nombre, me.numero_mesa;


  
drop function if exists sp_app_traer_parametros;
CREATE OR REPLACE FUNCTION sp_app_traer_parametros()
 RETURNS TABLE(
 	fecha_hora_servidor timestamp
 )
 LANGUAGE plpgsql
AS $function$
begin
	return query select current_timestamp::timestamp;
end;
$function$
;
/*
select * from sp_app_traer_parametros()
*/
  
drop function if exists sp_app_abm_conteo;
CREATE OR REPLACE FUNCTION sp_app_abm_conteo(
	accion integer, 
	_id bigint, 
	_votos_validos integer DEFAULT NULL::integer, 
	_votos_nulos integer DEFAULT NULL::integer,
	_votos_blancos integer DEFAULT NULL::integer, 
	_observacion character varying DEFAULT NULL::character varying, 
	_id_mesa bigint DEFAULT NULL::bigint, 
	_id_tipo_conteo bigint DEFAULT NULL::bigint, 
	_id_imagen_acta bigint DEFAULT NULL::bigint, 
	_id_plataforma bigint DEFAULT NULL::bigint,
	_estado_conteo_por_rol character varying DEFAULT NULL::character varying
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
				,observacion
				,id_mesa
				,id_tipo_conteo
				,id_imagen_acta
				,id_plataforma
				,fecha_registro
				,fecha_modificacion
				,estado
				) 
            values (
				_votos_validos
				,_votos_nulos
				,_votos_blancos
				,trim(_observacion)
				,_id_mesa
				,_id_tipo_conteo
				,_id_imagen_acta
				,_id_plataforma
				,current_timestamp
				,null
				,_estado_conteo_por_rol
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
          	--Valida Datos
            
            --ACTUALIZA DATOS
            UPDATE conteo SET 
				votos_validos = _votos_validos
				,votos_nulos = _votos_nulos
				,votos_blancos = _votos_blancos
				,observacion = trim(_observacion)
				,id_imagen_acta = _id_imagen_acta
				,id_plataforma = _id_plataforma
				,fecha_modificacion = current_timestamp
				,estado = 'PJ'
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
  
drop function if exists sp_app_abm_det_conteo_partido;
CREATE OR REPLACE FUNCTION sp_app_abm_det_conteo_partido(
	accion integer, 
	_id bigint, 
	_id_conteo bigint DEFAULT NULL::bigint, 
	_id_partido bigint DEFAULT NULL::bigint, 
	_total_voto integer DEFAULT NULL::integer
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
--	v_id := ( select id from det_conteo_partido where id_conteo = _id_conteo and id_partido = _id_partido and estado in ('AC') );
--
--	raise notice 'v_id = %', v_id;
--
--	if v_id is null then
--		accion := 1;
--	else
--		accion := 2;
--	end if;
--	raise notice 'accion = %', accion;

    case accion	
        -- REGISTRAR
        when 1 then
        begin
            --Valida Datos
            
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
    
        --CAMBIA DE ESTADO
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
  
drop function if exists sp_app_traer_conteo_mesa;
CREATE OR REPLACE FUNCTION sp_app_traer_conteo_mesa(
	_id_mesa bigint
	,_id_tipo_conteo bigint
)
 RETURNS TABLE(
 	id bigint,
 	id_imagen_acta bigint,
 	observacion character varying
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		c.id
		,c.id_imagen_acta
		,c.observacion
	from conteo c
	where id_mesa = _id_mesa
	and id_tipo_conteo = _id_tipo_conteo
	and estado not in ('BA');
end;
$function$
;
/*
select * from sp_app_traer_conteo_mesa(28, 1)
*/
  
drop function if exists sp_app_traer_det_conteo_partido;
CREATE OR REPLACE FUNCTION sp_app_traer_det_conteo_partido(
	_id_conteo bigint
)
 RETURNS TABLE(
 	id_det_conteo_partido bigint,
 	id_partido bigint,
 	total_voto int
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		d.id as id_det_conteo_partido
		,d.id_partido
		,d.total_voto
	from det_conteo_partido d
	inner join partido p on p.id = d.id_partido
	where id_conteo = _id_conteo
	and d.estado in ('AC') and p.estado in ('AC')
	order by id_partido;
end;
$function$;
/*
select * from sp_app_traer_det_conteo_partido(17)
*/
  
drop function if exists sp_app_valida_conteo;
CREATE OR REPLACE FUNCTION sp_app_valida_conteo(
	_id bigint, 
	_votos_validos integer DEFAULT NULL::integer, 
	_votos_nulos integer DEFAULT NULL::integer,
	_votos_blancos integer DEFAULT NULL::integer, 
	_observacion character varying DEFAULT NULL::character varying, 
	_id_mesa bigint DEFAULT NULL::bigint, 
	_id_tipo_conteo bigint DEFAULT NULL::bigint,
	_id_plataforma bigint DEFAULT NULL::bigint
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
    aux_habilitados int;
    aux_total_votos int;
begin
    aux_total_votos := (_votos_validos + _votos_nulos + _votos_blancos);
    aux_habilitados := (select habilitados from mesa m where m.id = _id_mesa);
   	if aux_habilitados = 0 then
   		return QUERY select 'success', 'OK', '0';
   		return;
   	end if;
   	if (aux_total_votos > aux_habilitados) then
   		return QUERY select 'success', 'El total de votos ingresados ('||aux_total_votos||') es mayor al total de votos habilitados para esta mesa ('||aux_habilitados||'), ¿Desea guardar de todas formas?', '0';
   		return;
   	end if;
   
   	return QUERY select 'success', 'OK', '0';
END;
$function$
;
/*
select * from sp_app_valida_conteo(0,5,5,5,'',29,1,1);
 */

              
CREATE OR REPLACE function sp_app_abm_imagen_acta(
	accion integer, 
	_id_conteo bigint, 
	_nombre character varying DEFAULT NULL::character varying, 
	_tamano bigint DEFAULT NULL::bigint, 
	_content_type character varying DEFAULT NULL::character varying, 
	_archivo bytea DEFAULT NULL::bytea
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
            
            --INSERTA DATOS}
            insert into imagen_acta(
				nombre
				,tamano
				,content_type
				,archivo
				,fecha_registro
				,fecha_modificacion
				,estado
				) 
            values (
				trim(_nombre)
				,_tamano
				,trim(_content_type)
				,_archivo
				,current_timestamp
				,null
				,'AC'
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
          	--Valida Datos
            if (select id_imagen_acta from conteo where id = _id_conteo) is null then 
	            --INSERTA DATOS}
	            insert into imagen_acta(
					nombre
					,tamano
					,content_type
					,archivo
					,fecha_registro
					,fecha_modificacion
					,estado
					) 
	            values (
					trim(_nombre)
					,_tamano
					,trim(_content_type)
					,_archivo
					,current_timestamp
					,null
					,'AC'
					)
	            RETURNING id INTO v_id;		
	            ------Valida si se afectaron filas----------------
	            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
	            if filasAfectadas = 0 then
	                return QUERY select 'error', 'El Registro no se pudo Guardar', '0';
	            else 
	           		return QUERY select 'success', 'OK', v_id::text;
	            end if;
           	else
           		v_id := coalesce((select id_imagen_acta from conteo c where c.id = _id_conteo), 0);
            	--ACTUALIZA DATOS
	            UPDATE imagen_acta SET 
					nombre = trim(_nombre)
					,tamano = _tamano
					,content_type = trim(_content_type)
					,archivo = _archivo
					,fecha_modificacion = current_timestamp
				where id = v_id;			
	            ------Valida si se afectaron filas----------------
	            GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
	            if filasAfectadas = 0 then
	               return QUERY select 'error', 'El Registro no se pudo Modificar', '0';	
	            else
	            	return QUERY select 'success', 'OK', v_id::text;
	            end if;
	           ---------------------------------------------------
			end if;
        end;
        else 
            return QUERY select 'error', 'Ninguna Accion coincide', '0';
        
    end case;
END;
$function$
;
  
drop function if exists sp_app_traer_imagen_acta;
CREATE OR REPLACE FUNCTION sp_app_traer_imagen_acta(
	_id_imagen_acta bigint
)
 RETURNS TABLE(
 	nombre  character varying,
 	content_type character varying,
 	archivo bytea
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	
    RETURN QUERY select 
		i.nombre
		,i.content_type
		,i.archivo
	from imagen_acta i
	where id = _id_imagen_acta
	and estado in ('AC');
end;
$function$
;
/*
select * from sp_app_traer_imagen_acta(399)
*/
  
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
  
drop function if exists sp_app_aperturar_mesa;
CREATE OR REPLACE FUNCTION sp_app_aperturar_mesa(    
	_id_mesa bigint
	,_fecha_hora_apertura timestamp
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
		bandera_apertura = true
		,fecha_hora_apertura = _fecha_hora_apertura
		,fecha_modificacion = current_timestamp
	where id = _id_mesa;
    ------Valida si se afectaron filas----------------
    GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
    if filasAfectadas = 0 then
       return QUERY select 'error', 'La Mesa no se pudo Aperturar', _id_mesa::text;	
    else
    	return QUERY select 'success', 'OK', _id_mesa::text;
    end if;

END;
$function$;

/*

*/
  
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
  
drop function if exists sp_app_cambiar_estado_mesa;
CREATE OR REPLACE FUNCTION sp_app_cambiar_estado_mesa(
	_id_rol bigint,
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
   	aux_nro_conteo int;
   	aux_nro_conteo_por_rol int;
begin
	if (_id_rol = 8 or _id_rol = 9) then
		aux_nro_conteo_por_rol := 1;
	elsIF (_id_rol = 2 or _id_rol = 3) then
		aux_nro_conteo_por_rol := 2;
	end if;
	
    if (_id_rol = 2 or _id_rol = 8) then
        --Valida Datos
        aux_nro_conteo := (select count(*) from conteo where id_mesa = _id_mesa and estado not in ('BA') and estado = 'PJ');
       	if aux_nro_conteo = aux_nro_conteo_por_rol then
	        update mesa set 
	        	bandera_validado_jefe_recinto = true,
	        	id_estado_mesa = 2,
	        	fecha_modificacion = current_timestamp
	        where id = _id_mesa;
	        update conteo set 
	        	estado = 'AC'
	        where id_mesa = _id_mesa
	       	and estado not in ('BA');		       
	        ------Valida si se afectaron filas----------------
	        GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
	        if filasAfectadas = 0 then
	            return QUERY select 'error', 'El Registro no se pudo Guardar', v_id;
	        else 
	       		return QUERY select 'success', 'OK', '0';
	        end if;
	       ---------------------------------------------------
        else 
        	return QUERY select 'success', 'OK', '0';
       	end if;
   	elsif (_id_rol = 3 or _id_rol = 9) then
	  	--Valida Datos
	    aux_nro_conteo := (select count(*) from conteo where id_mesa = _id_mesa and estado not in ('BA') and estado = 'PD');
	   	if aux_nro_conteo = aux_nro_conteo_por_rol then
	        update mesa set
	        	id_estado_mesa = 2
	        where id = _id_mesa;	
	        update conteo set 
	        	estado = 'AC'
	        where id_mesa = _id_mesa
	       	and estado not in ('BA');		
	        ------Valida si se afectaron filas----------------
	        GET DIAGNOSTICS filasAfectadas = ROW_COUNT;	
	        if filasAfectadas = 0 then
	           return QUERY select 'error', 'El Registro no se pudo Modificar', v_id;	
	        else
	        	return QUERY select 'success', 'OK', '0';
	        end if;
	       ---------------------------------------------------
	    else 
	    	return QUERY select 'success', 'OK', '0';
		end if;
   	end if;
END;
$function$
;
  
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


	with cte_imagen_acta as (
	    select id_imagen_acta
	    from conteo c
	    where id_mesa = _id_mesa
	)	
	update imagen_acta
	set 
		estado = 'BA'
		,fecha_modificacion = current_timestamp
	-- delete from det_conteo_partido
	where id in (select id from cte_imagen_acta);


	-- 1. Actualiza el Estado de la mesa
    UPDATE mesa SET 
		id_estado_mesa = 1
		,bandera_validado_jefe_recinto = false
		,observacion = null
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
  
drop function if exists sp_app_listar_mesa_recinto;
CREATE OR REPLACE FUNCTION sp_app_listar_mesa_recinto(
	_id_usuario bigint
)
 RETURNS TABLE(
 	id bigint, 
 	numero_mesa integer, 
 	bandera_usuario_asignado boolean, 
 	bandera_apertura boolean, 
 	bandera_validado_jefe_recinto boolean, 
 	id_estado_mesa bigint
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	sql := 'select
				m.id
				, m.numero_mesa
				, m.bandera_usuario_asignado
				, m.bandera_apertura
				, m.bandera_validado_jefe_recinto
				, m.id_estado_mesa
			from mesa m
			inner join det_usuario_recinto d on d.id_recinto = m.id_recinto
			where m.estado = ''AC''
			and d.id_usuario = '||_id_usuario||' order by m.numero_mesa';

	--raise notice 'Value: %', sql;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select * from sp_app_listar_mesa_recinto(30415)
*/
  
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
  
drop function if exists sp_app_traer_mesa_de_usuario;
CREATE OR REPLACE FUNCTION sp_app_traer_mesa_de_usuario(
	_id_usuario bigint,
	_id_mesa bigint
)
 RETURNS TABLE(
 	id bigint, 
 	numero_mesa integer, 
 	bandera_usuario_asignado boolean, 
 	bandera_apertura boolean, 
 	bandera_validado_jefe_recinto boolean, 
 	id_estado_mesa bigint,
 	bandera_presidente character varying,
 	bandera_diputado character varying,
 	telefono_centro_computo character varying,
 	id_recinto character varying,
 	nombre_recinto character varying
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
	aux_telefono_centro_computo varchar;
begin
	aux_telefono_centro_computo := coalesce((select p.telefono_centro_computo from parametros p),'0')::varchar;
	if(_id_mesa <> 0) then
		sql := 'select
					m.id
					, m.numero_mesa
					, m.bandera_usuario_asignado
					, m.bandera_apertura
					, m.bandera_validado_jefe_recinto
					, m.id_estado_mesa
					, (select estado from conteo where id_mesa = m.id and id_tipo_conteo = 1 and estado not in (''BA'')) as bandera_presidente
					, (select estado from conteo where id_mesa = m.id and id_tipo_conteo = 2 and estado not in (''BA'')) as bandera_diputado
					, '''||aux_telefono_centro_computo||'''::varchar as telefono_centro_computo
					, r.codigo_oep as id_recinto
					, r.nombre as nombre_recinto					
				from mesa m
				inner join recinto r on r.id = m.id_recinto
				where m.estado = ''AC''
				and m.id = '||_id_mesa||' limit 1';
	else
		sql := 'select
					m.id
					, m.numero_mesa
					, m.bandera_usuario_asignado
					, m.bandera_apertura
					, m.bandera_validado_jefe_recinto
					, m.id_estado_mesa
					, (select estado from conteo where id_mesa = m.id and id_tipo_conteo = 1 and estado not in (''BA'')) as bandera_presidente
					, (select estado from conteo where id_mesa = m.id and id_tipo_conteo = 2 and estado not in (''BA'')) as bandera_diputado
					, '''||aux_telefono_centro_computo||'''::varchar as telefono_centro_computo		
					, r.codigo_oep as id_recinto
					, r.nombre as nombre_recinto		
				from mesa m
				inner join recinto r on r.id = m.id_recinto
				where m.estado = ''AC''
				and m.id_usuario = '||_id_usuario||' limit 1';
	end if;
	raise notice 'Value: %', sql;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select * from sp_app_traer_mesa_de_usuario(3, 0)
*/
  
drop function if exists sp_app_traer_recinto;
CREATE OR REPLACE FUNCTION sp_app_traer_recinto(
	_id_usuario bigint
)
 RETURNS TABLE(
 	nombre_recinto character varying
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
	sql := 'select
				r.nombre as nombre_recinto
			from det_usuario_recinto d
			inner join recinto r on r.id = d.id_recinto
			where r.estado in (''AC'', ''FC'')
			and d.id_usuario = '||_id_usuario||' limit 1';

	--raise notice 'Value: %', <;
    RETURN QUERY EXECUTE sql;
end;
$function$
;
/*
select * from sp_app_traer_recinto(30415)
*/
  
drop function if exists sp_app_traer_usuario_mesa;
CREATE OR REPLACE FUNCTION sp_app_traer_usuario_mesa(
	_id_mesa bigint
)
 RETURNS TABLE(
 	id bigint,
 	cuenta character varying,
 	contrasena bytea,
 	nombre character varying,
 	apellido_paterno character varying,
 	apellido_materno character varying,
 	carnet_identidad character varying,
 	telefono1 character varying,
 	telefono2 character varying,
 	correo character varying
 )
 LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
--	contrasena = encrypt('4fce29'::bytea, telefono2::bytea,'aes'::text)::varchar 
    RETURN QUERY select
   		u.id,
   		u.cuenta,
   		decrypt(u.contrasena::bytea, u.salt::bytea, 'aes') as contrasena,
   		u.nombre,
   		u.apellido_paterno,
   		u.apellido_materno,
   		u.carnet_identidad,
   		u.telefono1,
   		u.telefono2,
   		u.correo
    from mesa m
    inner join adm_usuario u on u.id = m.id_usuario
   	where m.id = _id_mesa;
end;
$function$
;
/*
select * from sp_app_traer_usuario_mesa(27)
*/
  
drop function if exists rpt_mesas_aperturadas_por_circunscripcion_prueba;
CREATE OR REPLACE FUNCTION rpt_mesas_aperturadas_por_circunscripcion_prueba(    
	_id_departamento bigint,
	_id_circunscripcion bigint,
	_id_municipio bigint
)
RETURNS TABLE(
 	circunscripcion character varying, 
 	nombre_recinto character varying, 
 	total_mesa integer, 
 	mesas_sin_aperturar bigint, 
 	mesas_aperturadas bigint,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql := 'select 
		 r.id_circunscripcion::varchar as circunscripcion,
		 r.nombre as nombre_recinto,
		 r.total_mesa,
		 (select count(*) from mesa me where me.id_recinto = r.id and (me.bandera_apertura is null or me.bandera_apertura = false)) as mesas_sin_aperturar,
		 (select count(*) from mesa m where m.id_recinto = r.id and m.bandera_apertura = true) as mesas_aperturadas,
		 to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
	from recinto r
	inner join municipio m on m.id = r.id_municipio
	inner join provincia p on p.id = m.id_provincia
	where 1=1';
	
	if _id_departamento >  0 then
		sql = sql || ' and p.id_departamento = ' || _id_departamento;
	end if;	
	if _id_circunscripcion >  0 then
		sql = sql || ' and r.id_circunscripcion = ' || _id_circunscripcion;
	end if;	
	if _id_municipio >  0 then
		sql = sql || ' and r.id_municipio = ' || _id_municipio;
	end if;	

	sql := sql || 'order by nombre_recinto';

	raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from recinto where id = 4146
select * from mesa where id_recinto = 4146
select * from recinto where id_circunscripcion = 57
select * from rpt_mesas_aperturadas_por_circunscripcion(57);
select * from rpt_mesas_aperturadas_por_circunscripcion_prueba(7::bigint,57::bigint,0);
*/
  
drop function if exists rpt_mesas_aperturadas_por_recinto;
CREATE OR REPLACE FUNCTION rpt_mesas_aperturadas_por_recinto(    
	_id_recinto bigint
)
RETURNS TABLE(
 	nombre_recinto character varying, 
 	usuarios character varying, 
 	numero_mesa int, 
 	fecha_hora_apertura text,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
begin
   	return QUERY 
	select 
		 r.nombre as nombre_recinto,
		 string_agg((coalesce(u.nombre,'---')||' '||coalesce(u.apellido_paterno,'---')||' '||coalesce(u.apellido_materno,'---'))::varchar, ', ')::varchar as usuarios,
		 m.numero_mesa,
		 coalesce(to_char(m.fecha_hora_apertura, 'DD/MM/YYYY HH12:MI PM'),'SIN APERTURAR') as fecha_hora_apertura,
		 to_char(current_timestamp, 'DD/MM/YYYY HH12:MI PM') as fecha_hora_actual
	from mesa m
	inner join recinto r on r.id = m.id_recinto
	inner join det_usuario_recinto dur on dur.id_recinto = r.id
	inner join adm_usuario u on u.id = dur.id_usuario
	where r.id = _id_recinto
	group by r.nombre,m.numero_mesa,m.fecha_hora_apertura
	order by m.numero_mesa asc;
END;
$function$;

/*
select * from rpt_mesas_aperturadas_por_recinto(84)
*/
  
drop function if exists rpt_mesas_llenadas_por_circunscripcion;
CREATE OR REPLACE FUNCTION rpt_mesas_llenadas_por_circunscripcion(    
	_id_circunscripcion bigint
)
RETURNS TABLE(
 	departamento character varying, 
 	porcentaje_llenadas numeric,
 	mesas_llenadas bigint, 
 	mesas_totales bigint,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql :=
		'with tabla_aux1 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_totales
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;
	
	sql := sql ||
		' 	group by d.nombre
			order by d.nombre
		), tabla_aux2 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_llenadas 
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1 and me.id_estado_mesa = 2';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;

	sql := sql ||
		'	group by d.nombre
			order by d.nombre
		)
		select 
			t1.departamento,
			round(((t2.mesas_llenadas*100)/t1.mesas_totales::numeric),2) as porcentaje_llenadas,
			t2.mesas_llenadas,
			t1.mesas_totales,
			to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
		from tabla_aux1 t1
		inner join tabla_aux2 t2 on t1.departamento = t2.departamento';

	--raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from rpt_mesas_llenadas_por_circunscripcion(0);
*/
  
drop function if exists rpt_mesas_llenadas_por_departamento;
CREATE OR REPLACE FUNCTION rpt_mesas_llenadas_por_departamento(    
	_id_departamento bigint
)
RETURNS TABLE(
 	departamento character varying, 
 	porcentaje_llenadas numeric,
 	mesas_llenadas bigint, 
 	mesas_totales bigint,
 	fecha_hora_actual text
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql :=
		'with tabla_aux1 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_totales
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;
	
	sql := sql ||
		' 	group by d.nombre
			order by d.nombre
		), tabla_aux2 as 
		(
			select 
				d.nombre as departamento,
				count(me.id) as mesas_llenadas 
			from mesa me
			inner join recinto r on r.id = me.id_recinto
			inner join municipio m on m.id = r.id_municipio
			inner join provincia p on p.id = m.id_provincia
			inner join departamento d on d.id = p.id_departamento
			where d.id_pais = 1 and me.id_estado_mesa = 2';

	if _id_departamento >  0 then
		sql = sql || ' and d.id = ' || _id_departamento;
	end if;

	sql := sql ||
		'	group by d.nombre
			order by d.nombre
		)
		select 
			t1.departamento,
			round(((t2.mesas_llenadas*100)/t1.mesas_totales::numeric),2) as porcentaje_llenadas,
			t2.mesas_llenadas,
			t1.mesas_totales,
			to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
		from tabla_aux1 t1
		inner join tabla_aux2 t2 on t1.departamento = t2.departamento';

	--raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from rpt_mesas_llenadas_por_departamento(0);
*/
  
drop function if exists rpt_mesas_reportadas_por_circunscripcion;
CREATE OR REPLACE FUNCTION rpt_mesas_reportadas_por_circunscripcion(    
	_id_departamento bigint,
	_id_circunscripcion bigint
)
RETURNS TABLE(
 	departamento character varying, 
 	circunscripcion bigint, 
 	nombre_recinto character varying, 
 	numero_mesa int, 
 	observacion character varying, 
 	fecha_hora_actual text,
 	total_observados bigint
)
LANGUAGE plpgsql
AS $function$
declare
	sql VARCHAR;
begin
   	sql := 'with tabla_aux as (select 
		 d.nombre as departamento,
		 r.id_circunscripcion as circunscripcion,
		 r.nombre as nombre_recinto,
		 me.numero_mesa,
		 coalesce(me.observacion, ''SIN OBSERVACIÓN'') as observacion,
		 to_char((current_timestamp - ''4 hour''::interval), ''DD/MM/YYYY HH12:MI PM'') as fecha_hora_actual
	from mesa me
	inner join recinto r on r.id = me.id_recinto
	inner join municipio m on m.id = r.id_municipio
	inner join provincia p on p.id = m.id_provincia
	inner join departamento d on d.id = p.id_departamento
	where d.id_pais = 1';
	
	if _id_departamento >  0 then
		sql = sql || ' and p.id_departamento = ' || _id_departamento;
	end if;	
	if _id_circunscripcion >  0 then
		sql = sql || ' and r.id_circunscripcion = ' || _id_circunscripcion;
	end if;

	sql := sql || 'order by d.nombre,r.id_circunscripcion,r.nombre,me.numero_mesa
		) 
		select
			*,
			(select count(*) from tabla_aux where observacion != ''SIN OBSERVACIÓN'') as total_observados
		from tabla_aux';

	raise notice '%', sql; 
	RETURN QUERY EXECUTE sql;
END;
$function$;

/*
select * from recinto where id = 4146
select * from mesa where id_recinto = 4146
select * from recinto where id_circunscripcion = 57
select * from rpt_mesas_reportadas_por_circunscripcion(7::bigint,0::bigint);
*/
  
