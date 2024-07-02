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
using preliquidacion.Data;

namespace preliquidacion
{
    class Program
    {
        static void Main(string[] args)
        {
            int ll_batch_ejecutado=0, ll_preliq_per=0, ll_existe_proceso_preliquidacion;
            List<Preliq_Batch> listaPreliq_Batch = new List<Preliq_Batch>();

            //--insert_log("Inicio Proceso Carga Archivos Preliquidacion a Repositorios");

            //solo el dia de la preliquidacion genera archivos y solo podrán generarlos los
            //mismos usuarios que realizan la contingencia
            int ll_dia_habil_preliq = dia_habil_preliq(); 

            if (ll_dia_habil_preliq > 0)  //se coloca -1 para bypasear el codigo, condicion original ll_es_dia_preliq > 0
            {
                listaPreliq_Batch = clsConn.SelectPreliq_Batch();

                foreach (var item in listaPreliq_Batch)
                {
                    ll_batch_ejecutado = item.batch_ejecutado;
                    ll_preliq_per = item.preliq_per;
                }

                if (ll_batch_ejecutado > 0 && ll_preliq_per > 0)
                {
                    // valida si existe generación archivos preliquidación en proceso
                    ll_existe_proceso_preliquidacion = preliquidacion_generada(ll_preliq_per);
                    if (ll_existe_proceso_preliquidacion <= 0)
                    {
                        insert_preliq(ll_preliq_per);
                        preliq_genera_bcoest(ll_preliq_per);
                        preliq_genera_bcochile(ll_preliq_per);
                        preliq_genera_pag_reg(ll_preliq_per);
                        preliq_genera_pag_reg_benef(ll_preliq_per);
                        preliq_genera_datos_pgu(ll_preliq_per);
                        preliq_genera_pgu_bcoest(ll_preliq_per);
                        proceso_final(ll_preliq_per);
                    }
                    insert_log("Fin Proceso Carga Archivos PreLiquidación a Repositorios");
                }
            }
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
        public static int dia_habil_preliq()
        {
            int retorno = -1;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select NVL(pensiones.F_DIAS_HABILES_PRELIQ(to_date('01/' || to_char(sysdate, 'mm/yyyy'),'dd/mm/yyyy'), ";
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

        static int preliquidacion_generada(int periodo)
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(count(*), 0) ";
                query += "from pensiones.estadocontinpreliqrv ";
                query += "where plqr_per = " + periodo.ToString();
                query += " and UPPER(plqr_id_program) = UPPER('Preliquidacion') ";
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

        static int preliquidacion_generada_tmp(int periodo)
        {
            int retorno = 0;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "select nvl(count(*),0) ";
                query += "from pensiones.preliq_tmp";

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

        static string REPOSIT_PRELIQ()
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
                query += "like '%REPOSIT_PRELIQ%'";

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
        static void insert_preliq(int periodo)
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

                query = "insert into pensiones.estadocontinpreliqrv ";
                query += "(plqr_per, plqr_id_program, plqr_id_estado, plqr_id_usuario, plqr_fec_ejec) ";
                query += "values ";
                query += "(" + periodo + "," + "'Preliquidacion'" + "," + "1" + "," + " lower(trim('" + usuario + "')), sysdate)";

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
        static void preliq_genera_bcoest(int periodo)
        {
            string carpeta_preliq = string.Empty;
            string Archivo = string.Empty;

            List<Preliq_RJEmiarch> listaPreliq_RJEmiarch = new List<Preliq_RJEmiarch>();

            //obtiene ruta donde se alojara archivos preliquidacion
            carpeta_preliq = REPOSIT_PRELIQ();

            insert_log("Creando archivos para Preliq Bco Estado" + carpeta_preliq + "\\" + periodo.ToString());

            if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
            {
                /* Crea el directorio */
                try
                {
                    insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                    Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                }
                catch (Exception ex)
                { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
            }

            Archivo = carpeta_preliq + "\\" + periodo.ToString() + "\\" + "archivo_bco_estado" + periodo.ToString() + ".txt";
            if (File.Exists(Archivo))
                File.Delete(Archivo);

            listaPreliq_RJEmiarch = clsConn.Select_Preliq_RJEmiarch(periodo);

            var array = listaPreliq_RJEmiarch.ToArray();
            string[] lineas = new string[array.Count()];

            insert_log("Creando archivo " + Archivo);

            for (int i = 0; i < array.Count(); i++)
            {
                string datos = array[i].CAMPO.ToString();
                lineas[i] = datos;
            }
            var archivo = Util.EscribeArchivo(Archivo, lineas);
        }

        public static void preliq_genera_bcochile(int periodo)
        {
            int ll_max_cant_registros, ll_contador_arch = 1, ll_cont = 0, ind = 0, sumaCont = 0;
            List<Preliq_TMP> listaPreliq_TMP = new List<Preliq_TMP>();
            string Archivo = string.Empty;
            string carpeta_preliq = string.Empty;
            string nm_archivo = string.Empty;

            //Ejecuta el SP para llenar la Tabla Temporal PRELIQ_TMP
            insert_log("Ejecutando Procedimiento Almacenado <SP_PRELIQ_GENARCH_BCOCHILE>");

            OracleConnection conn = new OracleConnection();
            conn = clsConn.ConectarBD();
            try
            {
                var query = $@"SP_PRELIQ_GENARCH_BCOCHILE";

                OracleCommand cmd = new OracleCommand(query, conn);

                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Connection.Open();
                var registrosAfectados = cmd.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                insert_log("Excepcion Base de Datos Oracle: " + ex.Message.ToString());
            }
            finally
            {
                conn.Close();
            }

            listaPreliq_TMP = clsConn.SelectPreliq_TMP();
            if (listaPreliq_TMP.Count() > 0)
            {
                var array = listaPreliq_TMP.ToArray();

                ll_max_cant_registros = max_registros();

                carpeta_preliq = REPOSIT_PRELIQ();

                nm_archivo = "CT_BCO_CHILE_" + periodo.ToString();

                if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
                {
                    /* Crea el directorio */
                    try
                    {
                        insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                        Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                    }
                    catch (Exception ex)
                    { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
                }

                nm_archivo = carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo + ".txt";

                if (nm_archivo != "")
                {
                    //elimina archivos preexistentes (*.TXT) de la carpeta especificada
                    DirectoryInfo di = new DirectoryInfo(carpeta_preliq + "\\" + periodo.ToString());
                    foreach (var fi in di.GetFiles("CT_BCO_CHILE_" + periodo.ToString() + "*.txt"))
                    {
                        if (File.Exists(fi.FullName))
                        {
                            File.Delete(fi.FullName);
                        }
                    }

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
                            string dato = datoArchBcoChile.ToString().Substring(199, 11).PadRight(13,'0');
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
                            nm_archivo = carpeta_preliq + "\\" + periodo.ToString() + "\\" + "CT_BCO_CHILE_" + periodo.ToString();
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
                        for (int aux = 0; aux < array.Count(); aux++)
                        {
                            if (aux == 40000)
                            {
                                string datoArchBcoChile = array[aux].DATOS_ARCHBCOCHILE.ToString();
                                montoPago = Convert.ToDouble(datoArchBcoChile.ToString().Substring(197, 13));
                            }
                        }
                        sumamontoPago = sumamontoPago - montoPago;
                        ll_contador_arch++;
                        nm_archivo = carpeta_preliq + "\\" + periodo.ToString() + "\\" + "CT_BCO_CHILE_" + periodo.ToString();
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
        }

        public static void preliq_genera_pag_reg(int periodo)
        {
            string carpeta_preliq = string.Empty;
            string nm_archivo = string.Empty;
            string archivo_excel = string.Empty;
            List<Preliq_PagReg> listaPreliq_PagReg = new List<Preliq_PagReg>();

            carpeta_preliq = REPOSIT_PRELIQ();
            nm_archivo = "Control_de_Liquidacion_" + periodo.ToString() + ".xlsx"; ;

            if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
            {
                /* Crea el directorio */
                try
                {
                    insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                    Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                }
                catch (Exception ex)
                { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
            }

            archivo_excel = carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo;

            listaPreliq_PagReg = clsConn.Select_Preliq_PagReg(periodo);

            if (listaPreliq_PagReg.Count() > 0)
            {
                try
                {
                    var dt = new DataTable();

                    insert_log("Creando archivo " + archivo_excel);

                    //elimina archivos preexistentes (*.XLSX) de la carpeta especificada
                    DirectoryInfo di = new DirectoryInfo(carpeta_preliq + "\\" + periodo.ToString());
                    foreach (var fi in di.GetFiles("Control_de_Liquidacion_" + periodo.ToString() + ".xlsx"))
                    {
                        if (File.Exists(fi.FullName))
                        {
                            File.Delete(fi.FullName);
                        }
                    }

                    dt.Columns.Add("Poliza", typeof(string)); dt.Columns.Add("Grp", typeof(string)); dt.Columns.Add("Nombre Causante", typeof(string)); dt.Columns.Add("Rut Cau", typeof(string)); dt.Columns.Add("Dv Cau", typeof(string));
                    dt.Columns.Add("Nombre Receptor", typeof(string)); dt.Columns.Add("Rut Recep.", typeof(string)); dt.Columns.Add("Dv Recep.", typeof(string)); dt.Columns.Add("Tipo Pensión", typeof(string)); dt.Columns.Add("Cob.Inicial", typeof(string));
                    dt.Columns.Add("Cob.Actual", typeof(string)); dt.Columns.Add("Relación", typeof(string)); dt.Columns.Add("Fec.garant.", typeof(string)); dt.Columns.Add("Pns.Ref.", typeof(string)); dt.Columns.Add("Pens. Base UF", typeof(string));
                    dt.Columns.Add("Pens. Base $", typeof(string)); dt.Columns.Add("Bono Post Laboral", typeof(string)); dt.Columns.Add("Hab. APS", typeof(string)); dt.Columns.Add("Hab. PGU", typeof(string)); dt.Columns.Add("Bono Compensatorio", typeof(string)); 
                    dt.Columns.Add("Bono/Agui APS", typeof(string)); dt.Columns.Add("Hab. GE", typeof(string)); dt.Columns.Add("Hab. AF", typeof(string)); dt.Columns.Add("Retro PNC", typeof(string)); dt.Columns.Add("Bono clase media", typeof(string));
                    dt.Columns.Add("Otros Haberes", typeof(string)); dt.Columns.Add("Tot. Haberes", typeof(string)); dt.Columns.Add("Des. Salud", typeof(string)); dt.Columns.Add("Des. GE", typeof(string)); dt.Columns.Add("Descto.AF", typeof(string));
                    dt.Columns.Add("Impuesto", typeof(string)); dt.Columns.Add("Des.APS", typeof(string)); dt.Columns.Add("Pago PGU IPS", typeof(string)); dt.Columns.Add("Credito CIA", typeof(string)); dt.Columns.Add("CCAF", typeof(string));
                    dt.Columns.Add("Ret. Jud + AF Retenida", typeof(string)); dt.Columns.Add("Seguro Pensionado", typeof(string)); dt.Columns.Add("Otros Desc.", typeof(string)); dt.Columns.Add("Tot. Desc.", typeof(string)); dt.Columns.Add("Liq. Pag", typeof(string));
                    dt.Columns.Add("Fec. Pago", typeof(string)); dt.Columns.Add("Pens. + GE + APS + (mes) - Impto - 7%", typeof(string)); dt.Columns.Add("Desc. Forma Pago", typeof(string)); dt.Columns.Add("Cuenta", typeof(string)); dt.Columns.Add("Banco", typeof(string));
                    dt.Columns.Add("Sucursal", typeof(string)); dt.Columns.Add("Medio Pago Bco Chile", typeof(string)); dt.Columns.Add("Fecha Pago Contrato", typeof(string)); dt.Columns.Add("Bon.Salud Mes", typeof(string)); dt.Columns.Add("PGU del Mes", typeof(string));
                    dt.Columns.Add("Escalonada", typeof(string)); dt.Columns.Add("% Escalonada", typeof(string)); dt.Columns.Add("Fec. Término Escalonada", typeof(string)); 
                    listaPreliq_PagReg
                        .Select(obj => dt.Rows.Add(
                            obj.liqrv_poliza,
                            obj.liqrv_grupo,
                            obj.persnat_nomcau,
                            obj.persnat_rutcau,
                            obj.persnat_dvcau,
                            obj.persnat_nombrecep,
                            obj.persnat_rutreecp,
                            obj.persnat_dvrecep,
                            obj.tippen,
                            obj.causalidad_inicial,
                            obj.persnat_causalidad_actual,
                            obj.relacion,
                            obj.asegafp_fec_garant,
                            obj.pns_ref,
                            obj.pbase_uf,
                            obj.pbase_pes,
                            obj.bono_postlaboral,
                            obj.aps,
                            obj.pgu,
                            obj.bono_compensatorio,
                            obj.bono_agui_aps,
                            obj.ge,
                            obj.af,
                            obj.retro_pnc,
                            obj.bono_clase_media,
                            obj.otros_hab,
                            obj.tot_hab,
                            obj.dsc_salud,
                            obj.dsc_ge,
                            obj.dsc_af,
                            obj.impto,
                            obj.dsc_aps,
                            obj.dsc_pgu,
                            obj.credito_ing,
                            obj.ccaf,
                            obj.ret_jud,
                            obj.seguro_pensionado,
                            obj.otros_dsc,
                            obj.tot_dsc,
                            obj.liqrv_liq_pag,
                            obj.liqrv_f_pago,
                            obj.pm_ge_aps_imp_7,
                            obj.forma_pago_forma_pago,
                            obj.liqrv_lqr_cta_bco,
                            obj.codigos_banco,
                            obj.suc_bco,
                            obj.codigos_medio_pago_bcochile,
                            obj.fecha_pago_contrato,
                            obj.bonif_salud_mes,
                            obj.pgu_mes,
                            obj.es_escalonada,
                            obj.porc_pen_escalonada,
                            obj.fec_term_escalonada
                            )).ToList();

                    string informe = Util.ExportarExcelDetalle(archivo_excel, dt, "Control de Informe Liquidación");
                    /*Util.ExportToExcel(dt, archivo_excel, "Control_de_Liquidacion_" + periodo.ToString(), "Control de Informe Liquidación");*/
                }
                catch (Exception ex)
                { insert_log("Error No pudo Crear archivo " + archivo_excel + " " + ex.Message); }
            }
        }

        public static void preliq_genera_pag_reg_benef(int periodo)
        {
            string carpeta_preliq = string.Empty;
            string nm_archivo = string.Empty;
            string archivo_excel = string.Empty;
            List<PreLiq_PagRegBen> listaPreliq_PagRegBen = new List<PreLiq_PagRegBen>();

            carpeta_preliq = REPOSIT_PRELIQ();
            nm_archivo = "Control_de_Liquidacion_Beneficiarios_" + periodo.ToString() + ".xlsx"; ;

            if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
            {
                /* Crea el directorio */
                try
                {
                    insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                    Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                }
                catch (Exception ex)
                { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
            }

            archivo_excel = carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo;

            listaPreliq_PagRegBen = clsConn.Select_Preliq_PagRegBen(periodo);

            if (listaPreliq_PagRegBen.Count() > 0)
            {
                try
                {
                    var dt = new DataTable();

                    insert_log("Creando archivo " + archivo_excel);

                    //elimina archivos preexistentes (*.XLSX) de la carpeta especificada
                    DirectoryInfo di = new DirectoryInfo(carpeta_preliq + "\\" + periodo.ToString());
                    foreach (var fi in di.GetFiles("Control_de_Liquidacion_Beneficiarios_" + periodo.ToString() + ".xlsx"))
                    {
                        if (File.Exists(fi.FullName))
                        {
                            File.Delete(fi.FullName);
                        }
                    }

                    dt.Columns.Add("Poliza", typeof(string)); dt.Columns.Add("Grp", typeof(string)); dt.Columns.Add("Nombre Causante", typeof(string)); dt.Columns.Add("Rut Cau", typeof(string)); dt.Columns.Add("Dv Cau", typeof(string));
                    dt.Columns.Add("Nombre Receptor", typeof(string)); dt.Columns.Add("Rut Recep.", typeof(string)); dt.Columns.Add("Dv Recep.", typeof(string)); dt.Columns.Add("Nombre Beneficiario", typeof(string)); dt.Columns.Add("Rut Beneficiario", typeof(string));
                    dt.Columns.Add("Dv Beneficiario", typeof(string)); dt.Columns.Add("Cob.Inicial", typeof(string)); dt.Columns.Add("Cob.Actual", typeof(string)); dt.Columns.Add("Relación", typeof(string)); dt.Columns.Add("Fec.garant.", typeof(string));
                    dt.Columns.Add("Pns.Ref.", typeof(string)); dt.Columns.Add("Tipo Pensión", typeof(string)); dt.Columns.Add("Pens. Base UF", typeof(string)); dt.Columns.Add("Pens. Base $", typeof(string)); dt.Columns.Add("Bono Post Laboral", typeof(string)); 
                    dt.Columns.Add("Hab. APS", typeof(string)); dt.Columns.Add("Hab. PGU", typeof(string)); dt.Columns.Add("Bono Compensatorio", typeof(string)); dt.Columns.Add("Bono/Agui APS", typeof(string));
                    dt.Columns.Add("Hab. GE", typeof(string)); dt.Columns.Add("Hab. AF", typeof(string)); dt.Columns.Add("Retro PNC", typeof(string)); dt.Columns.Add("Bono clase media", typeof(string));
                    dt.Columns.Add("Otros Haberes", typeof(string)); dt.Columns.Add("Tot. Haberes", typeof(string)); dt.Columns.Add("Des. Salud", typeof(string)); dt.Columns.Add("Des. GE", typeof(string)); dt.Columns.Add("Descto.AF", typeof(string));
                    dt.Columns.Add("Impuesto", typeof(string)); dt.Columns.Add("Des.APS", typeof(string)); dt.Columns.Add("Pago PGU IPS", typeof(string)); dt.Columns.Add("Credito CIA", typeof(string)); dt.Columns.Add("CCAF", typeof(string));
                    dt.Columns.Add("Retención Judicial", typeof(string)); dt.Columns.Add("Seguro Pensionado", typeof(string)); dt.Columns.Add("Otros Desc.", typeof(string)); dt.Columns.Add("Tot. Desc.", typeof(string)); dt.Columns.Add("Liq. Pag", typeof(string));
                    dt.Columns.Add("Fec. Val. Pens.", typeof(string)); dt.Columns.Add("Pens. + GE + APS + (mes) - Impto - 7%", typeof(string)); dt.Columns.Add("Desc. Forma Pago", typeof(string)); dt.Columns.Add("Cuenta", typeof(string)); dt.Columns.Add("Banco", typeof(string));
                    dt.Columns.Add("Sucursal", typeof(string)); dt.Columns.Add("Medio Pago Bco Chile", typeof(string)); dt.Columns.Add("Fecha dispon. pago pens.", typeof(string)); dt.Columns.Add("Bon.Salud Mes", typeof(string)); dt.Columns.Add("PGU del Mes", typeof(string));
                    dt.Columns.Add("Tot. Proporc.", typeof(string));
                    dt.Columns.Add("Escalonada", typeof(string)); dt.Columns.Add("% Escalonada", typeof(string)); dt.Columns.Add("Fec. Término Escalonada", typeof(string));
                    listaPreliq_PagRegBen
                        .Select(obj => dt.Rows.Add(
                            obj.liqrv_poliza,
                            obj.liqrv_grupo,
                            obj.persnat_nomcau,
                            obj.persnat_rutcau,
                            obj.persnat_dvcau,
                            obj.persnat_nombrecep,
                            obj.persnat_rutreecp,
                            obj.persnat_dvrecep,
                            obj.ben_nomb_benef,
                            obj.ben_rut_benef,
                            obj.ben_dv_benef,
                            obj.causalidad_inicial,
                            obj.persnat_causalidad_actual,
                            obj.relacion,
                            obj.asegafp_fec_garant,
                            obj.pns_ref,
                            obj.tippen,
                            obj.p_pbase_uf,
                            obj.pbase_pes,
                            obj.bono_postlaboral,
                            obj.aps,
                            obj.pgu,
                            obj.bono_compensatorio,
                            obj.bono_agui_aps,
                            obj.ge,
                            obj.af,
                            obj.retro_pnc,
                            obj.bono_clase_media,
                            obj.otros_hab,
                            obj.tot_hab,
                            obj.dsc_salud,
                            obj.dsc_ge,
                            obj.dsc_af,
                            obj.impto,
                            obj.dsc_aps,
                            obj.dsc_pgu,
                            obj.credito_ing,
                            obj.ccaf,
                            obj.ret_jud,
                            obj.seguro_pensionado,
                            obj.otros_dsc,
                            obj.tot_dsc,
                            obj.mto_liquido,
                            obj.liqrv_f_pago,
                            obj.pb_ge_aps_imp_7pc,
                            obj.forma_pago_forma_pago,
                            obj.cta_bco,
                            obj.codigos_banco,
                            obj.sucursal,obj.codigos_medio_pago_bcochile,
                            obj.fecha_pago_contrato,
                            obj.bonif_salud_mes,
                            obj.pgu_mes,
                            obj.tot_proporc,
                            obj.es_escalonada,
                            obj.porc_pen_escalonada,
                            obj.fec_term_escalonada
                            )).ToList();

                    string informe = Util.ExportarExcelDetalle(archivo_excel, dt, "Control de Liquidación por Beneficiario");
                    /*Util.ExportToExcel(dt, archivo_excel, "Ctrol_de_Liq_Ben_" + periodo.ToString(), "Control de Liquidación por Beneficiario");*/
                }
                catch (Exception ex)
                { insert_log("Error No pudo Crear archivo " + archivo_excel + " " + ex.Message); }

            }
        }

        public static void preliq_genera_datos_pgu(int periodo)
        {
            int preliq_generada_tmp;
            string carpeta_conting_pgu = string.Empty;
            string carpeta_preliq = string.Empty;
            string nm_archivo_pgu = string.Empty;
            string Archivo = string.Empty;
            string Arch_Desde = string.Empty;
            string archivo_excel = string.Empty;
            List<CT_PGU> listaCT_PGU = new List<CT_PGU>();


            //valida si existen registros generados de preliquidacion
            preliq_generada_tmp = preliquidacion_generada_tmp(periodo);

            if (preliq_generada_tmp > 0)
            {
                ////obtiene ruta desde donde se va a copiar el archivo
                //carpeta_conting_pgu = REPOSIT_PAGO_PGU();
                //obtiene ruta donde se alojara archivo
                carpeta_preliq = REPOSIT_PRELIQ();

                //nm_archivo_pgu = "CT_DATOS_PGU_" + periodo.ToString() + ".xlsx";

                //if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
                //{
                //    /* Crea el directorio */
                //    try
                //    {
                //        insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                //        Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                //    }
                //    catch (Exception ex)
                //    { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
                //}

                //Archivo = carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu;

                //if (File.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu))
                //{
                //    File.Delete(Archivo);
                //}
                //Arch_Desde = carpeta_conting_pgu + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu;
                //insert_log("Copiando archivo " + nm_archivo_pgu);
                //try
                //{
                //    File.Copy(Arch_Desde, Archivo);
                //}
                //catch (Exception ex)
                //{ insert_log("Error copiando archivo " + Archivo); }
                //int ll_periodo;

                //carpeta_conting_pgu = REPOSIT_PAGO_PGU(); /* obtiene ruta donde se alojara archivo */

                nm_archivo_pgu = "CT_DATOS_PGU_" + periodo.ToString() + ".xlsx";

                if (!Directory.Exists(carpeta_preliq + "\\" + periodo.ToString() + "\\"))
                {
                    /* Crea el directorio */
                    try
                    {
                        insert_log("Creando Directorio " + carpeta_preliq + "\\" + (periodo.ToString()));
                        Directory.CreateDirectory(carpeta_preliq + "\\" + periodo.ToString());
                    }
                    catch (Exception ex)
                    { insert_log("Error no pudo crear Directorio " + carpeta_preliq + "\\" + periodo.ToString() + " " + ex.Message); }
                }

                //nm_archivo_pgu = carpeta_conting_pgu + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu + ".xlsx";

                listaCT_PGU = clsConn.SelectCT_PGU(periodo);

                try
                {

                    archivo_excel = carpeta_preliq + "\\" + periodo.ToString() + "\\" + nm_archivo_pgu;
                    insert_log("Generando archivo " + archivo_excel);

                    var dt = new DataTable();

                    //elimina archivos preexistentes (*.XLSX) de la carpeta especificada
                    DirectoryInfo di = new DirectoryInfo(carpeta_preliq + "\\" + periodo.ToString());
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
        }

        public static void preliq_genera_pgu_bcoest(int periodo)
        {
            List<DateTime> fechas;
            List<CT_PGUBancoEstado> listaCT_PGUBancoEstado = new List<CT_PGUBancoEstado>();
            string carpeta_preliq = string.Empty;
            string archivoPGU_BcoEstado = string.Empty;
            int cont = 0;

            carpeta_preliq = REPOSIT_PRELIQ(); /* obtiene ruta donde se alojara archivo */

            fechas = obtiene_fec_pago(periodo);

            var array = fechas.ToArray();

            insert_log("Generación automatica de Archivos PGU del Bco Estado...");
            for (int i = 0; i < array.Count(); i++)
            {
                string fecha = array[i].ToString().Substring(0, 10);
                listaCT_PGUBancoEstado = clsConn.SelectCT_PGUBancoEstado(periodo, fecha);
                if (listaCT_PGUBancoEstado.Count() > 0)
                {
                    var arrayArch = listaCT_PGUBancoEstado.ToArray();
                    string[] lineas = new string[arrayArch.Count()];
                    archivoPGU_BcoEstado = carpeta_preliq + "\\" + periodo.ToString() + "\\" + "archivo_bco_estado_pgu_" + periodo.ToString() + "_" + fecha.Replace("-", "") + ".txt";
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

        static void proceso_final(int periodo)
        {
            string Archivo = string.Empty;
            string query = string.Empty;
            string usuario = string.Empty;
            string _dataSource = string.Empty;

            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                _dataSource = ConfigurationManager.AppSettings["DataSource"].ToString();

                OracleConnectionStringBuilder oracleConnectionStringBuilder = new OracleConnectionStringBuilder(_dataSource);
                usuario = oracleConnectionStringBuilder.UserID.ToString();
                query = "update pensiones.estadocontinpreliqrv ";
                query += "set plqr_id_estado = 2 ";
                query += "where plqr_per = " + periodo;
                query += " and UPPER(plqr_id_program) = UPPER('Preliquidacion') and plqr_id_estado = 1 ";
                query += " and plqr_id_usuario = lower(trim('" + usuario + "'))";
                query += " and trunc(plqr_fec_ejec) = trunc(sysdate)";

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
    }
}
