using System.Data;
using System.Threading.Tasks;
using elecciones_sub_2021_app_backend_core.Models;

namespace elecciones_sub_2021_app_backend_core.Interfaces
{
    public interface Ic_conexion
    {
        public IDbConnection conexionPGSQL{get;}
    }
}
