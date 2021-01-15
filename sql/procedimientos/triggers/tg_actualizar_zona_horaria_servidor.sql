drop function if exists tg_sp_actualizar_zona_horaria_servidor;
CREATE FUNCTION tg_sp_actualizar_zona_horaria_servidor() 
RETURNS TRIGGER 
AS $$
BEGIN
	SET TIMEZONE='America/La_Paz';
END;
$$ LANGUAGE plpgsql