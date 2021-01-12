using System;
using System.Threading.Tasks;
using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using elecciones_sub_2021_app_backend_core.Data;
using elecciones_sub_2021_app_backend_core.Models;
using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class AppMesaController : ControllerBase
    {
        private readonly Iapp_mesa _app_mesa;

        public AppMesaController(Iapp_mesa app_mesa)
        {
            this._app_mesa = app_mesa;
        }

        [Authorize]
        [Route("listar_mesa_recinto")]
        [HttpGet]
        public async Task<ActionResult<AppRespuestaCore>> listar_mesa_recinto()
        {
            AppMesaRecintoListado _datos = new AppMesaRecintoListado();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            string idUsuario = User.FindFirst(ClaimTypes.NameIdentifier).Value;

            try
            {
                _datos = await this._app_mesa.listar_mesa_recinto(long.Parse(idUsuario));

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

        [Route("aperturar_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> aperturar_mesa([FromBody] AppPostAperturarMesa datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await this._app_mesa.aperturar_mesa(datos);
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

        [Route("anular_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> anular_mesa([FromBody] AppPostAnularMesa datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await this._app_mesa.anular_mesa(datos);
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

        [Route("limpiar_mesa")]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> limpiar_mesa(long idMesa)
        // public async Task<ActionResult<AppRespuestaCore>> limpiar_mesa([FromBody] long idMesa)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await this._app_mesa.limpiar_mesa(idMesa);
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

        [Route("traer_mesa_de_usuario")]
        [HttpGet]
        public async Task<ActionResult<AppRespuestaCore>> traer_mesa_de_usuario(long id_mesa)
        {
            AppTraerMesaConteoUsuario _datos = new AppTraerMesaConteoUsuario();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            string idUsuario = User.FindFirst(ClaimTypes.NameIdentifier).Value;

            try
            {
                _datos = await this._app_mesa.traer_mesa_de_usuario(long.Parse(idUsuario), id_mesa);

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



    }
}
