using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class LAExpr : Statement
    {
        public Node Target { get; }
        public AlphaDisjuntion Expression { get; }

        public LAExpr(Node node, AlphaDisjuntion expression)
        {
            Target = node;
            Expression = expression;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return $"q{Target} = {Expression}";
        }
    }
}
