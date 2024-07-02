using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace contingencia.Data
{
    public class CT_CasosRebajados
    {
        public int LQR_BCO { get; set; }
        public string LQR_CTA_BCO { get; set; }
        public int LQR_FRM_PAGO { get; set; }
        public int LQR_LOC_CNV { get; set; }
        public int NAT_NUMRUT { get; set; }
        public string NAT_DV { get; set; }
        public string NAT_AP_PAT { get; set; }
        public string NAT_AP_MAT { get; set; }
        public string NAT_NOMBRE { get; set; }
        public string DOM_DIRECCION { get; set; }
        public string DOM_COMUNA { get; set; }
        public string DOM_CIUDAD { get; set; }
        public decimal LQR_LQ { get; set; }
        public int LQR_POL { get; set; }
        public int LQR_GRP { get; set; }
        public string GLOSA { get; set; }
        //
        public int Poliza { get; set; }
        public string Rut { get; set; }
        public string NombreCompleto {get;set;}
        public string Direccion { get; set; }
        public string Comuna { get; set; }
        public string Ciudad { get; set; }
        public int GrupoDePago { get; set; }
        public decimal MontoLiquido { get; set; }
        public string GlosaRechazo { get; set; }

    }
}
