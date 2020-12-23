using System;
using System.Collections.Generic;

namespace juntos_app_backend_core.Models
{
    public class AppPostPartido
    {
        public long id_det_conteo_partido { get; set; }
        public long id_partido { get; set; }
        public int total_voto { get; set; }
    }
}