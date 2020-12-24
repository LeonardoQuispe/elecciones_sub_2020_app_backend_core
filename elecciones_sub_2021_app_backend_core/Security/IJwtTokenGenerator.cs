
using System.Threading.Tasks;

namespace elecciones_sub_2021_app_backend_core.Security
{
    public interface IJwtTokenGenerator
    {
        Task<string> CreateToken(string username);
    }
}

