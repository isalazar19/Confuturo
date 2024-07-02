using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace preliquidacion.Data
{
    public class preliqOutputDto
    {
        public List<Preliq_Batch> preliq_batch { get; set; }

        public List<Preliq_RJEmiarch> preliq_RJemiarch { get; set; }

        public List<PreLiq_PagRegBen> preliq_PagRegBen { get; set; }
    }
}
