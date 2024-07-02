using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.OracleClient;
using System.Data;
using System.IO;
using System.Windows.Forms;
using System.Configuration;
using contingencia.Data;

namespace contingencia
{
    class Program
    {
        static void Main(string[] args)
        {
            int ll_existe_liq_autorizada, ll_contingencia_generada, ll_periodo_new_exists, ll_arch_contingencia_no_existe, ll_es_dia_contingencia, ll_existe_proceso_contingencia;
            string ls_arch_ret_exists, ls_arch_pgu_exists;
            insert_log("Inicio Proceso Carga Archivos Contingencia a Repositorios");
            ll_existe_liq_autorizada = preliq_Autorizada();
            //
            ll_contingencia_generada = contingencia_generada();
            //
            //obtiene ruta donde se alojara archivo para no repetir siempre este proceso
            ls_arch_ret_exists = REPOSIT_LIQ_CONTINGENCIA();
            ls_arch_pgu_exists = REPOSIT_PAGO_PGU();
            //
            //Obtiene el periodo del repositorio
            ll_periodo_new_exists = periodo_reposit();

            string ruta_LIQ_CONTINGENCIA = ls_arch_ret_exists + '\\' + ll_periodo_new_exists.ToString();
            if (!Directory.Exists(ruta_LIQ_CONTINGENCIA))
                ll_arch_contingencia_no_existe = 1;
            else
                ll_arch_contingencia_no_existe = 0;

            string ruta_PAGO_PGU = ls_arch_pgu_exists + '\\' + ll_periodo_new_exists.ToString();
            if (!Directory.Exists(ruta_PAGO_PGU))
                ll_arch_contingencia_no_existe = 1;
            else
                ll_arch_contingencia_no_existe = 0;

            ll_es_dia_contingencia = ultimo_dia_habil_mes();
            //
            ll_existe_proceso_contingencia = proceso_contingencia(ll_periodo_new_exists);

            if (ll_existe_proceso_contingencia <= 0 && ll_existe_liq_autorizada > 0 && ll_contingencia_generada > 0 && ll_arch_contingencia_no_existe > -1 && ll_es_dia_contingencia > 0) //se coloca ll_es_dia_contingencia > -1 para bypasear el codigo, condicion original ll_es_dia_contingencia > 0
            {
                insert_contingencia(ll_periodo_new_exists);
                leer_ct_imp();
                leer_casos_rebajados(ll_periodo_new_exists);
                /*Generación automatica de Archivos PGU del Bco Estado*/
                genera_PGU_Excel(ll_periodo_new_exists);
                genera_PGU_BcoEstado(ll_periodo_new_exists);
                genera_retenciones_judiciales(ll_periodo_new_exists);
                /*Validaciones Finales*/
                proceso_final(ll_periodo_new_exists);
            }
            insert_log("Fin Proceso Carga Archivos Contingencia a Repositorios");
        }

        #region LOG
        static void insert_log(string mensaje)
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
        static int preliq_Autorizada()
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(count(*),0) ";
                query += "from pensiones.paramet_fechas ";
                query += "where prm_fec_desde = prm_fec_hasta ";
                query += "and prm_tipo_tabla = 'RVLIQ'";

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

        static int contingencia_generada()
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(count(*),0) ";
                query += "from pensiones.paramet_contingencia ";
                query += "where prm_per = ";
                query += "        (select to_number(to_char(add_months(prm_fec_desde, 1), 'YYYYMM'))"; 
                query += "          from pensiones.paramet_fechas";
                query += "          where prm_fec_desde = prm_fec_hasta";
                query += "          and prm_tipo_tabla = 'RVLIQ'";
                query += "		) ";
                query += "and prm_proc7 = 1";

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

