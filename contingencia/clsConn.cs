using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OracleClient;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Configuration;
using contingencia.Data;

namespace contingencia
{
    class clsConn
    {
        public static OracleConnection ConectarBD()
        {
            string connection = ConfigurationManager.ConnectionStrings["confuturo"].ToString();

            return new OracleConnection(connection);
        }

        public static List<CT_TMP> SelectCT_TMP()
        {
            List<CT_TMP> lista = new List<CT_TMP>();
            //OracleConnection conn = new OracleConnection();
            try
            {
                string SQL = string.Empty;
                SQL += "SELECT ct_tmp.DATOS_ARCHBCOCHILE, ct_tmp.ORDEN ";
                SQL += " FROM ct_tmp ORDER BY 2";
                using (OracleConnection conn = clsConn.ConectarBD())
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand(SQL, conn);
                    OracleDataAdapter oracledataadapter = new OracleDataAdapter(cmd);
                    DataSet dataset = new DataSet();
                    oracledataadapter.Fill(dataset, "mitabla");
                    conn.Close();
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        CT_TMP objeto = new CT_TMP();
                        objeto.DATOS_ARCHBCOCHILE = row["DATOS_ARCHBCOCHILE"].ToString();
                        objeto.ORDEN = Convert.ToInt32(row["ORDEN"].ToString());
                        lista.Add(objeto);
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {

            }
            //conn.Close();
            return lista;
        }
        public static List<CT_CasosRebajados> SelectCT_CasosRebajados(int periodo)
        {
            List<CT_CasosRebajados> lista = new List<CT_CasosRebajados>();
            try
            {
                var query = "SP_CT_CASOS_REBAJADOS";
                using (OracleConnection conn = clsConn.ConectarBD())
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_periodo_new", OracleType.Number).Value = periodo;
                    cmd.Parameters.Add("v_tabla", OracleType.Cursor).Direction = ParameterDirection.Output;

                    OracleDataAdapter da = new OracleDataAdapter(cmd);
                    DataSet dataset = new DataSet();
                    da.Fill(dataset, "mitabla");
                    conn.Close();
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        CT_CasosRebajados objeto = new CT_CasosRebajados();
                        objeto.Poliza = Convert.ToInt32(row["LQR_POL"].ToString());
                        objeto.Rut = Convert.ToString(row["NAT_NUMRUT"].ToString()) + '-' + row["NAT_DV"].ToString();
                        objeto.NombreCompleto = row["NAT_NOMBRE"].ToString() + ' ' + row["NAT_AP_PAT"].ToString() + ' ' + row["NAT_AP_MAT"].ToString();
                        objeto.Direccion = row["DOM_DIRECCION"].ToString();
                        objeto.Comuna = row["DOM_CIUDAD"].ToString();
                        objeto.GrupoDePago = Convert.ToInt32(row["LQR_GRP"].ToString());
                        objeto.MontoLiquido = Convert.ToDecimal(row["LQR_LQ"].ToString());
                        objeto.GlosaRechazo = row["GLOSA"].ToString();
                        lista.Add(objeto);
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message.ToString());
            }
            finally
            { }
            return lista;
        }

