using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
//using Excel = Microsoft.Office.Interop.Excel;
using ClosedXML.Excel;

namespace preliquidacion
{
    public class Util
    {
        public static bool EscribeArchivo(string Archivo, string[] array)
        {
            bool retorno = false;
            try
            {
                FileStream stream = new FileStream(Archivo, FileMode.OpenOrCreate, FileAccess.Write);
                StreamWriter sw = new StreamWriter(stream);
                //
                foreach (var s in array)
                {
                    sw.WriteLine(s);
                }
                sw.Close();
                retorno = true;
            }
            catch (Exception ex)
            { Console.WriteLine(ex.Message); }
            return retorno;
        }

        #region EXCEL
        /*
        public static void ExportToExcel(DataTable dt, string Archivo, string nombrehoja, string titulo)
        {
            DataSet dataSet = new DataSet();
            dataSet.Tables.Add(dt);

            // create a excel app along side with workbook and worksheet and give a name to it  
            Microsoft.Office.Interop.Excel.Application excelApp = new Excel.Application();
            Excel.Workbook excelWorkBook = excelApp.Workbooks.Add();
            Excel._Worksheet xlWorksheet = excelWorkBook.Sheets[1];
            Excel.Range xlRange = xlWorksheet.UsedRange;
            foreach (DataTable table in dataSet.Tables)
            {
                //Add a new worksheet to workbook with the Datatable name  
                Excel.Worksheet excelWorkSheet = excelWorkBook.Sheets.Add();
                excelWorkSheet.Name = nombrehoja;

                excelWorkSheet.Rows[1].Insert();
                excelWorkSheet.Cells[1, 1] = clsConn.NB_Empresa();
                excelWorkSheet.Cells[1, 12] = "Fecha Emisión: " + DateTime.Now.ToString();

                excelWorkSheet.Cells[3, 6] = titulo;

                // add all the columns  
                for (int i = 1; i < table.Columns.Count + 1; i++)
                {
                    excelWorkSheet.Cells[5, i] = table.Columns[i - 1].ColumnName;
                }

                // add all the rows  
                int fila = 0;
                for (int j = 0; j < table.Rows.Count; j++)
                {
                    for (int k = 0; k < table.Columns.Count; k++)
                    {
                        excelWorkSheet.Cells[j + 6, k + 1] = table.Rows[j].ItemArray[k].ToString();
                    }
                    fila = j + 6 + 2;
                }
                excelWorkSheet.Cells[fila, 1] = "Total de Registros: " + table.Rows.Count.ToString();
            }
            excelWorkBook.SaveAs(Archivo); // -> this will do the custom  
            excelWorkBook.Close();
            excelApp.Quit();
        }*/

        public static string ExportarExcelDetalle(string RutaArchivo, DataTable Datos, string vTitulo)
        {
            try
            {

                var wb = new XLWorkbook();
                System.Globalization.CultureInfo Clut_Original = System.Threading.Thread.CurrentThread.CurrentCulture;

                System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture("en-CL");

                var ws = wb.Worksheets.Add("Detalle");

                int Columna_A = 1;
                int Columna_H = 8;

                int Fila_1 = 1;
                int Fila_2 = 2;
                int Fila_3 = 3;

                int Fila_5 = 5;


                //cabecera

                int FilaFinal = Fila_5 + Datos.Rows.Count;
                int Columna_final = Datos.Columns.Count;
                ws.Cell(Fila_1, Columna_A).Value = clsConn.NB_Empresa();
                //TITULO
                ws.Cell(Fila_2, Columna_A).Value = vTitulo;
                ws.Cell(Fila_2, Columna_A).Style.Font.SetBold(true);
                ws.Cell(Fila_2, Columna_A).Style.Font.FontSize = 15;
                ws.Cell(Fila_2, Columna_A).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                ws.Range(Fila_2, Columna_A, Fila_2, Columna_final).Merge();

                ws.Cell(Fila_1, Columna_H).Value = "FECHA " + DateTime.Now.Day.ToString().PadLeft(2, '0') + "/" + DateTime.Now.Month.ToString().PadLeft(2, '0') + "/" + DateTime.Now.Year.ToString() + " " + DateTime.Now.ToString("hh:mm:ss tt");
                //ws.Cell(Fila_3, Columna_H).Style.Font.SetBold(true);
                //ws.Cell(Fila_3, Columna_H).Style.Font.FontSize = 15;
                ws.Cell(Fila_1, Columna_H).Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);
                ws.Range(Fila_1, Columna_H, Fila_1, Columna_final).Merge();



                //CABECERA TABLA
                //titulos grilla resultados

                var tableWithData = ws.Cell(Fila_5, Columna_A).InsertTable(Datos.AsEnumerable());
                ws.Range(Fila_5, Columna_A, Fila_5, Columna_final).AddToNamed("TituloDetalle");


                // Prepare the style for the titles
                var titlesStyle = wb.Style;
                titlesStyle.Font.Bold = true;
                titlesStyle.Alignment.Horizontal = XLAlignmentHorizontalValues.Center;


                titlesStyle.Fill.BackgroundColor = XLColor.FromName("Red");


                titlesStyle.Font.FontColor = XLColor.FromName("White");

                // Format all titles in one shot
                wb.NamedRanges.NamedRange("TituloDetalle").Ranges.Style = titlesStyle;

                //formato 
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.LeftBorder = XLBorderStyleValues.Thin;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.RightBorder = XLBorderStyleValues.Thin;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.BottomBorder = XLBorderStyleValues.Thin;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.TopBorder = XLBorderStyleValues.Thin;

                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.LeftBorderColor = XLColor.Black;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.RightBorderColor = XLColor.Black;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.BottomBorderColor = XLColor.Black;
                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Border.TopBorderColor = XLColor.Black;


                ws.Range(Fila_5, Columna_A, Fila_5, Columna_final).Style.Font.SetBold(true);

                ws.Range(Fila_5, Columna_A, FilaFinal, Columna_final).Style.Alignment.WrapText = true;

                ws.Columns().AdjustToContents();
                ws.SheetView.Freeze(Fila_5, 0);

                ws.PageSetup.Header.Center.AddText(vTitulo).SetBold();
                // ws.PageSetup.Header.Right.AddText(Entidad.VAR_GLOBAL.ParAccesoActivo.FechaSistema.Day.ToString().PadLeft(2, '0') + "/" + Entidad.VAR_GLOBAL.ParAccesoActivo.FechaSistema.Month.ToString().PadLeft(2, '0') + "/" + Entidad.VAR_GLOBAL.ParAccesoActivo.FechaSistema.Year.ToString()).SetBold();
                ws.PageSetup.Margins.Header = 0.30;
                ws.PageSetup.Footer.Right.AddText(XLHFPredefinedText.PageNumber, XLHFOccurrence.AllPages);
                ws.PageSetup.Margins.Footer = 0.15;
                //ws.PageSetup.Header.Right.AddText("The ", XLHFOccurrence.FirstPage).SetBold();
                ws.PageSetup.PageOrientation = XLPageOrientation.Landscape;
                ws.PageSetup.FitToPages(1, 30); // Alternatively you can use 


                wb.PageOptions.PageOrientation = XLPageOrientation.Portrait;

                wb.SaveAs(RutaArchivo);
                GC.Collect();
                System.Threading.Thread.CurrentThread.CurrentCulture = Clut_Original;
                return RutaArchivo;
            }
            catch (Exception Ex)
            {
                throw Ex;
            }


        }
        #endregion
    }
}
