using System;
using System.Threading.Tasks;
using System.Transactions;
using HeyRed.Mime;
using Microsoft.AspNetCore.Mvc;
using elecciones_sub_2021_app_backend_core.Data;
using elecciones_sub_2021_app_backend_core.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppUtilController : ControllerBase
    {
        private IWebHostEnvironment _env; 
        private readonly Iapp_util _app_util;
        private readonly Iapp_mesa _app_mesa;
        public AppUtilController(IWebHostEnvironment env, Iapp_util app_util, Iapp_mesa app_mesa)
        {
            _env = env;
            this._app_util = app_util;
            this._app_mesa = app_mesa;
        }
        [Route("prueba")]
        [HttpGet]
        public ActionResult<AppRespuestaCore> prueba()
        {

            return new OkObjectResult("TODO ESTA BIEN PANA");
        }

        [Authorize]
        [Route("traer_parametros")]
        [HttpGet]
        public async Task<ActionResult<AppRespuestaCore>> traer_parametros()
        {
            AppParametros _datos = new AppParametros();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();

            try
            {
                _datos = await this._app_util.traer_parametros();
                

                respuestaCore = new AppRespuestaCore
                {
                    status = "success",
                    response = _datos
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

        [HttpGet("traer_plan_de_gobierno")]
        public async Task<ActionResult<object>> traerPlanDeGobierno()
        {
            
            // app_conteo _app_conteo = new app_conteo();
            AppRespuestaCore respuestaCore;

            try
            {
                var webRoot = this._env.ContentRootPath;
                var pathCombine1  = Path.Combine(webRoot, "assets");
                var pathCombine2  = Path.Combine(pathCombine1, "Documentos");
                var archivo  = Path.Combine(pathCombine2, "plan_gobierno_juntos.pdf");
                byte[] fileBytes = await System.IO.File.ReadAllBytesAsync(archivo);
                
                return File(fileBytes, "application/pdf", "plan_gobierno_juntos.pdf");
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

        [HttpPost("enviar_comentario")]
        public async Task<ActionResult<AppRespuestaCore>> enviar_comentario([FromBody] AppPostComentario datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    
                    respuestaBD = await this._app_util.enviar_comentario(datos);

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

        // [Authorize]
        // [Route("aperturar_mesa")]
        // [HttpPut]
        // public async Task<ActionResult<AppRespuestaCore>> aperturar_mesa([FromBody] AppPostAperturarMesa datos)
        // {
        //     AppRespuestaCore respuestaCore = new  AppRespuestaCore();
        //     AppRespuestaBD respuestaBD = new  AppRespuestaBD();

        //     try
        //     {
        //         using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        //         {
        //             respuestaBD = await _app_mesa.aperturar_mesa(datos);
        //             if (respuestaBD.status == "error")
        //             {
        //                 respuestaCore = new AppRespuestaCore
        //                 {
        //                     status = respuestaBD.status,
        //                     response = respuestaBD.response
        //                 };
        //                 return new OkObjectResult(respuestaCore);
        //             }
        //             _transaction.Complete();
        //         }
                
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

        // [Authorize]
        // [Route("anular_mesa")]
        // [HttpPut]
        // public async Task<ActionResult<AppRespuestaCore>> anular_mesa([FromBody] AppPostAnularMesa datos)
        // {
        //     AppRespuestaCore respuestaCore = new  AppRespuestaCore();
        //     AppRespuestaBD respuestaBD = new  AppRespuestaBD();

        //     try
        //     {
        //         using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        //         {
        //             respuestaBD = await this._app_mesa.anular_mesa(datos);
        //             if (respuestaBD.status == "error")
        //             {
        //                 respuestaCore = new AppRespuestaCore
        //                 {
        //                     status = respuestaBD.status,
        //                     response = respuestaBD.response
        //                 };
        //                 return new OkObjectResult(respuestaCore);
        //             }
        //             _transaction.Complete();
        //         }
                
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

        // [Authorize]
        // [Route("limpiar_mesa")]
        // [HttpPut]
        // public async Task<ActionResult<AppRespuestaCore>> limpiar_mesa([FromBody] long idMesa)
        // {
        //     AppRespuestaCore respuestaCore = new  AppRespuestaCore();
        //     AppRespuestaBD respuestaBD = new  AppRespuestaBD();

        //     try
        //     {
        //         using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        //         {
        //             respuestaBD = await this._app_mesa.limpiar_mesa(idMesa);
        //             if (respuestaBD.status == "error")
        //             {
        //                 respuestaCore = new AppRespuestaCore
        //                 {
        //                     status = respuestaBD.status,
        //                     response = respuestaBD.response
        //                 };
        //                 return new OkObjectResult(respuestaCore);
        //             }
        //             _transaction.Complete();
        //         }
                
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



    }
}
