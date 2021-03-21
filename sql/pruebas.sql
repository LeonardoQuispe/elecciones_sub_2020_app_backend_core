



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
from adm_usuario u where u.nombre like '%jefemun70501%'









select 
	r.id_distrito 
	,r.nombre as nombre_recinto
	,m.numero_mesa 
from mesa m 
inner join recinto r on r.id=m.id_recinto and r.estado = 'AC'
where r.id_distrito is not null and m.id_estado_mesa = 2 and m.estado = 'AC'
order by r.id_distrito ,r.nombre ,m.numero_mesa 






select 
	me.* 
from mesa me
inner join recinto r on me.id_recinto = r.id and r.estado = 'AC'
inner join municipio m on r.id_municipio = m.id and m.estado = 'AC' and m.id = 70501
where me.estado = 'AC';





select p.sigla 
from det_municipio_partido dmp
inner join partido p on p.id = dmp.id_partido 
where id_municipio = 70501 order by dmp.id;



delete from conteo where id in (
select id from conteo where id_mesa in (
6988,
6986,
6978,
6979,
6989,
6940,
6941,
6942,
6943,
6944,
6945,
6946,
6947,
6948,
6949,
6950,
6951,
6952,
6953,
6954,
6955,
6956,
6957,
6958,
6959,
6926,
6927,
6928,
6929,
6930,
6931,
6932,
6933,
6934,
6935,
6936,
6937,
6938,
6939,
6960,
6961,
6962,
6963,
6964,
6965,
6966,
6967,
6968,
6969,
6970,
6971,
6972,
6973,
6974,
6975,
6976,
6977,
6980,
6981,
6987,
6982,
6983,
6984,
6985
)
)





/*
delete from imagen_acta;
TRUNCATE conteo RESTART IDENTITY CASCADE;
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










