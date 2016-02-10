using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class ExprCall : Expr
    {
        public Node Node { get; }

        public ExprCall(Node node)
        {
            Contract.Requires(null != node);
            Node = node;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return Node.ToString();
        }

		public override String Compile()
		{
			return "var result = Run( input, out output );";
		}
    }
}
