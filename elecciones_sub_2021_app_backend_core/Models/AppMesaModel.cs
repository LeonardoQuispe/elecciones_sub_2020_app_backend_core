using System;
using System.Collections.Generic;

namespace elecciones_sub_2021_app_backend_core.Models
{
    public class AppMesaRecintoListado
    {
        public string nombre_recinto { get; set; }
        public IEnumerable<AppMesaListado> mesaListado { get; set; }
    }

    public class AppMesaListado
    {
        public long id { get; set; }
        public int numero_mesa { get; set; }
        public bool bandera_usuario_asignado { get; set; }
        public bool bandera_apertura { get; set; }
        public string fecha_hora_apertura { get; set; }
        public bool bandera_validado_jefe_recinto { get; set; }
        public long id_estado_mesa { get; set; }
    }
    public class AppPostMesa
    {
        public long id_mesa { get; set; }
        public string observacion_conteo { get; set; }
        public long? id_estado_mesa { get; set; }
        public bool? bandera_validado_jefe_recinto { get; set; }
    }
    public class AppPostAnularMesa
    {
        public long id_mesa { get; set; }
        public string observacion { get; set; }
    }
    public class AppPostAperturarMesa
    {
        public long id_mesa { get; set; }
        public string fecha_hora_apertura { get; set; }
    }

    public class AppTraerMesaConteoUsuario
    {
        public AppMesaDeUsuario mesaDeUsuario { get; set; }
        public IEnumerable<AppTraerConteo> conteos { get; set; }
    }
    public class AppMesaDeUsuario
    {
        public long id { get; set; } 
        public int numero_mesa { get; set; } 
        public bool bandera_usuario_asignado { get; set; } 
        public bool bandera_apertura { get; set; } 
        public string fecha_hora_apertura { get; set; } 
        public bool bandera_validado_jefe_recinto { get; set; } 
        public int id_estado_mesa { get; set; } 
        public string nombre_imagen_acta { get; set; } 
        public string telefono_centro_computo { get; set; }
        public string id_recinto { get; set; }
        public string nombre_recinto { get; set; }
        public string observacion_conteo { get; set; }
        public long? id_imagen_acta { get; set; }
        public string imagen_acta_content_type { get; set; }
        public int habilitados { get; set; }
    }
}