        static string REPOSIT_LIQ_CONTINGENCIA()
        {
            string retorno = string.Empty;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select trim(cod_ext) ";
                query += "from pensiones.codigos ";
                query += "where cod_template ";
                query += "like '%REPOSIT_LIQ_CONTINGENCIA%'";

                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                OracleDataReader dr = cmd.ExecuteReader();

                if (dr.Read()) // C#
                {
                    //label1.Text = dr["dname"].ToString();
                    // or use dr.GetOracleString(0).ToString()
                    retorno = dr.GetString(0);

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

        static string REPOSIT_PAGO_PGU()
        {
            string retorno = string.Empty;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;


                query = "select trim(cod_ext) ";
                query += "from pensiones.codigos ";
                query += "where cod_template ";
                query += "like '%REPOSIT_PAGO_PGU%'";

                OracleCommand cmd = new OracleCommand();
                cmd.Connection = conn;
                cmd.CommandText = query;
                cmd.CommandType = CommandType.Text;
                OracleDataReader dr = cmd.ExecuteReader();

                if (dr.Read()) // C#
                {
                    //label1.Text = dr["dname"].ToString();
                    // or use dr.GetOracleString(0).ToString()
                    retorno = dr.GetString(0);

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

        static int periodo_reposit()
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select to_number(to_char(add_months(prm_fec_desde, 1), 'YYYYMM')) ";  /* PRD */
                query += "from pensiones.paramet_fechas ";
                query += "where prm_fec_desde = prm_fec_hasta ";
                query += "and prm_tipo_tabla = 'RVLIQ'";

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

        static int periodo_datos()
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select to_number(to_char(prm_fec_desde,'yyyymm')) ";
                query += "from pensiones.paramet_fechas ";
                query += "where prm_fec_desde = prm_fec_hasta ";
                query += "and prm_tipo_tabla = 'RVLIQ'";

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

        static int ultimo_dia_habil_mes()
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

        static int proceso_contingencia(int ll_periodo_new_exists)
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(count(*),0) ";
                query += "from pensiones.estadocontinpreliqrv ";
                query += "where plqr_per = " + ll_periodo_new_exists + " ";
                query += "and UPPER(plqr_id_program) = UPPER('Contingencia') ";
                query += "and trunc(PLQR_FEC_EJEC) = trunc(sysdate) ";
                query += "and plqr_id_estado in (1, 2)";
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

        static int max_registros()
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(cod_int_num,0) ";
                query += "from pensiones.codigos ";
                query += "where cod_template = 'LIMIT_REG_LIQ_CONTINGENCIA'";

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

        static List<DateTime> obtiene_fec_pago(int periodo)
        {
            List<DateTime> listafechas = new List<DateTime>();
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select plq_fec_pago01 as fec1, plq_fec_pago02 as fec2, plq_fec_pago03 as fec3 ";
                query += "from pensiones.prmliqrv ";
                query += "where plq_per = " + periodo.ToString();

                //OracleCommand cmd = new OracleCommand();
                //cmd.Connection = conn;
                //cmd.CommandText = query;
                //cmd.CommandType = CommandType.Text;
                //OracleDataReader dr = cmd.ExecuteReader();


                OracleCommand cmd = new OracleCommand(query, conn);
                OracleDataAdapter oracledataadapter = new OracleDataAdapter(cmd);
                DataSet dataset = new DataSet();
                oracledataadapter.Fill(dataset, "mitabla");
                conn.Close();
                foreach (DataRow row in dataset.Tables[0].Rows)
                {
                    listafechas.Add(Convert.ToDateTime(row["fec1"].ToString()).Date);
                    listafechas.Add(Convert.ToDateTime(row["fec2"].ToString()).Date);
                    listafechas.Add(Convert.ToDateTime(row["fec3"].ToString()).Date);
                }
                /*
                if (dr.Read()) // C#
                {
                    //label1.Text = dr["dname"].ToString();
                    // or use dr.GetOracleString(0).ToString()
                    Object[] values = new Object[dr.FieldCount];
                    int fieldCount = dr.GetValues(values);
                    for (int i = 0; i < fieldCount; i++)
                        Console.WriteLine(values[i]);
                }*/
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
            return listafechas;

        }
        #endregion

        #region CRUD
        static void insert_contingencia(int periodo)
        {
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();
                string query = string.Empty;
                string usuario = string.Empty;
                string _dataSource = string.Empty;

                _dataSource = ConfigurationManager.AppSettings["DataSource"].ToString();

                OracleConnectionStringBuilder oracleConnectionStringBuilder = new OracleConnectionStringBuilder(_dataSource);

                usuario = oracleConnectionStringBuilder.UserID.ToString();

                query = "INSERT INTO pensiones.estadocontinpreliqrv ";
                query += "(plqr_per, plqr_id_program, plqr_id_estado, plqr_id_usuario, plqr_fec_ejec) ";
                query += "VALUES ";
                query += "(" + periodo + "," + "'Contingencia'" + "," + "1" + "," + " lower(trim('" + usuario + "')), sysdate)";

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

        #region LECTURAS

        static void leer_ct_imp()
        {
            int ll_max_cant_registros, il_periodo_new, ll_periodo, ll_contador_arch = 1, ll_cont = 0, ind = 0, sumaCont = 0;
            string carpeta_conting = string.Empty;
            string nm_archivo = string.Empty;
            string reposit_conting = string.Empty;
            StringBuilder code = new StringBuilder();
            List<CT_TMP> listaCT_TMP = new List<CT_TMP>();
            string Archivo = string.Empty;

            listaCT_TMP = clsConn.SelectCT_TMP();

            var array = listaCT_TMP.ToArray();

            ll_max_cant_registros = max_registros();

            il_periodo_new = periodo_reposit(); /* periodo del repositorio */

            //ll_periodo = periodo_datos(); /*buscar la data con este periodo*/

            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA(); /* obtiene ruta donde se alojara archivo */

            nm_archivo = "CT_BCO_CHILE_" + il_periodo_new.ToString();

            if (!Directory.Exists(carpeta_conting + "\\" + il_periodo_new.ToString() + "\\"))
            {
                /* Crea el directorio */
                try
                {
                    insert_log("Creando Directorio " + carpeta_conting + "\\" + (il_periodo_new.ToString()));
                    Directory.CreateDirectory(carpeta_conting + "\\" + il_periodo_new.ToString());
                }
                catch (Exception ex)
                { insert_log("Error no pudo crear Directorio " + carpeta_conting + "\\" + il_periodo_new.ToString() + " " + ex.Message); }
            }

            nm_archivo = carpeta_conting + "\\" + il_periodo_new.ToString() + "\\" + nm_archivo + ".txt";

            if (nm_archivo != "")
            {
                //elimina archivos preexistentes (*.TXT |*.XLS) de la carpeta especificada
                DirectoryInfo di = new DirectoryInfo(carpeta_conting + "\\" + il_periodo_new.ToString());
                foreach (var fi in di.GetFiles("CT_BCO_CHILE_" + il_periodo_new.ToString() + "*.txt"))
                {
                    if (File.Exists(fi.FullName))
                    {
                        File.Delete(fi.FullName);
                    }
                }
                foreach (var fi in di.GetFiles("*.xlsx"))
                {
                    if (File.Exists(fi.FullName))
                    {
                        File.Delete(fi.FullName);
                    }
                }


                //foreach (var item in listaCT_TMP)
                string[] lineas = new string[ll_max_cant_registros];
                string[] header = new string[1];
                double cant_arch, ll_regs, montoPago = 0, sumamontoPago = 0;
                cant_arch = array.Count() / ll_max_cant_registros;
                ll_regs = array.Count() - (ll_max_cant_registros * cant_arch);
                ll_contador_arch = 0;
                double contRegs = 0;
                if (ll_regs > 0)
                {
                    contRegs = array.Count() - ll_regs;
                }

                for (int i = 0; i < contRegs; i++)
                {
                    string datoArchBcoChile = array[i].DATOS_ARCHBCOCHILE.ToString();
                    //llenar vector del header
                    if ((datoArchBcoChile).Substring(0, 2) == "01")
                    { header[0] = datoArchBcoChile; }
                    //tomar columna del Monto Pago y sumarla
                    if ((datoArchBcoChile).Substring(0, 2) == "02")
                    { montoPago = Convert.ToDouble(datoArchBcoChile.ToString().Substring(197, 13)); sumamontoPago = sumamontoPago + montoPago; }
                    ll_cont++;
                    sumaCont++;
                    //Reemplazar el Monto Pago de la linea de detalle
                    if ((datoArchBcoChile).Substring(0, 2) == "02")
                    {
                        string dato = datoArchBcoChile.ToString().Substring(199, 11).PadRight(13, '0');
                        string newstr = dato;
                        lineas[ind] = datoArchBcoChile;
                        int indice1 = lineas[ind].IndexOf(lineas[ind].Substring(197, 13));
                        int indice2 = indice1 + 13;
                        string cadenanueva = lineas[ind].Substring(0, indice1) + newstr + lineas[ind].Substring(indice2, lineas[ind].Length - indice2);
                        lineas[ind] = cadenanueva.ToString();
                    }
                    else
                    { lineas[ind] = datoArchBcoChile; }
                    ind++;
                    if (ll_cont == ll_max_cant_registros)
                    {
                        i = Convert.ToInt32(contRegs / cant_arch) - 1;
                        ll_contador_arch++;
                        nm_archivo = carpeta_conting + "\\" + il_periodo_new.ToString() + "\\" + "CT_BCO_CHILE_" + il_periodo_new.ToString();
                        Archivo = nm_archivo + "-" + ll_contador_arch.ToString() + ".txt";
                        //
                        insert_log("Generando archivo " + Archivo);
                        if (ll_contador_arch > 1)
                        {
                            var z = new string[header.Length + lineas.Length];
                            header.CopyTo(z, 0);
                            lineas.CopyTo(z, 1);
                            //Reemplazar el Monto total en la linea de Encabezado del archivo
                            string newstr = sumamontoPago.ToString().PadRight(13, '0');
                            int indice1 = z[0].IndexOf(z[0].Substring(55, 13));
                            int indice2 = indice1 + 13;
                            string cadenanueva = z[0].Substring(0, indice1) + newstr + z[0].Substring(indice2, z[0].Length - indice2);
                            z[0] = cadenanueva.ToString();
                            //Reemplazar el Rut de la Empresa en la linea de Encabezado del archivo
                            string rutEmpr = z[0].Substring(2, 9).Trim();
                            newstr = rutEmpr.ToString().PadLeft(9, '0');
                            indice1 = z[0].IndexOf(z[0].Substring(2, 9));
                            indice2 = indice1 + 9;
                            cadenanueva = z[0].Substring(0, indice1) + newstr + z[0].Substring(indice2, z[0].Length - indice2);
                            z[0] = cadenanueva.ToString();

                            var archivo = Util.EscribeArchivo(Archivo, z);
                        }
                        else if (ll_contador_arch == 1)
                        {
                            //Reemplazar el Monto total en la linea de Encabezado del archivo
                            string newstr = sumamontoPago.ToString().PadRight(13, '0');
                            int indice1 = lineas[0].IndexOf(lineas[0].Substring(55, 13));
                            int indice2 = indice1 + 13;
                            string cadenanueva = lineas[0].Substring(0, indice1) + newstr + lineas[0].Substring(indice2, lineas[0].Length - indice2);
                            lineas[0] = cadenanueva.ToString();
                            //Reemplazar el Rut de la Empresa en la linea de Encabezado del archivo
                            string rutEmpr = lineas[0].Substring(2, 9).Trim();
                            newstr = rutEmpr.ToString().PadLeft(9, '0');
                            indice1 = header[0].IndexOf(header[0].Substring(2, 9));
                            indice2 = indice1 + 9;
                            cadenanueva = lineas[0].Substring(0, indice1) + newstr + lineas[0].Substring(indice2, lineas[0].Length - indice2);
                            lineas[0] = cadenanueva.ToString();

                            var archivo = Util.EscribeArchivo(Archivo, lineas);
                        }
                        ll_cont = 0;
                        Array.Clear(lineas, 0, lineas.Length);
                        ind = 0;
                        sumamontoPago = 0;
                    }
                    else if (sumaCont >= contRegs)
                    {
                        i = sumaCont;
                    }
                }
                if (ll_regs > 0)
                {
                    ll_cont = 0;
                    ind = 0;
                    string[] lineas2 = new string[Convert.ToInt32(ll_regs)];
                    for (int i = sumaCont - 1; i < array.Count(); i++)
                    {
                        string datoArchBcoChile = array[i].DATOS_ARCHBCOCHILE.ToString();
                        //tomar columna del Monto Pago y sumarla
                        if ((datoArchBcoChile).Substring(0, 2) == "02")
                        { montoPago = Convert.ToDouble(datoArchBcoChile.ToString().Substring(197, 13)); sumamontoPago = sumamontoPago + montoPago; }
                        ll_cont++;
                        //Reemplazar el Monto Pago de la linea de detalle
                        if ((datoArchBcoChile).Substring(0, 2) == "02")
                        {
                            string dato2 = datoArchBcoChile.ToString().Substring(199, 11).PadRight(13, '0');
                            string newstr2 = dato2;
                            lineas2[ind] = datoArchBcoChile;
                            int indice11 = lineas2[ind].IndexOf(lineas2[ind].Substring(197, 13));
                            int indice22 = indice11 + 13;
                            string cadenanueva2 = lineas2[ind].Substring(0, indice11) + newstr2 + lineas2[ind].Substring(indice22, lineas2[ind].Length - indice22);
                            lineas2[ind] = cadenanueva2.ToString();
                        }
                        else
                        { lineas2[ind] = datoArchBcoChile; }
                        ind++;
                    }
                    for (int aux=0; aux < array.Count(); aux++)
                    {
                        if (aux == 40000)
                        {
                            string datoArchBcoChile = array[aux].DATOS_ARCHBCOCHILE.ToString();
                            montoPago = Convert.ToDouble(datoArchBcoChile.ToString().Substring(197, 13));
                        }
                    }
                    sumamontoPago = sumamontoPago - montoPago;
                    ll_contador_arch++;
                    nm_archivo = carpeta_conting + "\\" + il_periodo_new.ToString() + "\\" + "CT_BCO_CHILE_" + il_periodo_new.ToString();
                    Archivo = nm_archivo + "-" + ll_contador_arch.ToString() + ".txt";
                    //
                    insert_log("Generando archivo " + Archivo);
                    var z = new string[header.Length + lineas2.Length];
                    header.CopyTo(z, 0);
                    lineas2.CopyTo(z, 1);
                    //Reemplazar el Monto total en la linea de Encabezado del archivo
                    string newstr = sumamontoPago.ToString().PadRight(13, '0');
                    int indice1 = z[0].IndexOf(z[0].Substring(55, 13));
                    int indice2 = indice1 + 13;
                    string cadenanueva = z[0].Substring(0, indice1) + newstr + z[0].Substring(indice2, z[0].Length - indice2);
                    z[0] = cadenanueva.ToString();
                    //Reemplazar el Rut de la Empresa en la linea de Encabezado del archivo
                    string rutEmpr = z[0].Substring(2, 9).Trim();
                    newstr = rutEmpr.ToString().PadLeft(9, '0');
                    indice1 = z[0].IndexOf(z[0].Substring(2, 9));
                    indice2 = indice1 + 9;
                    cadenanueva = z[0].Substring(0, indice1) + newstr + z[0].Substring(indice2, z[0].Length - indice2);
                    z[0] = cadenanueva.ToString();

                    var archivo = Util.EscribeArchivo(Archivo, z);
                }
            }
        }

        static void leer_casos_rebajados(int periodo)
        {
            string carpeta_conting = string.Empty;
            string nm_archivo = string.Empty;
            string archivo_excel = string.Empty;

            insert_log("Generación archivo con casos rebajados...");
            List<CT_CasosRebajados> listaCT_casosrebajados = new List<CT_CasosRebajados>();

            listaCT_casosrebajados = clsConn.SelectCT_CasosRebajados(periodo);

            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA(); /* obtiene ruta donde se alojara archivo */
            nm_archivo = "CT_BCO_CHILE_" + periodo.ToString();

            try
            {
                archivo_excel = carpeta_conting + "\\" + periodo.ToString() + "\\" + nm_archivo;
                insert_log("Generando archivo " + archivo_excel + ".xlsx");

                var dt = new DataTable();

                dt.Columns.Add("Póliza", typeof(int));
                dt.Columns.Add("R.U.T", typeof(string));
                dt.Columns.Add("Nombre Completo", typeof(string));
                dt.Columns.Add("Dirección", typeof(string));
                dt.Columns.Add("Comuna", typeof(string));
                dt.Columns.Add("Grupo de Pago", typeof(int));
                dt.Columns.Add("Monto Liquido", typeof(string));
                dt.Columns.Add("Glosa Rechazo", typeof(string));
                listaCT_casosrebajados
                    .Select(obj => dt.Rows.Add(
                        obj.Poliza,
                        obj.Rut,
                        obj.NombreCompleto,
                        obj.Direccion,
                        obj.Comuna,
                        obj.GrupoDePago,
                        obj.MontoLiquido,
                        obj.GlosaRechazo)).ToList();

                string informe = Util.ExportarExcelDetalle(archivo_excel + ".xlsx", dt, "");
                /*Util.ExportToExcel(dt, archivo_excel, nm_archivo + ".xlsx");*/
            }
            catch (Exception ex)
            { insert_log("Error No pudo Crear archivo " + archivo_excel); }

        }

        static void genera_PGU_Excel(int periodo)
        {
            int ll_periodo;
            string carpeta_conting_pgu = string.Empty;
            string carpeta_conting = string.Empty;
            string nm_archivo_pgu = string.Empty;
            string archivo_excel = string.Empty;
            List<CT_PGU> listaCT_PGU = new List<CT_PGU>();

            ll_periodo = periodo_datos(); /* #70137 21-06-2024 buscar la data con el periodo real*/

            //carpeta_conting_pgu = REPOSIT_PAGO_PGU(); /* obtiene ruta donde se alojara archivo */
            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA(); /* obtiene ruta donde se alojara archivo */

            nm_archivo_pgu = "CT_DATOS_PGU_" + periodo.ToString() + ".xlsx";

            if (!Directory.Exists(carpeta_conting + "\\" + periodo.ToString() + "\\"))
            {
                /* Crea el directorio */
                try
                {
                    insert_log("Creando Directorio " + carpeta_conting + "\\" + (periodo.ToString()));
                    Directory.CreateDirectory(carpeta_conting + "\\" + periodo.ToString());
                }
                catch (Exception ex)
                { insert_log("Error no pudo crear Directorio " + carpeta_conting + "\\" + periodo.ToString() + " " + ex.Message); }
            }

            //nm_archivo_pgu = carpeta_conting_pgu + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu + ".xlsx";

            listaCT_PGU = clsConn.SelectCT_PGU(ll_periodo); /* #70137 21-06-2024 buscar la data con el periodo real*/

            try
            {

                archivo_excel = carpeta_conting + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu;
                insert_log("Generando archivo " + archivo_excel);

                var dt = new DataTable();

                //elimina archivos preexistentes (*.XLSX) de la carpeta especificada
                DirectoryInfo di = new DirectoryInfo(carpeta_conting + "\\" + periodo.ToString());
                foreach (var fi in di.GetFiles("CT_DATOS_PGU_" + periodo.ToString() + ".xlsx"))
                {
                    if (File.Exists(fi.FullName))
                    {
                        File.Delete(fi.FullName);
                    }
                }

                dt.Columns.Add("Periodo", typeof(string)); dt.Columns.Add("Rut Ent Pen Reg", typeof(string)); dt.Columns.Add("Dv", typeof(string)); dt.Columns.Add("Rut Benef", typeof(string)); dt.Columns.Add("Dv_Ben", typeof(string));
                dt.Columns.Add("Ape Pat", typeof(string)); dt.Columns.Add("Ape Mat", typeof(string)); dt.Columns.Add("Nombres", typeof(string)); dt.Columns.Add("Dir Benef", typeof(string)); dt.Columns.Add("Com Benef", typeof(string));
                dt.Columns.Add("Ciudad Benef", typeof(string)); dt.Columns.Add("Reg Dom Benef", typeof(string)); dt.Columns.Add("Num Tel Fijo", typeof(string)); dt.Columns.Add("Num Tel Movil", typeof(string)); dt.Columns.Add("Correo Elect", typeof(string));
                dt.Columns.Add("Fec Pag Ult Pen", typeof(string)); dt.Columns.Add("Forma Pago", typeof(string)); dt.Columns.Add("Mod Pago", typeof(string)); dt.Columns.Add("Rut Ent Pagadora", typeof(string)); dt.Columns.Add("Dv Ent Pag", typeof(string));
                dt.Columns.Add("Com Ent Pag", typeof(string)); dt.Columns.Add("Reg Ent Pag", typeof(string)); dt.Columns.Add("Tipo Cta Banc Benef", typeof(string)); dt.Columns.Add("Num Cta Banc Benef", typeof(string)); dt.Columns.Add("Cobro Mandatario", typeof(string));
                dt.Columns.Add("Rut Mandat", typeof(string)); dt.Columns.Add("Dv mandat", typeof(string)); dt.Columns.Add("Pater Mandat", typeof(string)); dt.Columns.Add("Mater Mandat", typeof(string)); dt.Columns.Add("Nom Mandat", typeof(string));
                dt.Columns.Add("Dir Mandat", typeof(string)); dt.Columns.Add("Comuna mandat", typeof(string)); dt.Columns.Add("Cuidad mandat", typeof(string)); dt.Columns.Add("Reg Mandat", typeof(string)); dt.Columns.Add("Cod Ent Banc Mandat", typeof(string));
                dt.Columns.Add("Tip Cta Mandat", typeof(string)); dt.Columns.Add("Num Cta Mandat", typeof(string)); dt.Columns.Add("Mont Desc IPS", typeof(string)); dt.Columns.Add("Fec Pag Pensión", typeof(string)); dt.Columns.Add("Fec Prox Pag Pens", typeof(string));
                dt.Columns.Add("Cod Etn Banc Benef", typeof(string)); dt.Columns.Add("Est del Pago", typeof(string)); dt.Columns.Add("RUN Ent pension", typeof(string)); dt.Columns.Add("DV Ent", typeof(string)); dt.Columns.Add("N° Poliza", typeof(string));
                listaCT_PGU
                    .Select(obj => dt.Rows.Add(
                        obj.Periodo,
                        obj.Rut_Ent_Pen_Reg,
                        obj.Dv,
                        obj.Rut_Benef,
                        obj.Dv_Ben,
                        obj.Ape_Pat,
                        obj.Ape_Mat,
                        obj.Nombres,
                        obj.Dir_Benef,
                        obj.Com_Benef,
                        obj.Ciudad_Benef,
                        obj.Reg_Dom_Benef,
                        obj.Num_Tel_Fijo,
                        obj.Num_Tel_Movil,
                        obj.Correo_Elect,
                        obj.Fec_Pag_Ult_Pen,
                        obj.Forma_Pago,
                        obj.Mod_Pago,
                        obj.Rut_Ent_Pagadora,
                        obj.Dv_Ent_Pag,
                        obj.Com_Ent_Pag,
                        obj.Reg_Ent_Pag,
                        obj.Tipo_Cta_Banc_Benef,
                        obj.Num_Cta_Banc_Benef,
                        obj.Cobro_Mandatario,
                        obj.Rut_Mandat,
                        obj.Dv_mandat,
                        obj.Pater_Mandat,
                        obj.Mater_Mandat,
                        obj.Nom_Mandat,
                        obj.Dir_Mandat,
                        obj.Comuna_mandat,
                        obj.Cuidad_mandat,
                        obj.Reg_Mandat,
                        obj.Cod_Ent_Banc_Mandat,
                        obj.Tip_Cta_Mandat,
                        obj.Num_Cta_Mandat,
                        obj.Mont_Desc_IPS,
                        obj.Fec_Pag_Pensión,
                        obj.Fec_Prox_Pag_Pens,
                        obj.Cod_Etn_Banc_Benef,
                        obj.Est_del_Pago,
                        obj.RUN_Ent_pension,
                        obj.DV_Ent,
                        obj.Poliza)).ToList();

                string informe = Util.ExportarExcelDetalle(archivo_excel, dt, "Cartera Detallada Contingencia");
                /* Util.ExportToExcel(dt, archivo_excel, "CT_DATOS_PGU_" + periodo.ToString());*/


            }
            catch (Exception ex)
            { insert_log("Error No pudo Crear archivo " + archivo_excel); }

        }

        static void genera_PGU_BcoEstado(int periodo)
        {
            int ll_periodo;
            List<DateTime> fechas;
            List<CT_PGUBancoEstado> listaCT_PGUBancoEstado = new List<CT_PGUBancoEstado>();
            string carpeta_conting_pgu = string.Empty;
            string carpeta_conting = string.Empty;
            string archivoPGU_BcoEstado = string.Empty;
            int cont = 0;

            //carpeta_conting_pgu = REPOSIT_PAGO_PGU(); /* obtiene ruta donde se alojara archivo */
            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA(); /* obtiene ruta donde se alojara archivo */

            ll_periodo = periodo_datos(); /* #70137 21-06-2024 buscar la data con el periodo real*/

            fechas = obtiene_fec_pago(ll_periodo); /* #70137 21-06-2024 buscar la data con el periodo real*/

            var array = fechas.ToArray();

            insert_log("Generación automatica de Archivos PGU del Bco Estado...");
            for (int i = 0; i < array.Count(); i++)
            {
                string fecha = array[i].ToString().Substring(0, 10);
                listaCT_PGUBancoEstado = clsConn.SelectCT_PGUBancoEstado(ll_periodo, fecha);
                if (listaCT_PGUBancoEstado.Count() > 0)
                {
                    var arrayArch = listaCT_PGUBancoEstado.ToArray();
                    string[] lineas = new string[arrayArch.Count()];
                    archivoPGU_BcoEstado = carpeta_conting + "\\" + periodo.ToString() + "\\" + "archivo_bco_estado_pgu_" + periodo.ToString() + "_" + fecha.Replace("-", "") + ".txt";
                    insert_log("Generando archivo " + archivoPGU_BcoEstado);
                    for (int j = 0; j < arrayArch.Count(); j++)
                    {
                        string datoArch = listaCT_PGUBancoEstado[j].CAMPO.ToString();
                        lineas[j] = datoArch;
                    }
                    var archivo = Util.EscribeArchivo(archivoPGU_BcoEstado, lineas);
                }
            }

        }

        static void genera_retenciones_judiciales(int periodo)
        {
            string carpeta_conting = string.Empty;
            string Archivo = string.Empty;
            List<CT_RJEmiarch> listaCT_RJEmiarch = new List<CT_RJEmiarch>();

            insert_log("Generación archivo banco estado retenciones judiciales...");

            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA();

            Archivo = carpeta_conting + "\\" + periodo.ToString() + "\\" + "archivo_bco_estado" + periodo.ToString() + ".txt";

            if (File.Exists(Archivo))
                File.Delete(Archivo);

            listaCT_RJEmiarch = clsConn.Select_CT_RJEmiarch(periodo);

            var array = listaCT_RJEmiarch.ToArray();
            string[] lineas = new string[array.Count()];

            insert_log("Creando archivo " + Archivo);

            for (int i = 0; i < array.Count(); i++)
            {
                string datos = array[i].CAMPO.ToString();
                lineas[i] = datos;
            }
            var archivo = Util.EscribeArchivo(Archivo, lineas);
        }

        static void proceso_final(int periodo)
        {
            string carpeta_conting = string.Empty;
            string Archivo = string.Empty;
            string query = string.Empty;
            string usuario = string.Empty;
            string _dataSource = string.Empty;

            carpeta_conting = REPOSIT_LIQ_CONTINGENCIA();
            Archivo = carpeta_conting + "\\" + periodo.ToString() + "\\" + "archivo_bco_estado" + periodo.ToString() + ".txt";

            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                _dataSource = ConfigurationManager.AppSettings["DataSource"].ToString();

                OracleConnectionStringBuilder oracleConnectionStringBuilder = new OracleConnectionStringBuilder(_dataSource);
                if (File.Exists(Archivo))
                {
                    usuario = oracleConnectionStringBuilder.UserID.ToString();
                    query = "update pensiones.estadocontinpreliqrv ";
                    query += "set plqr_id_estado = 2 ";
                    query += "where plqr_per = " + periodo;
                    query += " and plqr_id_program = 'Contingencia' and plqr_id_estado = 1 ";
                    query += " and plqr_id_usuario = lower(trim('" + usuario + "'))";
                    query += " and trunc(plqr_fec_ejec) = trunc(sysdate)";

                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.ExecuteNonQuery();
                }
                else
                {
                    usuario = oracleConnectionStringBuilder.UserID.ToString();
                    query = "update pensiones.estadocontinpreliqrv ";
                    query += "set plqr_id_estado = 3 ";
                    query += "where plqr_per = " + periodo;
                    query += " and plqr_id_program = 'Contingencia' and plqr_id_estado = 1 ";
                    query += " and plqr_id_usuario = lower(trim('" + usuario + "'))";
                    query += " and trunc(plqr_fec_ejec) = trunc(sysdate)";

                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.ExecuteNonQuery();
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
        }
        #endregion
    }
}
