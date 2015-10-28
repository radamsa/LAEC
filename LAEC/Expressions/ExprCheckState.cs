using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class ExprCheckState : Expr
    {
        public Link Link { get; }

        public ExprCheckState(Link link)
        {
            Contract.Requires(null != link);
            Link = link;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return $"{Link}";
        }
    }
}
