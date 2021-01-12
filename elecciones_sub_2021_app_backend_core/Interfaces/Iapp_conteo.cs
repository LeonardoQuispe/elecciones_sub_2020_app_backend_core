using System.Collections.Generic;
using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;
using Microsoft.AspNetCore.Hosting;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Iapp_conteo
    {
        public Task<AppRespuestaBD> guardar(AppPostConteoPartido datos, IWebHostEnvironment env);
        public Task<byte[]> traer_imagen_acta(string nombre_imagen_acta);
        public Task<IEnumerable<Partido>> listado_partidos();
    }
}
