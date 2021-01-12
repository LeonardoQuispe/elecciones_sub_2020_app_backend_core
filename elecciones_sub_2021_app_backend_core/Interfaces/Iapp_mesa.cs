using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Iapp_mesa
    {
        public Task<AppMesaRecintoListado> listar_mesa_recinto(long id_usuario);
        public Task<AppRespuestaBD> guardar(AppPostMesa datos);
        public Task<AppRespuestaBD> aperturar_mesa(AppPostAperturarMesa datos);
        public Task<AppRespuestaBD> anular_mesa(AppPostAnularMesa datos);
        public Task<AppRespuestaBD> limpiar_mesa(long idMesa);
        public Task<AppTraerMesaConteoUsuario> traer_mesa_de_usuario(long id_usuario, long id_mesa);
    }
}
