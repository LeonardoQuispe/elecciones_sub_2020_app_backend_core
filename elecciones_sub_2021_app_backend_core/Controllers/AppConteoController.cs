using System;
using System.IO;
using System.Threading.Tasks;
using System.Transactions;
using HeyRed.Mime;
using Microsoft.AspNetCore.Mvc;
using elecciones_sub_2021_app_backend_core.Data;
using elecciones_sub_2021_app_backend_core.Models;
using elecciones_sub_2021_app_backend_core.Services;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.Collections.Generic;

namespace elecciones_sub_2021_app_backend_core.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppConteoController : ControllerBase
    {
        // private readonly IAzureBlobService _azureBlobService;
        private IWebHostEnvironment _env; 

        public AppConteoController(IWebHostEnvironment env)
        {
            _env = env;
        }
        // public AppConteoController(IAzureBlobService azureBlobService)
        // {
        //     _azureBlobService = azureBlobService;
        // }

        [Authorize]
        [HttpPost("guardar")]
        public async Task<ActionResult<AppRespuestaCore>> guardar([FromForm] AppPostConteoPartido datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_conteo _app_conteo = new app_conteo();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    
                    // respuestaBD = await _app_conteo.guardar(datos, this._azureBlobService);
                    respuestaBD = await _app_conteo.guardar(datos, this._env);

                    if (respuestaBD.status == "error")
                    {
                        respuestaCore = new AppRespuestaCore
                        {
                            status = respuestaBD.status,
                            response = respuestaBD.response
                        };
                        return new OkObjectResult(respuestaCore);
                    }
                    _transaction.Complete();
                }
                
                respuestaCore = new AppRespuestaCore
                {
                    status = respuestaBD.status,
                    response = respuestaBD.response
                };
                return new OkObjectResult(respuestaCore);
            }
            catch (Exception ex)
            {
                respuestaCore = new AppRespuestaCore
                {
                    status = "error",
                    response = ex.Message
                };

                return new OkObjectResult(respuestaCore);
            }
        }

        // [Route("valida_conteo")]
        // [HttpPost]
        // public async Task<ActionResult<AppRespuestaCore>> valida_conteo([FromForm] AppPostConteoPartido datos)
        // {
        //     AppRespuestaCore respuestaCore = new  AppRespuestaCore();
        //     AppRespuestaBD respuestaBD = new  AppRespuestaBD();
        //     app_conteo _app_conteo = new app_conteo();

        //     try
        //     {
        //         respuestaBD = await _app_conteo.valida_conteo(datos);
                
        //         respuestaCore = new AppRespuestaCore
        //         {
        //             status = respuestaBD.status,
        //             response = respuestaBD.response
        //         };
        //         return new OkObjectResult(respuestaCore);
        //     }
        //     catch (Exception ex)
        //     {
        //         respuestaCore = new AppRespuestaCore
        //         {
        //             status = "error",
        //             response = ex.Message
        //         };

        //         return new OkObjectResult(respuestaCore);
        //     }
        // }

        [HttpGet("traer_imagen_acta")]
        public async Task<ActionResult<object>> traer_imagen_acta(string nombre_imagen_acta)
        {
            app_conteo _app_conteo = new app_conteo();
            AppRespuestaCore respuestaCore;

            try
            {
                var webRoot = this._env.ContentRootPath;
                var pathCombine  = Path.Combine(webRoot, "assets");
                var uploads  = Path.Combine(pathCombine, "Actas");
                var filePath = Path.Combine(uploads, nombre_imagen_acta);
                byte[] fileBytes = await System.IO.File.ReadAllBytesAsync(filePath);

                // byte[] _datos = await _app_conteo.traer_imagen_acta(nombre_imagen_acta);
                string mimeType = MimeTypesMap.GetMimeType(nombre_imagen_acta);
                
                return File(fileBytes, mimeType, nombre_imagen_acta);              
                // return File(_datos, mimeType, nombre_imagen_acta);              
            }
            catch (Exception ex)
            {
                respuestaCore = new AppRespuestaCore
                {
                    status = "error",
                    response = ex.Message
                };

                return new OkObjectResult(respuestaCore);
            }
        }

        // [Route("traer_imagen_acta")]
        // [HttpPost]
        // public async Task<ActionResult<object>> traer_imagen_acta([FromBody] long id_imagen_acta)
        // {
        //     app_conteo _app_conteo = new app_conteo();

        //     try
        //     {
        //         AppImagenActa _datos = await _app_conteo.traer_imagen_acta(id_imagen_acta);
        //         if (_datos != null)
        //         {
        //             MemoryStream memoryStream = new MemoryStream(_datos.archivo);
        //             return File(memoryStream, _datos.content_type, _datos.nombre);
        //         } 
        //         else 
        //         {
        //             return new OkObjectResult(null);
        //         }
                
        //     }
        //     catch (Exception)
        //     {
        //         return new OkObjectResult(null);
        //     }
        // }

        
        [Route("listado_partidos")]
        [HttpGet]
        public async Task<ActionResult<AppRespuestaCore>> listado_partidos()
        {
            IEnumerable<Partido> arrayDatos = new Partido[] { };;
            app_conteo _app_conteo = new app_conteo();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();

            try
            {
                arrayDatos = await _app_conteo.listado_partidos();

                respuestaCore = new AppRespuestaCore
                {
                    status = "success",
                    response = arrayDatos
                };
                return new OkObjectResult(respuestaCore);
            }
            catch (Exception ex)
            {
                respuestaCore = new AppRespuestaCore
                {
                    status = "error",
                    response = ex.Message
                };

                return new OkObjectResult(respuestaCore);
            }
        }
        [HttpGet("traer_logo_partido/{nombre_logo_partido}")]
        public async Task<ActionResult<object>> traer_logo_partido(string nombre_logo_partido)
        {
            app_conteo _app_conteo = new app_conteo();
            AppRespuestaCore respuestaCore;

            try
            {
                var webRoot = this._env.ContentRootPath;
                var pathCombine  = Path.Combine(webRoot, "assets");
                var uploads  = Path.Combine(pathCombine, "LogosPartidos");
                var filePath = Path.Combine(uploads, nombre_logo_partido);
                byte[] fileBytes = await System.IO.File.ReadAllBytesAsync(filePath);

                // byte[] _datos = await _app_conteo.traer_imagen_acta(nombre_imagen_acta);
                string mimeType = MimeTypesMap.GetMimeType(nombre_logo_partido);
                
                return File(fileBytes, mimeType, nombre_logo_partido);              
                // return File(_datos, mimeType, nombre_imagen_acta);              
            }
            catch (Exception ex)
            {
                respuestaCore = new AppRespuestaCore
                {
                    status = "error",
                    response = ex.Message
                };

                return new OkObjectResult(respuestaCore);
            }
        }




    }
}
