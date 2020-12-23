using Microsoft.AspNetCore.Authorization;
using System.Security.Claims;
using Microsoft.AspNetCore.Mvc;

namespace juntos_app_backend_core.Controllers
{
    [ApiController]
    // [Authorize]
    [Route("api/[controller]")]
    public class PruebaController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
        };

        //private readonly ILogger<PruebaController> _logger;

        //public PruebaController(ILogger<PruebaController> logger)
        //{
        //    _logger = logger;
        //}

        [HttpGet]
        public ActionResult<object> Get()
        {
            // string cuenta = User.FindFirst(ClaimTypes.Name).Value;
            // string id = User.FindFirst(ClaimTypes.NameIdentifier).Value;
            return new OkObjectResult("TODO ESTA BIEN: " + "cuenta" + "-" + "id" );
        }
    }
}
