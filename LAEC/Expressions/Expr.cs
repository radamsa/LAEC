using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    abstract class Expr : Statement
    {
		public abstract String Compile();
    }
}
