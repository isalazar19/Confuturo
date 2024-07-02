using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

namespace ContingenciaCPB
{
    class Program
    {
        static DateTime fechaSistema = DateTime.Now;
        static void Main(string[] args)
        {
            try
            {
                int IdProceso = Convert.ToInt32(args[0]); //proceso;
                int IdEjecucion = Convert.ToInt32(args[1]); //ejecucion;
                int IdEtapa = Convert.ToInt32(args[2]); //etapa;
                string vNombreMetodo = args[3]; //NombreMetodo;

                switch (vNombreMetodo)
                {
                    case "EjecutarJobContingencia":
                        Console.WriteLine(fechaSistema + " " + "Inicio Contingencia");
                        EjecutarJobContingencia();
                        break;

                    case "EjecutarJobPreliq":
                        Console.WriteLine(fechaSistema + " " + "Inicio PreLiq");
                        EjecutarJobPreLiq();
                        break;

                    default:
                        throw new Exception("Etapa No Definida");
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public static void EjecutarJobContingencia()
        {
            string curDir = Path.GetDirectoryName(Application.ExecutablePath);
            //string curDir = Directory.GetCurrentDirectory();
            string _exe = "jobcontingencia.exe";
            //Console.WriteLine("{0}", curDir);

            Console.WriteLine("{0}" + " " + "Ejecución {1}", fechaSistema, _exe);

            curDir = curDir + "\\" + _exe;

            if (File.Exists(curDir))
            {
                System.Diagnostics.Process.Start(curDir);
            }
            else
            {
                //Console.WriteLine("ejecutable {0} no existe en la ruta especificada {1}", _exe, curDir);
                Console.WriteLine("{0}" + " " + "Error ejecutable {1} no existe en la ruta especificada {2}", fechaSistema, _exe, curDir);
                Console.WriteLine("{0}" + " " + "Fin ContingenciaCPB", fechaSistema);
            }
        }

        public static void EjecutarJobPreLiq()
        {
            string curDir = Path.GetDirectoryName(Application.ExecutablePath);
            //string curDir = Directory.GetCurrentDirectory();
            string _exe = "jobpreliq.exe";
            //Console.WriteLine("{0}", curDir);

            Console.WriteLine("{0}" + " " + "Ejecución {1}", fechaSistema, _exe);

            curDir = curDir + "\\" + _exe;

            if (File.Exists(curDir))
            {
                System.Diagnostics.Process.Start(curDir);
            }
            else
            {
                //Console.WriteLine("ejecutable {0} no existe en la ruta especificada {1}", _exe, curDir);
                Console.WriteLine("{0}" + " " + "Error ejecutable {1} no existe en la ruta especificada {2}", fechaSistema, _exe, curDir);
                Console.WriteLine("{0}" + " " + "Fin ContingenciaCPB", fechaSistema);
            }
        }
    }
}
