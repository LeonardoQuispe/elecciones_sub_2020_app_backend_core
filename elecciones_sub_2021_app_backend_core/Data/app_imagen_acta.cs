using elecciones_sub_2021_app_backend_core.Models;
using Dapper;
using Microsoft.AspNetCore.Http;
using System;
using System.Data;
using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class app_imagen_acta: Iapp_imagen_acta
    {
        private readonly Ic_conexion _c_conexion;
        public app_imagen_acta(Ic_conexion c_conexion)
        {
            this._c_conexion = c_conexion;
        }
        public async Task<AppRespuestaBD> guardar(IFormFile imagen, long idMesa)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_abm_imagen_acta";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            accion = 1,
							_id_mesa = idMesa,
							_nombre = idMesa.ToString() + ".png",
							_tamano = imagen.Length,
							_content_type = "image/png",
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
        public async Task<AppRespuestaBD> modificar(IFormFile imagen, long idMesa)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_abm_imagen_acta";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            accion = 2,
							_id_mesa = idMesa,
							_nombre = idMesa.ToString() + ".png",
							_tamano = imagen.Length,
							_content_type = "image/png",
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
        public async Task<object> traer_imagen_acta()
        {
            try
            {
                object datos = new object();

                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    datos = await cnx.QuerySingleOrDefaultAsync("select * from imagen_acta limit 1;");
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

