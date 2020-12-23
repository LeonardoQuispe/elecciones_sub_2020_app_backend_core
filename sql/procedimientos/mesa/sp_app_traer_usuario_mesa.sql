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
   	where m.id = _id_mesa limit 1;
end;
$function$
;
/*
select * from sp_app_traer_usuario_mesa(30105)
*/
