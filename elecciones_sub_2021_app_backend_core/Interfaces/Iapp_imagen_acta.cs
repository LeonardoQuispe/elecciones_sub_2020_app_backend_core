using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;
using Microsoft.AspNetCore.Http;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Iapp_imagen_acta
    {
        public Task<AppRespuestaBD> guardar(IFormFile imagen, long idMesa);
        public Task<AppRespuestaBD> modificar(IFormFile imagen, long idMesa);
        public Task<object> traer_imagen_acta();
    }
}
