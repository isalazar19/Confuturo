using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.OracleClient;
using System.Data;
using System.IO;
using System.Windows.Forms;

namespace jobcontingencia
{
    class Program
    {
        static DateTime fechaSistema = DateTime.Now;
        static string mensaje = string.Empty;
        //static string oradb = "Data Source=PREVQA2;User Id=pensiones;Password=pensiones;";
        static void Main(string[] args)
        {
            insert_log("***Inicio Proceso Generación Contingencia...");
            int ll_es_dia_contingencia;
            bool proc1;
            ll_es_dia_contingencia = ultimo_dia_habil_mes();
            if (ll_es_dia_contingencia > 0)
            {
                //ejecutar SP_CT_GEN_AUT_ALL
                proc1 = ejecuta_procedure();
                if (proc1)
                {
                    /* Ejecutar contingencia.exe */
                    ejecutar_programa();
                }
            }
            else
            {
                insert_log("No es día de ejecución");
            }
            insert_log("***Fin Proceso Generación Contingencia...");
        }

        #region LOG
        public static void insert_log(string mensaje)
        {
            System.Threading.Thread.Sleep(1000);

            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();
                string query = string.Empty;

                if (mensaje.Contains('\''))
                    mensaje = mensaje.Replace((char)39, ' ');

                query = "INSERT INTO pensiones.CONTINGENCIA_LOG(FECHA_LOG, DESCRIPCION_LOG) ";
                query += "VALUES(";
                query += "to_Date(to_char(sysdate, 'dd/mm/yyyy HH24:mi:ss'), 'dd/mm/yyyy HH24:mi:ss'),";
                query += "'" + mensaje + "')";

                OracleCommand cmd = new OracleCommand(query, conn);
                cmd.ExecuteNonQuery();
            }
            catch (Exception ex) // catches any error
            {
                Console.WriteLine(ex.Message.ToString());
            }
            finally
            {
                // En una aplicación real, utilice el código cleanup aquí.
                conn.Close();
            }
        }
        #endregion

        #region VALIDACIONES
        public static int ultimo_dia_habil_mes()
        {
            int retorno = -1;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select NVL(F_ULTIMO_DIA_HABIL_MES(to_date('01/' || to_char(sysdate, 'mm/yyyy'),'dd/mm/yyyy'), ";
                query += "   to_date(to_char(trunc(sysdate), 'dd/mm/yyyy'), 'dd/mm/yyyy')),0) ";
                query += "from dual";
                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                OracleDataReader dr = cmd.ExecuteReader();

                if (dr.Read()) // C#
                {
                    //label1.Text = dr["dname"].ToString();
                    // or use dr.GetOracleString(0).ToString()
                    retorno = dr.GetInt32(0);

                }
            }
            catch (Exception ex) // catches any error
            {
                Console.WriteLine(ex.Message.ToString());
            }
            finally
            {
                // En una aplicación real, utilice el código cleanup aquí.
                conn.Close();
            }

            return retorno;
        }
        #endregion

        #region PROCEDURES
        public static Boolean ejecuta_procedure()
        {
            insert_log("Ejecutando Procedimiento Almacenado <SP_CT_GEN_AUT_ALL>");

            OracleConnection conn = new OracleConnection();
            conn = clsConn.ConectarBD();
            try
            {
                var query = $@"SP_CT_GEN_AUT_ALL";

                OracleCommand cmd = new OracleCommand(query, conn);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Connection.Open();
                var registrosAfectados = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                insert_log("Excepcion Base de Datos Oracle: " + ex.Message.ToString());
                return false;
            }
            finally
            {
                conn.Close();
            }
            return true;
        }
        #endregion

        #region EJECUTABLES
        public static void ejecutar_programa()
        {
            string curDir = Path.GetDirectoryName(Application.ExecutablePath);
            //string curDir = Directory.GetCurrentDirectory(); //@"C:\Program Files (x86)\ServicioADM\";
            string _exe = "contingencia.exe";
            //Console.WriteLine("{0}", curDir);

            insert_log("Ejecutando " + _exe);

            curDir = curDir + "\\" + _exe;
            insert_log("Directorio Actual " + curDir);

            if (File.Exists(curDir))
            {
                System.Diagnostics.Process.Start(curDir);
            }
            else
            {
                insert_log("Error ejecutable " + _exe + " no existe en la ruta especificada " + curDir);
            }
            //insert_log("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX");
        }
        #endregion
    }
}

