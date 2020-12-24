using System;
using System.Collections.Generic;

namespace elecciones_sub_2021_app_backend_core.Models
{
    public class AppPostPartido
    {
        public long id_det_conteo_partido { get; set; }
        public long id_partido { get; set; }
        public int total_voto { get; set; }
    }

    public class Partido
    {
        public long id { get; set; }
        public string nombre { get; set; }
        public string color { get; set; }
        public string logo { get; set; }

    }
}