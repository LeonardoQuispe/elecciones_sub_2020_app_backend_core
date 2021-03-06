
--SABER CONTRASENA DE USUARIO JEFES RECINTO
select 
	u.id as idUsuario
	,r.id as idRecinto
	,r.nombre as nombre_recinto
	,u.cuenta
	,decrypt(u.contrasena::bytea, u.salt::bytea, 'aes') as contrasena  
--	,m.nombre as municipio
--	,r.id_circunscripcion
--	,(select count(m2.id) from mesa m2 where m2.estado='AC' and m2.id_recinto=r.id) total_mesas
from adm_usuario u
inner join det_usuario_recinto dur on dur.id_usuario = u.id 
inner join recinto r on r.id = dur.id_recinto
inner join municipio m on m.id = r.id_municipio 
where u.estado = 'AC' and r.estado = 'AC' and m.estado = 'AC' and dur.estado ='AC'
and upper(r.nombre) like upper('%siles%')
-- and r.id = 3955
order by m.nombre ASC,total_mesas desc;







select * from det_usuario_distrito dud order by id_usuario ;

update adm_usuario set id_rol = 14 where id = 44112
update adm_usuario set id_rol = 17 where id = 44114


select * from adm_rol ar 
select * from adm_usuario au limit 3





ALTER TABLE public.det_usuario_distrito ADD CONSTRAINT det_usuario_distrito_fk FOREIGN KEY (id_usuario) REFERENCES public.adm_usuario(id);
ALTER TABLE public.det_usuario_distrito ADD CONSTRAINT det_usuario_distrito_fk_1 FOREIGN KEY (id_distrito) REFERENCES public.distrito(id);


select * from adm_usuario au where nombre like '%jefemun70101%'
select * from adm_funcion af 
select * from adm_usuario_funcion auf 
INSERT INTO public.adm_usuario_funcion(id_usuario, id_funcion, estado)VALUES(262, 38, 'AC');

rpt_consolidado_mesas_actas





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
and r.id_distrito = 5
order by total_mesa DESC,r.nombre ASC
--and cuenta = 'jeferec39551';
--and u.id = 41318






select distinct id_municipio from det_municipio_partido dmp;
select m.nombre ,p.sigla , p.nombre 
from det_municipio_partido mp
inner join municipio m on m.id = mp.id_municipio
inner join partido p on p.id = mp.id_partido 
order by m.nombre , mp.id;




delete from imagen_acta;
TRUNCATE conteo CASCADE;
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


select * from estado_mesa em 


select * from mesa m2 limit 3;


--ALTER TABLE public.mesa ADD observacion_recepcion varchar NULL;



select to_char(3148, '999G999')



select sum(r.total_mesa) from recinto r  where id_distrito is not null 



