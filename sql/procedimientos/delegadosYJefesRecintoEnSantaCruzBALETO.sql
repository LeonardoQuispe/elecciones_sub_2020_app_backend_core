
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


