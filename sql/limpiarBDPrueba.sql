delete from det_conteo_partido;
delete from conteo;
delete from imagen_acta;
update adm_usuario set estado = 'PE' where id_rol in (3,9);
update mesa set id_estado_mesa = 1, bandera_apertura = null,fecha_hora_apertura = null,
	bandera_usuario_asignado = null, observacion = null, bandera_validado_jefe_recinto = null;


