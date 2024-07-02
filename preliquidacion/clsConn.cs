using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.OracleClient;
using System.Data;
using System.Data.Common;
using System.Collections;
using System.Configuration;
using preliquidacion.Data;

namespace preliquidacion
{
    class clsConn
    {
        public static OracleConnection ConectarBD()
        {
            string connection = ConfigurationManager.ConnectionStrings["confuturo"].ToString();

            return new OracleConnection(connection);
        }

        public static List<Preliq_Batch> SelectPreliq_Batch()
        {
            List<Preliq_Batch> lista = new List<Preliq_Batch>();
            try
            {
                string SQL = string.Empty;
                SQL = "SELECT nvl(count(*),0) batch_ejecutado, plqr_per, INS_COD_CORRELATIVO";
                SQL += "    FROM ADMBATCH.ABATCH_INSCRIPCIONES,";
                SQL += "        ADMBATCH.ABATCH_PROCESOS,";
                SQL += "        pensiones.preliqrv";
                SQL += "    WHERE PRC_APLICACION = 'PENSIONES'";
                SQL += "    AND PRC_CODIGO = INS_PROCESO";
                SQL += "    AND INS_TIMESTAMP >= to_date('30/12/2019', 'dd/mm/yyyy')";
                SQL += "    and upper(trim(ins_proceso)) = 'RBLQS10'";

                SQL += "    and ins_timestamp >= (select to_date('01/' || to_char(prm_fec_desde, 'mm/yyyy'), 'dd/mm/yyyy') from pensiones.paramet_fechas"; /* COMENTAR ESTA FILA PARA PRD*/
                SQL += "                          where prm_fec_desde = prm_fec_hasta";                                                                    /* COMENTAR ESTA FILA PARA PRD*/
                SQL += "                          and prm_tipo_tabla = 'RVLIQ')";                                                                          /* COMENTAR ESTA FILA PARA PRD*/
                //SQL += "    and ins_timestamp between trunc(sysdate-49) and trunc(sysdate-33)"; /* COMENTAR ESTA FILA PARA PRD*/
                //SQL += "    and ins_timestamp between trunc(sysdate - 10) and trunc(sysdate+1)"; /* INSTRUCCION ORIGINAL NO VA */
                SQL += "    and ins_estado = 4";
                SQL += "    and ins_cod_correlativo = plqr_id_batch";
                SQL += "    and upper(trim(ins_proceso)) = upper(trim(plqr_id_program))";
                //SQL += "    and to_number(to_char(sysdate, 'HH24')) >= to_number((select cod_int_char";
                //SQL += "                                                from pensiones.codigos";
                //SQL += "                                            where cod_template like '%HORA_PRELIQ%'))";
                //SQL += "    and to_number(to_char(sysdate, 'HH24')) <= (to_number((select cod_int_char";               /* DESCOMENTAR PARA PRD */
                //SQL += "	        								      from pensiones.codigos";                       /* DESCOMENTAR PARA PRD */
                //SQL += "     										      where cod_template like '%HORA_PRELIQ%'))+4)"; /* DESCOMENTAR PARA PRD */
                SQL += "    and rownum <= 1";
                SQL += "    group by plqr_per, INS_COD_CORRELATIVO";

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
                        Preliq_Batch objeto = new Preliq_Batch();
                        objeto.batch_ejecutado = Convert.ToInt32(row["BATCH_EJECUTADO"].ToString());
                        objeto.preliq_per = Convert.ToInt32(row["PLQR_PER"].ToString());
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

        public static List<Preliq_RJEmiarch> Select_Preliq_RJEmiarch(int periodo)
        {
            List<Preliq_RJEmiarch> lista = new List<Preliq_RJEmiarch>();
            try
            {
                var query = "SP_PRELIQ_RJ_EMIARCH_CF";
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
                        Preliq_RJEmiarch objeto = new Preliq_RJEmiarch();
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

        public static List<Preliq_TMP> SelectPreliq_TMP()
        {
            List<Preliq_TMP> lista = new List<Preliq_TMP>();
            //OracleConnection conn = new OracleConnection();
            try
            {
                string SQL = string.Empty;
                SQL += "SELECT  preliq_tmp.DATOS_ARCHBCOCHILE,  preliq_tmp.ORDEN ";
                SQL += " FROM  preliq_tmp ORDER BY 2";
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
                        Preliq_TMP objeto = new Preliq_TMP();
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

        public static List<Preliq_PagReg> Select_Preliq_PagReg(int periodo)
        {
            List<Preliq_PagReg> lista = new List<Preliq_PagReg>();
            try
            {
                var query = "SP_PRELIQ_PAGREG";
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
                        Preliq_PagReg objeto = new Preliq_PagReg();
                        objeto.liqrv_poliza = row["POLIZA"].ToString();
                        objeto.liqrv_grupo = row["GRUPO"].ToString();
                        objeto.causalidad_inicial = row["CAUSALIDAD_INICIAL"].ToString();
                        objeto.persnat_causalidad_actual = row["CAUSALIDAD_ACTUAL"].ToString();
                        objeto.relacion = row["RELACION"].ToString();
                        objeto.pns_ref = row["PNS_REF"].ToString() == "" ? "" : row["PNS_REF"].ToString();
                        objeto.asegafp_fec_garant = row["FEC_GARANT"].ToString() == "" ? "" : row["FEC_GARANT"].ToString().Substring(0, 10);
                        objeto.persnat_nomcau = row["NOMCAU"].ToString();
                        objeto.persnat_rutcau = row["RUTCAU"].ToString() == "" ? "" : row["RUTCAU"].ToString();
                        objeto.persnat_dvcau = row["DVCAU"].ToString();
                        objeto.persnat_nombrecep = row["NOMBRECEP"].ToString();
                        objeto.persnat_rutreecp = row["RUTREECP"].ToString() == "" ? "" : row["RUTREECP"].ToString();
                        objeto.persnat_dvrecep = row["DVRECEP"].ToString();
                        objeto.tippen = row["TIPPEN"].ToString();
                        objeto.pbase_uf = row["PBASE_UF"].ToString() == "" ? "" : row["PBASE_UF"].ToString();
                        objeto.pbase_pes = row["PBASE_PES"].ToString() == "" ? "" : row["PBASE_PES"].ToString();
                        objeto.bono_postlaboral = row["BONO_POSTLABORAL"].ToString() == "" ? "" : row["BONO_POSTLABORAL"].ToString();
                        objeto.bono_clase_media = row["BONO_CLASE_MEDIA"].ToString() == "" ? "" : row["BONO_CLASE_MEDIA"].ToString();
                        objeto.aps = row["APS"].ToString() == "" ? "" : row["APS"].ToString();
                        objeto.pgu = row["PGU"].ToString() == "" ? "" : row["PGU"].ToString();
                        objeto.bono_compensatorio = row["BONO_COMPENSATORIO"].ToString() == "" ? "" : row["BONO_COMPENSATORIO"].ToString();
                        objeto.bono_agui_aps = row["BONO_AGUI_APS"].ToString() == "" ? "" : row["BONO_AGUI_APS"].ToString();
                        objeto.ge = row["GE"].ToString() == "" ? "" : row["GE"].ToString();
                        objeto.af = row["AF"].ToString() == "" ? "" : row["AF"].ToString();
                        objeto.retro_pnc = row["RETRO_PNC"].ToString() == "" ? "" : row["RETRO_PNC"].ToString();
                        objeto.otros_hab = row["OTROS_HAB"].ToString() == "" ? "" : row["OTROS_HAB"].ToString();
                        objeto.tot_hab = row["TOT_HAB"].ToString() == "" ? "" : row["TOT_HAB"].ToString();
                        objeto.dsc_salud = row["DSC_SALUD"].ToString() == "" ? "" : row["DSC_SALUD"].ToString();
                        objeto.dsc_ge = row["DSC_GE"].ToString() == "" ? "" : row["DSC_GE"].ToString();
                        objeto.dsc_af = row["DSC_AF"].ToString() == "" ? "" : row["DSC_AF"].ToString();
                        objeto.impto = row["IMPTO"].ToString() == "" ? "" : row["IMPTO"].ToString();
                        objeto.dsc_aps = row["IMPTO"].ToString() == "" ? "" : row["IMPTO"].ToString();
                        objeto.dsc_pgu = row["DSC_PGU"].ToString() == "" ? "" : row["DSC_PGU"].ToString();
                        objeto.credito_ing = row["CREDITO_ING"].ToString() == "" ? "" : row["CREDITO_ING"].ToString();
                        objeto.ccaf = row["CCAF"].ToString() == "" ? "" : row["CCAF"].ToString();
                        objeto.ret_jud = row["RET_JUD"].ToString() == "" ? "" : row["RET_JUD"].ToString();
                        objeto.seguro_pensionado = row["SEGURO_PENSIONADO"].ToString() == "" ? "" : row["SEGURO_PENSIONADO"].ToString();
                        objeto.otros_dsc = row["OTROS_DSC"].ToString() == "" ? "" : row["OTROS_DSC"].ToString();
                        objeto.tot_dsc = row["TOT_DSC"].ToString() == "" ? "" : row["TOT_DSC"].ToString();
                        objeto.liqrv_liq_pag = row["LIQ_PAG"].ToString() == "" ? "" : row["LIQ_PAG"].ToString();
                        objeto.liqrv_f_pago = row["F_PAGO"].ToString();
                        objeto.pm_ge_aps_imp_7 = row["PM_GE_APS_IMP_7"].ToString() == "" ? "" : row["PM_GE_APS_IMP_7"].ToString();
                        objeto.forma_pago_forma_pago = row["FORMA_PAGO"].ToString();
                        objeto.liqrv_lqr_frm_pago = row["LQR_FRM_PAGO"].ToString() == "" ? "" : row["LQR_FRM_PAGO"].ToString();
                        objeto.codigos_banco = row["BANCO"].ToString();
                        objeto.suc_bco = row["SUC_BCO"].ToString();
                        objeto.liqrv_lqr_cta_bco = row["LQR_CTA_BCO"].ToString();
                        objeto.codigos_medio_pago_bcochile = row["MEDIO_PAGO_BCOCHILE"].ToString();
                        objeto.fecha_pago_contrato = row["fecha_pago_contrato"].ToString() == "" ? "" : row["fecha_pago_contrato"].ToString().Substring(0, 10);
                        objeto.bonif_salud_mes = row["bonif_salud_mes"].ToString() == "" ? "" : row["bonif_salud_mes"].ToString();
                        objeto.pgu_mes = row["pgu_mes"].ToString() == "" ? "" : row["pgu_mes"].ToString();
                        objeto.es_escalonada = row["es_escalonada"].ToString();
                        objeto.porc_pen_escalonada = row["porc_pen_escalonada"].ToString() == "" ? "" : row["porc_pen_escalonada"].ToString();
                        objeto.fec_term_escalonada = row["fec_term_escalonada"].ToString() == "" ? "" : row["fec_term_escalonada"].ToString().Substring(0, 10);
                        lista.Add(objeto);
                    }
                    conn.Close();

                }
            }
            catch (Exception ex)
            { Console.WriteLine("Hubo un error al extraer datos del SP_PRELIQ_PAGREG"); }
            finally
            { }
            return lista;
        }

        public static List<PreLiq_PagRegBen> Select_Preliq_PagRegBen(int periodo)
        {
            List<PreLiq_PagRegBen> lista = new List<PreLiq_PagRegBen>();
            try
            {
                var query = "SP_PRELIQ_PAGREG_BEN";
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
                        PreLiq_PagRegBen objeto = new PreLiq_PagRegBen();
                        objeto.liqrv_poliza = row["POLIZA"].ToString();
                        objeto.liqrv_grupo = row["GRUPO"].ToString();
                        objeto.persnat_nomcau = row["NOMCAU"].ToString();
                        objeto.persnat_rutcau = row["RUTCAU"].ToString() == "" ? "" : row["RUTCAU"].ToString();
                        objeto.persnat_dvcau = row["DVCAU"].ToString();
                        objeto.persnat_nombrecep = row["NOMBRECEP"].ToString();
                        objeto.persnat_rutreecp = row["RUTREECP"].ToString() == "" ? "" : row["RUTREECP"].ToString();
                        objeto.persnat_dvrecep = row["DVRECEP"].ToString();
                        objeto.ben_nomb_benef = row["NOMB_BENEF"].ToString();
                        objeto.ben_rut_benef = row["RUT_BENEF"].ToString() == "" ? "" : row["RUT_BENEF"].ToString();
                        objeto.ben_dv_benef = row["DV_BENEF"].ToString();
                        objeto.causalidad_inicial = row["CAUSALIDAD_INICIAL"].ToString();
                        objeto.persnat_causalidad_actual = row["CAUSALIDAD_ACTUAL"].ToString();
                        objeto.relacion = row["RELACION"].ToString();
                        objeto.asegafp_fec_garant = row["FEC_GARANT"].ToString() == "" ? "" : row["FEC_GARANT"].ToString().Substring(0, 10);
                        objeto.pns_ref = row["PNS_REF"].ToString() == "" ? "" : row["PNS_REF"].ToString();
                        objeto.tippen = row["TIPPEN"].ToString();
                        objeto.p_pbase_uf = row["PBASE_UF"].ToString() == "" ? "" : row["PBASE_UF"].ToString();
                        objeto.pbase_pes = row["PBASE_$"].ToString() == "" ? "" : row["PBASE_$"].ToString();
                        objeto.bono_postlaboral = row["BONO_POSTLABORAL"].ToString() == "" ? "" : row["BONO_POSTLABORAL"].ToString();
                        objeto.aps = row["APS"].ToString() == "" ? "" : row["APS"].ToString();
                        objeto.pgu = row["PGU"].ToString() == "" ? "" : row["PGU"].ToString();
                        objeto.bono_compensatorio = row["BONO_COMPENSATORIO"].ToString() == "" ? "" : row["BONO_COMPENSATORIO"].ToString();
                        objeto.bono_agui_aps = row["BONO_AGUI_APS"].ToString() == "" ? "" : row["BONO_AGUI_APS"].ToString();
                        objeto.dsc_ge = row["DSC_GE"].ToString() == "" ? "" : row["DSC_GE"].ToString();
                        objeto.dsc_af = row["DSC_AF"].ToString() == "" ? "" : row["DSC_AF"].ToString();
                        objeto.retro_pnc = row["RETRO_PNC"].ToString() == "" ? "" : row["RETRO_PNC"].ToString();
                        objeto.bono_clase_media = row["BONO_CLASE_MEDIA"].ToString() == "" ? "" : row["BONO_CLASE_MEDIA"].ToString();
                        objeto.otros_hab = row["OTROS_HAB"].ToString() == "" ? "" : row["OTROS_HAB"].ToString();
                        objeto.tot_hab = row["TOT_HAB"].ToString() == "" ? "" : row["TOT_HAB"].ToString();
                        objeto.dsc_salud = row["DSC_SALUD"].ToString() == "" ? "" : row["DSC_SALUD"].ToString();
                        objeto.dsc_ge = row["DSC_GE"].ToString() == "" ? "" : row["DSC_GE"].ToString();
                        objeto.dsc_af = row["DSC_AF"].ToString() == "" ? "" : row["DSC_AF"].ToString();
                        objeto.impto = row["IMPTO"].ToString() == "" ? "" : row["IMPTO"].ToString();
                        objeto.dsc_aps = row["DSC_APS"].ToString() == "" ? "" : row["DSC_APs"].ToString();
                        objeto.dsc_pgu = row["DSC_PGU"].ToString() == "" ? "" : row["DSC_PGU"].ToString();
                        objeto.credito_ing = row["CREDITO_ING"].ToString() == "" ? "" : row["CREDITO_ING"].ToString();
                        objeto.ccaf = row["CCAF"].ToString() == "" ? "" : row["CCAF"].ToString();
                        objeto.ret_jud = row["RET_JUD"].ToString() == "" ? "" : row["RET_JUD"].ToString();
                        objeto.seguro_pensionado = row["SEGURO_PENSIONADO"].ToString() == "" ? "" : row["SEGURO_PENSIONADO"].ToString();
                        objeto.otros_dsc = row["OTROS_DSC"].ToString() == "" ? "" : row["OTROS_DSC"].ToString();
                        objeto.tot_dsc = row["TOT_DSC"].ToString() == "" ? "" : row["TOT_DSC"].ToString();
                        objeto.mto_liquido = row["MTO_LIQUIDO"].ToString() == "" ? "" : row["MTO_LIQUIDO"].ToString();
                        objeto.liqrv_f_pago = row["F_PAGO"].ToString();
                        objeto.pb_ge_aps_imp_7pc = row["PB_GE_APS_IMP_7PC"].ToString() == "" ? "" : row["PB_GE_APS_IMP_7PC"].ToString();
                        objeto.forma_pago_forma_pago = row["FORMA_PAGO"].ToString();
                        objeto.cta_bco = row["CTA_BCO"].ToString();
                        objeto.codigos_banco = row["BANCO"].ToString();
                        objeto.sucursal = row["SUCURSAL"].ToString();
                        objeto.codigos_medio_pago_bcochile = row["MEDIO_PAGO_BCOCHILE"].ToString();
                        objeto.fecha_pago_contrato = row["fecha_pago_contrato"].ToString() == "" ? "" : row["fecha_pago_contrato"].ToString().Substring(0, 10);
                        objeto.bonif_salud_mes = row["bonif_salud_mes"].ToString() == "" ? "" : row["bonif_salud_mes"].ToString();
                        objeto.pgu_mes = row["pgu_mes"].ToString() == "" ? "" : row["pgu_mes"].ToString();
                        objeto.tot_proporc = row["TOT_PROPORC"].ToString() == "" ? "" : row["TOT_PROPORC"].ToString();
                        objeto.es_escalonada = row["es_escalonada"].ToString();
                        objeto.porc_pen_escalonada = row["porc_pen_escalonada"].ToString() == "" ? "" : row["porc_pen_escalonada"].ToString();
                        objeto.fec_term_escalonada = row["fec_term_escalonada"].ToString() == "" ? "" : row["fec_term_escalonada"].ToString().Substring(0, 10);
                        lista.Add(objeto);
                    }
                    conn.Close();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Hubo un error al extraer datos del SP_PRELIQ_PAGREGBEN");
            }
            finally
            {
            }
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

                query =  "SELECT InitCap(CIA_NOMB_CIA_COMP)";
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

    }
}
