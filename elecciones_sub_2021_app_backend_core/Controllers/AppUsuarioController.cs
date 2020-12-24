using System;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.Extensions.Configuration;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using elecciones_sub_2021_app_backend_core.Data;
using elecciones_sub_2021_app_backend_core.Models;
using Microsoft.IdentityModel.Tokens;

namespace elecciones_sub_2021_app_backend_core.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AppUsuarioController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public AppUsuarioController(IConfiguration configuration) {
            _configuration = configuration;
        }
        [Route("login")]
        [HttpPost]
        public async Task<ActionResult<AppRespuestaCore>> login([FromBody]AppUsuarioPost usuario)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            app_adm_usuario _app_adm_usuario = new app_adm_usuario();

            try
            {
                AppRespuestaCore _usuarioLogin = await _app_adm_usuario.login(usuario.usuario, usuario.contrasena);
                if (_usuarioLogin.status == "success") { 
                    _usuarioLogin.token =  GenerateToken(_usuarioLogin.response);
                }
                return new OkObjectResult(_usuarioLogin);
                // return new OkObjectResult("HOLA MUNDO");
            }
            catch (Exception ex)
            {
                respuestaCore = new AppRespuestaCore
                {
                    status = "error",
                    response = ex.Message,
                };
                return new OkObjectResult(respuestaCore);
            }
        }

        [Route("traer_usuario_mesa")]
        [Authorize]
        [HttpGet]
        public async Task<ActionResult<AppRespuestaCore>> traer_usuario_mesa(long id_mesa)
        {
            AsignarUsuario _datos = new AsignarUsuario{};
            app_adm_usuario _app_adm_usuario = new app_adm_usuario();
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();

            try
            {
                _datos = await _app_adm_usuario.traer_usuario_mesa(id_mesa);
                if (_datos != null)
                {
                    _datos.contrasena = Encoding.UTF8.GetString(_datos.contrasena, 0, _datos.contrasena.Length);
                }

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

        [Route("registrar_usuario_recinto")]
        [Authorize]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> registrar_usuario_recinto([FromBody] AsignarUsuario datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_adm_usuario _app_adm_usuario = new app_adm_usuario();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await _app_adm_usuario.registrar_usuario_recinto(datos);
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

        [Route("asignar_usuario_mesa")]
        [Authorize]
        [HttpPut]
        public async Task<ActionResult<AppRespuestaCore>> asignar_usuario_mesa([FromBody] AsignarUsuario datos)
        {
            AppRespuestaCore respuestaCore = new  AppRespuestaCore();
            AppRespuestaBD respuestaBD = new  AppRespuestaBD();
            app_adm_usuario _app_adm_usuario = new app_adm_usuario();

            try
            {
                using (TransactionScope _transaction = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
                {
                    respuestaBD = await _app_adm_usuario.asignar_usuario_mesa(datos);
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

        private string GenerateToken(UsuarioLogin user)
        {
            var claims = new Claim[]
            {
                new Claim(ClaimTypes.Name, user.cuenta),
                new Claim(ClaimTypes.NameIdentifier, user.id.ToString()),
                new Claim(ClaimTypes.Role, user.id_rol.ToString()),
                new Claim(JwtRegisteredClaimNames.Nbf, new DateTimeOffset(DateTime.Now).ToUnixTimeSeconds().ToString()),
                new Claim(JwtRegisteredClaimNames.Exp, new DateTimeOffset(DateTime.Now.AddDays(1)).ToUnixTimeSeconds().ToString()),
            };

            // Generamos el Token
            var token = new JwtSecurityToken
            (
                issuer: _configuration["ApiAuth:Issuer"],
                audience: _configuration["ApiAuth:Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddDays(1),
                notBefore: DateTime.UtcNow,
                signingCredentials: new SigningCredentials(new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(_configuration["ApiAuth:SecretKey"])),
                        SecurityAlgorithms.HmacSha256)
            );


            return new JwtSecurityTokenHandler().WriteToken(token);
        }


    }
}
