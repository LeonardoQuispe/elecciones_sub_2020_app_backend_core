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

            