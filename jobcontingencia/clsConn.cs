using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OracleClient;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Configuration;

namespace jobcontingencia
{
    class clsConn
    {
        public static OracleConnection ConectarBD()
        {
            string connection = ConfigurationManager.ConnectionStrings["confuturo"].ToString();

            return new OracleConnection(connection);
        }
    }
}
