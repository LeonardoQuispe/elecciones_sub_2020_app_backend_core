using elecciones_sub_2021_app_backend_core.Models;
using Dapper;
using System;
using System.Data;
using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class app_adm_usuario: Iapp_adm_usuario
    {
        c_conexion _c_conexion = new c_conexion();
        public async Task<AppRespuestaCore> login(string usuario, string contrasena)
        {
            AppRespuestaCore respuestaBD = new AppRespuestaCore();
            Usuario objUsuario = await validar(0, usuario, contrasena);

            if (objUsuario != null)
            {
                if (objUsuario.id_rol == (long)ArrayRolUsuario.JefeRecinto || objUsuario.id_rol == (long)ArrayRolUsuario.DelegadoMesa
                    || objUsuario.id_rol == (long)ArrayRolUsuario.JefeRecintoEXTERIOR || objUsuario.id_rol == (long)ArrayRolUsuario.DelegadoMesaEXTERIOR)
                {
                    if (objUsuario.estado == "AC")
                    {
                        return new AppRespuestaCore{
                            status = "success",
                            response = new UsuarioLogin{
                                id = objUsuario.id,
                                cuenta = objUsuario.nombre,
                                id_rol = objUsuario.id_rol,
                            },
                        };
                    }
                    else if (objUsuario.estado == "PE")
                    {
                        return new AppRespuestaCore{
                            status = "error",
                            response = "El Usuario se encuentra Deshabilitado, solicite la Habilitación del Usuario",
                        };
                    }
                } else {
                    return new AppRespuestaCore{
                        status = "error",
                        response = "Insuficientes permisos para acceder a la aplicación",
                    };
                }
            }
            
            return new AppRespuestaCore{
                status = "error",
                response = "Usuario o Contraseña inválido",
            };
        }

        public async Task<AsignarUsuario> traer_usuario_mesa(long id_mesa)
        {
            try
            {
                AsignarUsuario datos = new AsignarUsuario();
                string nombreFuncion;

                nombreFuncion = "sp_app_traer_usuario_mesa";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    datos = await cnx.QueryFirstOrDefaultAsync<AsignarUsuario>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_mesa = id_mesa,
                        }                  
                    );
                    cnx.Close();
                }

                return datos;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<AppRespuestaBD> registrar_usuario_recinto(AsignarUsuario datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion = "sp_app_registrar_usuario_recinto";

                using (IDbConnection cnx = _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new
                        {
							_id = datos.id,
							_nombre = datos.nombre,
							_apellido_paterno = datos.apellido_paterno,
							_apellido_materno = datos.apellido_materno,
							_carnet_identidad = datos.carnet_identidad,
							_telefono1 = datos.telefono1,
							_telefono2 = datos.telefono2,
							_correo = datos.correo,
                        }
                    );
                    cnx.Close();
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<AppRespuestaBD> asignar_usuario_mesa(AsignarUsuario datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion = "sp_app_asignar_usuario";

                using (IDbConnection cnx = _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new
                        {
							_id = datos.id,
							_nombre = datos.nombre,
							_apellido_paterno = datos.apellido_paterno,
							_apellido_materno = datos.apellido_materno,
							_carnet_identidad = datos.carnet_identidad,
							_telefono1 = datos.telefono1,
							_telefono2 = datos.telefono2,
							_correo = datos.correo,
                        }
                    );
                    cnx.Close();
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<Usuario> validar(long codigo, string cuenta, string contrasena)
        {
            try
            {
                Usuario datos = new Usuario();
                string nombreFuncion = "sp_buscar_usuario";

                using (IDbConnection cnx = _c_conexion.conexionPGSQL)
                {
                    datos = await cnx.QuerySingleOrDefaultAsync<Usuario>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new
                        {
                            _id = codigo,
                            _cuenta = cuenta,
                            _contrasena = contrasena
                        }
                    );
                    cnx.Close();
                }
                return datos;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }



    }
}

