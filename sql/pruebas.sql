



select 
--	u.*
	r.nombre 
	,r.total_mesa 
	,u.cuenta
	,decrypt(u.contrasena::bytea, u.salt::bytea, 'aes') as contrasena  
from adm_usuario u 
inner join det_usuario_recinto dur on dur.id_usuario = u.id 
inner join recinto r on r.id = dur.id_recinto 
where 1=1
and r.id_distrito = 12
order by total_mesa DESC,r.nombre ASC
--and cuenta = 'jeferec39551';
--and u.id = 41318








select 
	u.cuenta
	,decrypt(u.contrasena::bytea, u.salt::bytea, 'aes') as contrasena  
from adm_usuario u where u.nombre like '%jefe%'




select * from adm_usuario au where cuenta = 'jefemun70101'




select 
	r.id_distrito 
	,r.nombre as nombre_recinto
	,m.numero_mesa 
from mesa m 
inner join recinto r on r.id=m.id_recinto and r.estado = 'AC'
where r.id_distrito is not null and m.id_estado_mesa = 2 and m.estado = 'AC'
order by r.id_distrito ,r.nombre ,m.numero_mesa 








create extension pgcrypto



/*
delete from imagen_acta;
TRUNCATE conteo RESTART IDENTITY CASCADE;;
UPDATE public.mesa
set
bandera_usuario_asignado=null
, bandera_apertura=null
, fecha_hora_apertura=null
, bandera_validado_jefe_recinto=null
 , id_estado_mesa=1
 , fecha_modificacion=null
 , bandera_validado_centro_computo=null
 , bandera_acta_recepcionada=null
 , observacion=null
 , observacion_conteo=null;
*/




