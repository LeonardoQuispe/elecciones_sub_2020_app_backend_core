using System;

namespace elecciones_sub_2021_app_backend_core.Models
{
    public class AppParametros
    {
        public string fecha_hora_servidor { get; set; }
    }
    public class AppPostComentario
    {
        public string nombre { get; set; }
        public string carnet { get; set; }
        public string comentario { get; set; }
    }
}