using System;
using System.Threading.Tasks;
using System.Transactions;
using HeyRed.Mime;
using Microsoft.AspNetCore.Mvc;
using juntos_app_backend_core.Data;
using juntos_app_backend_core.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace juntos_app_backend_core.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppUtilController : ControllerBase
    {
        private IWebHostEnvironment _env; 
        public AppUtilController(IWebHostEnvironment env)
        {
            _env = env;
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
            app_util _app_util = new app_util();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();

            try
            {
                _datos = await _app_util.traer_parametros();
                

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
            
            app_conteo _app_conteo = new app_conteo();
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
            app_util _app_util = new app_util();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    
                    respuestaBD = await _app_util.enviar_comentario(datos);

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

        [Authorize]
        [Route("aperturar_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> aperturar_mesa([FromBody] AppPostAperturarMesa datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_mesa _app_mesa = new app_mesa();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await _app_mesa.aperturar_mesa(datos);
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

        [Authorize]
        [Route("anular_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> anular_mesa([FromBody] AppPostAnularMesa datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_mesa _app_mesa = new app_mesa();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await _app_mesa.anular_mesa(datos);
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

        [Authorize]
        [Route("limpiar_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> limpiar_mesa([FromBody] long idMesa)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_mesa _app_mesa = new app_mesa();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await _app_mesa.limpiar_mesa(idMesa);
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



    }
}
