using elecciones_sub_2021_app_backend_core.Models;
using Dapper;
using System;
using System.Data;
using System.Threading.Tasks;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class app_mesa
    {
        c_conexion _c_conexion = new c_conexion();
        public async Task<AppMesaRecintoListado> listar_mesa_recinto(long id_usuario)
        {
            try
            {
                AppMesaRecintoListado datos = new AppMesaRecintoListado();
                string nombreFuncion;

                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    nombreFuncion = "sp_app_listar_mesa_recinto";
                    datos.mesaListado = await cnx.QueryAsync<AppMesaListado>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_usuario = id_usuario,
                        }                  
                    );
                    nombreFuncion = "sp_app_traer_recinto";
                    datos.nombre_recinto = cnx.QueryFirstOrDefault<string>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_usuario = id_usuario,
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
        public async Task<AppRespuestaBD> guardar(AppPostMesa datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_abm_mesa";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_mesa = datos.id_mesa,
                            _observacion_conteo = datos.observacion_conteo,
                            _id_estado_mesa = datos.id_estado_mesa,
                            _bandera_validado_jefe_recinto = datos.bandera_validado_jefe_recinto,
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

        public async Task<AppRespuestaBD> aperturar_mesa(AppPostAperturarMesa datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_aperturar_mesa";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_mesa = datos.id_mesa,
                            _fecha_hora_apertura = datos.fecha_hora_apertura,
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

        public async Task<AppRespuestaBD> anular_mesa(AppPostAnularMesa datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_anular_mesa";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_mesa = datos.id_mesa,
                            _observacion = datos.observacion,
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

        public async Task<AppRespuestaBD> limpiar_mesa(long idMesa)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_limpiar_mesa";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_mesa = idMesa,
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

        public async Task<AppTraerMesaConteoUsuario> traer_mesa_de_usuario(long id_usuario, long id_mesa)
        {
            try
            {
                AppTraerMesaConteoUsuario datos = new AppTraerMesaConteoUsuario();
                string nombreFuncion;

                nombreFuncion = "sp_app_traer_mesa_de_usuario";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    datos.mesaDeUsuario = await cnx.QueryFirstOrDefaultAsync<AppMesaDeUsuario>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _id_usuario = id_usuario,
                            _id_mesa = id_mesa,
                        }                  
                    );

                    if (datos.mesaDeUsuario != null)
                    {
                        nombreFuncion = "sp_app_traer_conteo_mesa";
                        datos.conteos = await cnx.QueryAsync<AppTraerConteo>(
                            sql: nombreFuncion,
                            commandType: CommandType.StoredProcedure,
                            param: new {
                                _id_mesa = datos.mesaDeUsuario.id,
                            }                  
                        );

                        foreach (AppTraerConteo item in datos.conteos)
                        {
                            nombreFuncion = "sp_app_traer_det_conteo_partido";
                            item.votosPartidos = await cnx.QueryAsync<AppTraerDetConteoPartido>(
                                sql: nombreFuncion,
                                commandType: CommandType.StoredProcedure,
                                param: new {
                                    _id_conteo = item.id,
                                }                  
                            );
                        }
                    }
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

