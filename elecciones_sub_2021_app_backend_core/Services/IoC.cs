using elecciones_sub_2021_app_backend_core.Data;
using elecciones_sub_2021_app_backend_core.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace elecciones_sub_2021_app_backend_core.Services
{
    public static class IoC
    {
        public static IServiceCollection AddDependency(this IServiceCollection services) {
            services.AddSingleton<Iapp_conteo, app_conteo>();
            services.AddSingleton<Iapp_imagen_acta, app_imagen_acta>();
            services.AddSingleton<Iapp_mesa, app_mesa>();
            services.AddSingleton<Iapp_adm_usuario, app_adm_usuario>();
            services.AddSingleton<Iapp_util, app_util>();
            services.AddSingleton<Ic_conexion, c_conexion>();
            return services;
        }
    }
}
