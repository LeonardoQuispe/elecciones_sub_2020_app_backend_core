using System;
using System.Collections.Generic;
using Microsoft.AspNetCore.Http;
// using Microsoft.AspNetCore.Http;
namespace juntos_app_backend_core.Models
{
    public class AppPostConteoPartido 
    {
        public long id_usuario { get; set; }
        public long id_rol { get; set; }
        public long id_imagen_acta { get; set; }
        public AppPostMesa mesa { get; set; }
        public IFormFile foto_acta { get; set; }
        
        public IEnumerable<AppPostConteo> conteos { get; set; }
    }

    public class AppPostConteo
    {
        public long id { get; set; }
        public long id_tipo_conteo { get; set; }
        public IEnumerable<AppPostPartido> votosPartidos { get; set; }
    }
    public class AppPostTraerConteoMesa
    {
        public long id_mesa { get; set; }
        public long id_tipo_conteo { get; set; }
    }

    // public class AppTraerConteoMesa
    // {
    //     public AppTraerConteo conteo { get; set; }
    //     public IEnumerable<AppTraerDetConteoPartido> votosPartidos { get; set; }
    // }
    public class AppTraerConteo
    {
        public long id { get; set; }
        public long id_tipo_conteo { get; set; }
        public IEnumerable<AppTraerDetConteoPartido> votosPartidos { get; set; }
    }
    public class AppTraerDetConteoPartido
    {
        public long id_det_conteo_partido { get; set; }
        public long id_partido { get; set; }
        public int total_voto { get; set; }
    }
}