namespace juntos_app_backend_core.Data
{ 
    /// <summary>
    /// Contiene los ID de los PARTIDOS
    /// </summary>
    public enum ArrayPartidos
    {
        COMUNIDAD_CIUDADANA = 1,
        FRENTE_PARA_LA_VICTORIA = 2,
        MOVIMIENTO_TERCER_SISTEMA = 3,
        UNIDAD_CIVICA_SOLIDARIDAD = 4,
        MOVIMIENTO_AL_SOCIALISMO = 5,
        BOLIVIA_DICE_NO = 6,
        PARTIDO_DEMOCRATA_CRISTIANO = 7,
        MOVIMIENTO_NACIONALISTA_REVOLUCIONARIO = 8,
        PARTIDO_DE_ACCIÓN_NACIONAL_BOLIVIANO = 9,
        NULOS = 10,
        BLANCOS = 11,
    } 
    /// <summary>
    /// Contiene los ID de las PLATAFORMAS
    /// </summary>
    public enum ArrayPlataforma
    {
        App_Movil = 1,
        Web = 2,
    } 
    /// <summary>
    /// Contiene los ID de lol ROLES
    /// </summary>
    public enum ArrayRolUsuario
    {
        JefeRecinto = 2,
        DelegadoMesa = 3,
        JefeRecintoEXTERIOR = 8,
        DelegadoMesaEXTERIOR = 9
    } 
    public enum EstadoMesaEnum
    {
        PorLlenar = 1,
        Llenada = 2,
        Anulada = 3,
    } 
}