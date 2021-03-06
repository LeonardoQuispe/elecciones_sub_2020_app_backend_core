using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Iapp_util

    {
        public Task<AppParametros> traer_parametros();
        public Task<AppRespuestaBD> enviar_comentario(AppPostComentario datos);
        public Task<string> actualizarSocket();
    }
}
