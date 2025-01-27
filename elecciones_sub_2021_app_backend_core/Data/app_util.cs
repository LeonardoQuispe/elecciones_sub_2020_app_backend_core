using elecciones_sub_2021_app_backend_core.Models;
using Dapper;
using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using elecciones_sub_2021_app_backend_core.Interfaces;
using System.Net.Http;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class app_util: Iapp_util
    {
        private IConfiguration appSettingsInstance;
        private readonly Ic_conexion _c_conexion;

        public app_util(Ic_conexion c_conexion)
        {
            appSettingsInstance = new ConfigurationBuilder()
                                    // .SetBasePath(System.IO.Directory.GetCurrentDirectory())
                                    .AddJsonFile("appsettings.json").Build();
            this._c_conexion = c_conexion;
        }

        public async Task<AppParametros> traer_parametros()
        {
            try
            {
                AppParametros datos = new AppParametros();
                string nombreFuncion;

                nombreFuncion = "sp_app_traer_parametros";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    datos = await cnx.QueryFirstOrDefaultAsync<AppParametros>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure             
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

        
        // public async Task<byte[]> traerPlanDeGobierno()
        // {
        //     try
        //     {
        //         byte[] bytesResponseData = null;

        //         using (HttpClient client = new HttpClient())
        //         {
        //             string urlImagenActaContainer = appSettingsInstance.GetConnectionString("URLDocumentos");
        //             // string extension = MimeTypesMap.GetExtension(content_type);
        //             string url = $"{urlImagenActaContainer}";
        //             HttpResponseMessage response = client.GetAsync(url).Result;
        //             bytesResponseData = await response.Content.ReadAsByteArrayAsync();
        //         }

        //         return bytesResponseData;
        //     }
        //     catch (Exception ex)
        //     {
        //         throw ex;
        //     }
        // }

        public async Task<AppRespuestaBD> enviar_comentario(AppPostComentario datos)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                nombreFuncion = "sp_app_abm_comentario";
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                        sql: nombreFuncion,
                        commandType: CommandType.StoredProcedure,
                        param: new {
                            _nombre = datos.nombre,
                            _carnet = datos.carnet,
                            _comentario = datos.comentario,
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


        public async Task<string> actualizarSocket()
        {
            try
            {
                string bytesResponseData;

                using (HttpClient client = new HttpClient())
                {
                    string socketIoGet = appSettingsInstance.GetConnectionString("SocketIoGet");
                    HttpResponseMessage response = client.GetAsync(socketIoGet).Result;
                    bytesResponseData = await response.Content.ReadAsStringAsync();
                }
                return bytesResponseData;
            }
            catch (Exception)
            {
                return null;
                // throw ex;
            }
        }


    }
}

