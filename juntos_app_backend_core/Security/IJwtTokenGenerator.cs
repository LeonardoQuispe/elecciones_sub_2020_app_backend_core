
using System.Threading.Tasks;

namespace juntos_app_backend_core.Security
{
    public interface IJwtTokenGenerator
    {
        Task<string> CreateToken(string username);
    }
}