        public static List<CT_PGU> SelectCT_PGU(int periodo)
        {
            List<CT_PGU> lista = new List<CT_PGU>();
            int longitud_cadena = 0;
            try
            {
                var query = "SP_CT_INF_PGU";
                using (OracleConnection conn = clsConn.ConectarBD())
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_periodo_new", OracleType.Number).Value = periodo;
                    cmd.Parameters.Add("v_tabla", OracleType.Cursor).Direction = ParameterDirection.Output;

                    OracleDataAdapter da = new OracleDataAdapter(cmd);
                    DataSet dataset = new DataSet();
                    da.Fill(dataset, "CT_INF_PGU");
                    conn.Close();
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        CT_PGU objeto = new CT_PGU();
                        objeto.campo = row["CAMPO"].ToString();
                        longitud_cadena = objeto.campo.Length;
                        if (longitud_cadena >= 491)
                        {
                            objeto.Periodo = row["CAMPO"].ToString().Substring(0, 6);
                            objeto.Rut_Ent_Pen_Reg = row["CAMPO"].ToString().Substring(6, 8);
                            objeto.Dv = row["CAMPO"].ToString().Substring(14, 1);
                            objeto.Rut_Benef = row["CAMPO"].ToString().Substring(15, 8); objeto.Rut_Benef = objeto.Rut_Benef.Replace(" ", "");
                            objeto.Dv_Ben = row["CAMPO"].ToString().Substring(23, 1);
                            objeto.Ape_Pat = row["CAMPO"].ToString().Substring(24, 20);
                            objeto.Ape_Mat = row["CAMPO"].ToString().Substring(44, 20);
                            objeto.Nombres = row["CAMPO"].ToString().Substring(64, 30);
                            objeto.Dir_Benef = row["CAMPO"].ToString().Substring(94, 45);
                            objeto.Com_Benef = row["CAMPO"].ToString().Substring(139, 5);
                            objeto.Ciudad_Benef = row["CAMPO"].ToString().Substring(144, 20);
                            objeto.Reg_Dom_Benef = row["CAMPO"].ToString().Substring(164, 2);
                            objeto.Num_Tel_Fijo = row["CAMPO"].ToString().Substring(166, 9);
                            objeto.Num_Tel_Movil = row["CAMPO"].ToString().Substring(175, 9);
                            objeto.Correo_Elect = row["CAMPO"].ToString().Substring(184, 45).Replace(((char)0x1F).ToString(), "");
                            objeto.Fec_Pag_Ult_Pen = row["CAMPO"].ToString().Substring(229, 8);
                            objeto.Forma_Pago = row["CAMPO"].ToString().Substring(237, 2);
                            objeto.Mod_Pago = row["CAMPO"].ToString().Substring(239, 2);
                            objeto.Rut_Ent_Pagadora = row["CAMPO"].ToString().Substring(241, 8);
                            objeto.Dv_Ent_Pag = row["CAMPO"].ToString().Substring(249, 1);
                            objeto.Com_Ent_Pag = row["CAMPO"].ToString().Substring(250, 5);
                            objeto.Reg_Ent_Pag = row["CAMPO"].ToString().Substring(255, 2);
                            objeto.Tipo_Cta_Banc_Benef = row["CAMPO"].ToString().Substring(257, 2);
                            objeto.Num_Cta_Banc_Benef = row["CAMPO"].ToString().Substring(259, 18) == "                  " ? "000000000000000000" : row["CAMPO"].ToString().Substring(259, 18);
                            objeto.Cobro_Mandatario = row["CAMPO"].ToString().Substring(277, 2);
                            objeto.Rut_Mandat = row["CAMPO"].ToString().Substring(279, 8);
                            objeto.Dv_mandat = row["CAMPO"].ToString().Substring(287, 1);
                            objeto.Pater_Mandat = row["CAMPO"].ToString().Substring(288, 20);
                            objeto.Mater_Mandat = row["CAMPO"].ToString().Substring(308, 20);
                            objeto.Nom_Mandat = row["CAMPO"].ToString().Substring(328, 30);
                            objeto.Dir_Mandat = row["CAMPO"].ToString().Substring(358, 45);
                            objeto.Comuna_mandat = row["CAMPO"].ToString().Substring(403, 5);
                            objeto.Cuidad_mandat = row["CAMPO"].ToString().Substring(408, 20);
                            objeto.Reg_Mandat = row["CAMPO"].ToString().Substring(428, 2);
                            objeto.Cod_Ent_Banc_Mandat = row["CAMPO"].ToString().Substring(430, 3);
                            objeto.Tip_Cta_Mandat = row["CAMPO"].ToString().Substring(433, 2);
                            objeto.Num_Cta_Mandat = row["CAMPO"].ToString().Substring(435, 18);
                            objeto.Mont_Desc_IPS = row["CAMPO"].ToString().Substring(453, 8);
                            objeto.Fec_Pag_Pensión = row["CAMPO"].ToString().Substring(461, 8);
                            objeto.Fec_Prox_Pag_Pens = row["CAMPO"].ToString().Substring(469, 8);
                            objeto.Cod_Etn_Banc_Benef = row["CAMPO"].ToString().Substring(477, 3);
                            objeto.Est_del_Pago = row["CAMPO"].ToString().Substring(480, 2);
                            objeto.RUN_Ent_pension = row["CAMPO"].ToString().Substring(482, 8);
                            objeto.DV_Ent = row["CAMPO"].ToString().Substring(490, 1);
                            objeto.Poliza = row["NUM_POLIZA"].ToString();
                            lista.Add(objeto);
                        }
                    }
                    conn.Close();

                }
            }
            catch (Exception ex)
            { }
            finally
            { }
            return lista;
        }

        public static List<CT_PGUBancoEstado> SelectCT_PGUBancoEstado(int periodo, string fecha)
        {
            List<CT_PGUBancoEstado> lista = new List<CT_PGUBancoEstado>();
            try
            {
                var query = "SP_CT_FECHAS_PAGO";
                using (OracleConnection conn = clsConn.ConectarBD())
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_periodo_new", OracleType.Number).Value = periodo;
                    cmd.Parameters.Add("p_fecha", OracleType.VarChar).Value = fecha;
                    cmd.Parameters.Add("v_tabla", OracleType.Cursor).Direction = ParameterDirection.Output;

                    OracleDataAdapter da = new OracleDataAdapter(cmd);
                    DataSet dataset = new DataSet();
                    da.Fill(dataset, "mitabla");
                    conn.Close();
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        CT_PGUBancoEstado objeto = new CT_PGUBancoEstado();
                        objeto.CAMPO = row["CAMPO"].ToString();
                        lista.Add(objeto);
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            { }
            finally
            { }
            return lista;
        }

        public static List<CT_RJEmiarch> Select_CT_RJEmiarch(int periodo)
        {
            List<CT_RJEmiarch> lista = new List<CT_RJEmiarch>();
            try
            {
                var query = "SP_CT_RJ_EMIARCH";
                using (OracleConnection conn = clsConn.ConectarBD())
                {
                    conn.Open();
                    OracleCommand cmd = new OracleCommand(query, conn);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("p_periodo_new", OracleType.Number).Value = periodo;
                    cmd.Parameters.Add("v_tabla", OracleType.Cursor).Direction = ParameterDirection.Output;

                    OracleDataAdapter da = new OracleDataAdapter(cmd);
                    DataSet dataset = new DataSet();
                    da.Fill(dataset, "mitabla");
                    conn.Close();
                    foreach (DataRow row in dataset.Tables[0].Rows)
                    {
                        CT_RJEmiarch objeto = new CT_RJEmiarch();
                        objeto.CAMPO = row["CAMPO"].ToString();
                        lista.Add(objeto);
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            { }
            finally
            { }

            return lista;
        }

        public static string NB_Empresa()
        {
            string retorno = string.Empty;
            OracleConnection conn = new OracleConnection();
            try
            {
                conn = clsConn.ConectarBD();
                conn.Open();

                string query = string.Empty;

                query = "SELECT InitCap(CIA_NOMB_CIA_COMP)";
                query += " FROM PENSIONES.COMPANIA";
                query += " WHERE CIA_VIGENCIA = 'S'";

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
    }
}
