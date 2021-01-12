using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Iapp_adm_usuario
    {
        public Task<AppRespuestaCore> login(string usuario, string contrasena);
        public Task<AsignarUsuario> traer_usuario_mesa(long id_mesa);
        public Task<AppRespuestaBD> registrar_usuario_recinto(AsignarUsuario datos);
        public Task<AppRespuestaBD> asignar_usuario_mesa(AsignarUsuario datos);
        public Task<Usuario> validar(long codigo, string cuenta, string contrasena);
    }
}
