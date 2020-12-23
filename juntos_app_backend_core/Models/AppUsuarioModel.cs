using Newtonsoft.Json;

namespace juntos_app_backend_core.Models
{
    public class AppUsuarioPost
    {
        public string usuario { get; set; }
        public string contrasena { get; set; }
        public string version { get; set; }
    }

    public class UsuarioLogin
    {
        public long id { get; set; }
        public string cuenta { get; set; }
        public long id_rol { get; set; }
    }

    public class AsignarUsuario
    {
        public long id { get; set; }
        public string cuenta { get; set; }
        public dynamic contrasena { get; set; }
        public string nombre { get; set; }
        public string apellido_paterno { get; set; }
        public string apellido_materno { get; set; }
        public string carnet_identidad { get; set; }
        public string telefono1 { get; set; }
        public string telefono2 { get; set; }
        public string correo { get; set; }
    }
    public class Usuario
    {
        public long id { get; set; }
        public string nombre { get; set; }
        public string cuenta { get; set; }
        public string contrasena { get; set; }
        public short tipo { get; set; }
        public string genero { get; set; }
        [JsonIgnore]
        public string nombre_rol { set; get; }
        [JsonIgnore]
        public byte[] hash { set; get; }
        [JsonIgnore]
        public string salt { set; get; }

        public long id_rol { get; set; }
        public string estado { get; set; }
    }
}