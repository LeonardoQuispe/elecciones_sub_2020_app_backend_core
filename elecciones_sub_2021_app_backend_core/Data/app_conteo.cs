using elecciones_sub_2021_app_backend_core.Models;
using Dapper;
using System;
using System.Data;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System.IO;
//using HeyRed.Mime;
using System.Net.Http;
using elecciones_sub_2021_app_backend_core.Services;
using Microsoft.AspNetCore.Hosting;
using System.Collections.Generic;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class app_conteo: Iapp_conteo
    {
        private IConfiguration appSettingsInstance;
        private readonly Iapp_mesa _app_mesa;
        private readonly Iapp_imagen_acta _app_imagen_acta;
        private readonly Ic_conexion _c_conexion;

        public app_conteo(Iapp_mesa app_mesa, Iapp_imagen_acta app_imagen_acta, Ic_conexion c_conexion)
        {            
            appSettingsInstance = new ConfigurationBuilder()
                                    // .SetBasePath(Directory.GetCurrentDirectory())
                                    .AddJsonFile("appsettings.json").Build();
            this._app_mesa = app_mesa;
            this._app_imagen_acta = app_imagen_acta;
            this._c_conexion = c_conexion;
        }
        // public async Task<AppRespuestaBD> guardar(AppPostConteoPartido datos, IAzureBlobService azureBlobService)
        public async Task<AppRespuestaBD> guardar(AppPostConteoPartido datos, IWebHostEnvironment env)
        {
            try
            {
                AppRespuestaBD respuesta = new AppRespuestaBD();
                string nombreFuncion;

                if (datos.id_rol == (long)ArrayRolUsuario.JefeRecinto || datos.id_rol == (long)ArrayRolUsuario.JefeRecintoEXTERIOR)
                {
                    datos.mesa.bandera_validado_jefe_recinto = true;
                } 
                else
                {
                    datos.mesa.bandera_validado_jefe_recinto = false;
                }
                datos.mesa.id_estado_mesa = (long)EstadoMesaEnum.Llenada;
                respuesta = await this._app_mesa.guardar(datos.mesa);
                if (respuesta.status != "success")
                {
                    return respuesta;
                }

                if (datos.id_imagen_acta == 0)
                {
                    respuesta = await this._app_imagen_acta.guardar(datos.foto_acta, datos.mesa.id_mesa);
                } 
                else 
                {
                    respuesta = await this._app_imagen_acta.modificar(datos.foto_acta, datos.mesa.id_mesa);
                }
                if (respuesta.status != "success")
                {
                    return respuesta;
                }
                
                
                var webRootPath = env.ContentRootPath;
                var combinePath1  = Path.Combine(webRootPath, "assets");
                if (!Directory.Exists(combinePath1))
                {
                    Directory.CreateDirectory(combinePath1);
                }
                var combinePath2  = Path.Combine(combinePath1, "Actas");
                if (!Directory.Exists(combinePath2))
                {
                    Directory.CreateDirectory(combinePath2);
                }
                var filePath = Path.Combine(combinePath2, $"{datos.mesa.id_mesa.ToString()}.png");
                using (var fileStream = new FileStream(filePath, FileMode.Create)) 
                {
                    await datos.foto_acta.CopyToAsync(fileStream);
                }
                    
                // bool imagenGuardada = await azureBlobService.UploadAsync(datos.foto_acta, $"{datos.mesa.id_mesa.ToString()}.png", "image/png");
                // if (!imagenGuardada)
                // {
                //     return new AppRespuestaBD{
                //         status = "error",
                //         response = "La imagen del acta no pudo ser guardada, por favor, intente más tarde",
                //     };
                // }

                int votosValidos = 0;
                int votosNulos = 0;
                int votosBlancos = 0;            
                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    foreach (AppPostConteo conteo in datos.conteos)
                    {
                        int accion = 0;
                        foreach (AppPostPartido partido in conteo.votosPartidos)
                        {
                            if (partido.id_partido == (long)ArrayPartidos.NULOS) {
                                votosNulos = partido.total_voto;
                            } 
                            else if (partido.id_partido == (long)ArrayPartidos.BLANCOS) {
                                votosBlancos = partido.total_voto;
                            } 
                            else {
                                votosValidos += partido.total_voto;
                            }
                        }
                        if (conteo.id == 0)
                        {
                            accion = 1;
                        } else {
                            accion = 2;
                        }
                        nombreFuncion = "sp_app_abm_conteo";    
                        respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                            sql: nombreFuncion,
                            commandType: CommandType.StoredProcedure,
                            param: new {
                                accion = accion,
                                _id = conteo.id,
                                _votos_validos = votosValidos,
                                _votos_nulos = votosNulos,
                                _votos_blancos = votosBlancos,
                                _id_mesa = datos.mesa.id_mesa,
                                _id_tipo_conteo = conteo.id_tipo_conteo,
                                _id_plataforma = (long)ArrayPlataforma.App_Movil,
                            }                  
                        );
                        if (respuesta.status != "success")
                        {
                            return respuesta;
                        }                        

                        long idConteoAux = long.Parse(respuesta.numsec);
                        nombreFuncion = "sp_app_abm_det_conteo_partido";
                        foreach (AppPostPartido partido in conteo.votosPartidos)
                        {
                            respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
                                sql: nombreFuncion,
                                commandType: CommandType.StoredProcedure,
                                param: new
                                {
                                    accion = accion,
                                    _id = partido.id_det_conteo_partido,
                                    _id_conteo = idConteoAux,
                                    _id_partido = partido.id_partido,
                                    _total_voto = partido.total_voto
                                }
                            );
                            if (respuesta.status != "success")
                            {
                                return respuesta;
                            }
                        }
                    }
                    cnx.Close();
                }

                return respuesta;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }   
        // public async Task<AppRespuestaBD> valida_conteo(AppPostConteoPartido datos)
        // {
        //     try
        //     {
        //         AppRespuestaBD respuesta = new AppRespuestaBD();
        //         // string nombreFuncion = "sp_app_valida_conteo";

        //         // int votosValidos = 0;
        //         // int votosNulos = 0;
        //         // int votosBlancos = 0;
        //         // foreach (AppPostPartido partido in datos.votosPartidos)
        //         // {
        //         //     if (partido.id == (long)ArrayPartidos.NULOS) {
        //         //         votosNulos = partido.total_voto;
        //         //     } 
        //         //     else if (partido.id == (long)ArrayPartidos.BLANCOS) {
        //         //         votosBlancos = partido.total_voto;
        //         //     } 
        //         //     else {
        //         //         votosValidos += partido.total_voto;
        //         //     }
        //         // }

        //         // using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
        //         // {
        //         //     respuesta = await cnx.QuerySingleOrDefaultAsync<AppRespuestaBD>(
        //         //         sql: nombreFuncion,
        //         //         commandType: CommandType.StoredProcedure,
        //         //         param: new {
		// 		// 			_id = datos.conteos.id,
		// 		// 			_votos_validos = votosValidos,
		// 		// 			_votos_nulos = votosNulos,
		// 		// 			_votos_blancos = votosBlancos,
        //         //             _observacion = datos.conteos.observacion,
        //         //             _id_mesa = datos.conteos.id_mesa,
        //         //             _id_tipo_conteo = datos.conteos.id_tipo_conteo,
        //         //             _id_plataforma = (long)ArrayPlataforma.App_Movil,
        //         //         }                  
        //         //     );
        //         // }

        //         return respuesta;
        //     }
        //     catch (Exception ex)
        //     {
        //         throw ex;
        //     }
        // }

        public async Task<byte[]> traer_imagen_acta(string nombre_imagen_acta)
        {
            try
            {
                byte[] bytesResponseData = null;

                using (HttpClient client = new HttpClient())
                {
                    string urlImagenActaContainer = appSettingsInstance.GetConnectionString("URLImagenesActa");
                    // string extension = MimeTypesMap.GetExtension(content_type);
                    string url = $"{urlImagenActaContainer}{nombre_imagen_acta}";
                    HttpResponseMessage response = client.GetAsync(url).Result;
                    bytesResponseData = await response.Content.ReadAsByteArrayAsync();
                }

                return bytesResponseData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        
        // public async Task<AppImagenActa> traer_imagen_acta(long id_imagen_acta)
        // {
        //     try
        //     {
        //         AppImagenActa datos = new AppImagenActa();
        //         string nombreFuncion = "sp_app_traer_imagen_acta";

        //         using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
        //         {
        //             datos = await cnx.QueryFirstOrDefaultAsync<AppImagenActa>(
        //                 sql: nombreFuncion,
        //                 commandType: CommandType.StoredProcedure,
        //                 param: new {
        //                     _id_imagen_acta = id_imagen_acta,
        //                 }                  
        //             );
        //         }

        //         return datos;
        //     }
        //     catch (Exception ex)
        //     {
        //         throw ex;
        //     }
        // }




        
        public async Task<IEnumerable<Partido>> listado_partidos(long idMesa, long idTipoConteo, long idMunicipio)
        {
            try
            {
                IEnumerable<Partido> arrayDatos = new Partido[] { };

                using (IDbConnection cnx =  _c_conexion.conexionPGSQL)
                {
                    arrayDatos = await cnx.QueryAsync<Partido>(
                        sql: "sp_app_listado_partidos",
                        param: new {
                            _id_mesa = idMesa,
                            _id_tipo_conteo = idTipoConteo,
                            _id_municipio = idMunicipio,
                        },
                        commandType: CommandType.StoredProcedure
                    );
                    cnx.Close();
                }

                return arrayDatos;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }






    }

}

