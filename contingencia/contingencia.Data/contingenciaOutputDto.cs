using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace contingencia.Data
{
    public class contingenciaOutputDto
    {
        public List<CT_TMP> ct_imp { get; set; }
        public List<CT_CasosRebajados> ct_casosrebajados { get; set; }
        public List<CT_PGUBancoEstado> Ct_PGUBancoEstado { get; set; }

        public List<CT_RJEmiarch> ct_RJemiarch { get; set; }
    }
}
