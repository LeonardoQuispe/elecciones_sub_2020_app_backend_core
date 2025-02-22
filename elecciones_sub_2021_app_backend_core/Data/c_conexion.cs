﻿using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using Npgsql;
using elecciones_sub_2021_app_backend_core.Interfaces;

namespace elecciones_sub_2021_app_backend_core.Data
{
    public class c_conexion: Ic_conexion
    {
        private IConfiguration appSettingsInstance;

        public c_conexion()
        {
            appSettingsInstance = new ConfigurationBuilder()
                                    // .SetBasePath(Directory.GetCurrentDirectory())
                                    .AddJsonFile("appsettings.json").Build();
        }

        //public IDbConnection conexionSQL
        //{
        //    get
        //    {
        //        return new SqlConnection(appSettingsInstance.GetConnectionString("CadenaConexionSQL"));

        //    }
        //}

        public IDbConnection conexionPGSQL
        {
            get
            {
                return new NpgsqlConnection(appSettingsInstance.GetConnectionString("CadenaConexionPGSQL"));

            }
        }

    }
}
