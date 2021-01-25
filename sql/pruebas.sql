


select 
	u.id as idUsuario
	,r.id as idRecinto
	,r.nombre as nombre_recinto
	,u.cuenta
	,decrypt(u.contrasena::bytea, u.salt::bytea, 'aes') as contrasena  
	,m.nombre as municipio
	,r.id_circunscripcion
	,(select count(m2.id) from mesa m2 where m2.estado='AC' and m2.id_recinto=r.id) total_mesas
from adm_usuario u
inner join det_usuario_recinto dur on dur.id_usuario = u.id 
inner join recinto r on r.id = dur.id_recinto
inner join municipio m on m.id = r.id_municipio 
where u.estado = 'AC' and r.estado = 'AC' and m.estado = 'AC' and dur.estado ='AC'
and upper(r.nombre) like upper('%siles%')
-- and r.id = 3955
order by m.nombre ASC,total_mesas desc;



select count(*) from recinto r where r.estado = 'AC'




delete from imagen_acta;
TRUNCATE conteo CASCADE;
UPDATE public.mesa
set
bandera_usuario_asignado=null
, bandera_apertura=null
, fecha_hora_apertura=null
, bandera_validado_jefe_recinto=null
 ,observacion=null
 , id_estado_mesa=1
 , fecha_modificacion=null
 , bandera_validado_centro_computo=null
 , bandera_acta_recepcionada=null
 , observacion_conteo=null;

















SELECT * FROM mesa where id in (27,28,29,30,31,32,33,34,35);
SELECT * FROM mesa where id in (36,37,38,39,40,41,42,43,44,45,46,47);
select * from det_usuario_recinto;
select * from recinto where id = 28;


select * from conteo where id_mesa in (27,28,29,30,31,32,33,34,35);
select dc.* from det_conteo_partido dc
inner join conteo c on c.id = dc.id_conteo
where c.id_mesa in (27,28,29,30,31,32,33,34,35);


select * from conteo where id_mesa in (36,37,38,39,40,41,42,43,44,45,46,47);
select dc.* from det_conteo_partido dc
inner join conteo c on c.id = dc.id_conteo
where c.id_mesa in (36,37,38,39,40,41,42,43,44,45,46,47);


select * from det_conteo_partido;
select * from adm_rol;
select * from adm_usuario where cuenta = 'delegado31642';
select * from mesa m2 where id =31628
select * from estado_mesa;
select * from tipo_conteo;
select * from partido;
select * from parametros;
select * from det_usuario_recinto;


delete from imagen_acta 
where id in (select id_imagen_acta from conteo where id_mesa in (27,28,29,30,31,32,33,34,35));
select * from imagen_acta
where id in (select id_imagen_acta from conteo where id_mesa in (27,28,29,30,31,32,33,34,35));


select * from provincia p2 where id=713;
select * from municipio m2 where id=71301;
select * from mesa where id=31630;
select * from conteo where id_mesa = 31630;
select * from parametros;
select * from departamento d2 
select * from circunscripcion
select * from municipio
select * from pais
select * from imagen_acta where id_mesa = 31630;
select * from adm_rol ar;
select u.* from adm_usuario u where id_rol=2;
select u.* from adm_usuario u where id_rol=8;
select u.* from adm_usuario u where id_rol=9;
select * from comentario;
delete from comentario;

select * from adm_usuario where id=2;

--select id, cuenta, decrypt(contrasena::bytea, salt::bytea, 'aes') as contrasena  
--from adm_usuario au where cuenta = 'jeferecex52651' ;
select id, cuenta, decrypt(contrasena::bytea, salt::bytea, 'aes') as contrasena  
from adm_usuario au where cuenta = 'jeferec6882' ;

update adm_usuario set
	nombre = null,
	apellido_paterno =null,
	apellido_materno =null
where id=2;

select * from conteo c2 where id_mesa = 1268
select * from sp_app_traer_conteo_mesa(1268)



SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS SIZE FROM pg_database where datname='db_bolivia_dice_no_2';




select * from recinto r2 where nombre like '%JUVENAL%';
select * from mesa m where id_recinto=688 order by numero_mesa ASC;

select * from sp_app_limpiar_mesa(5624);
update mesa set bandera_usuario_asignado=null,bandera_apertura=null where id=5624;




5b3648

select * from parametros p2 ;
select * from partido order by id;






