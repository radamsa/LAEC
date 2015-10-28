using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class AlphaDisjuntion : Statement
    {
        public Expr Condition { get; }
        public AlphaIteration Iteration { get; }

        public AlphaDisjuntion(Expr condition, AlphaIteration iteration)
        {
            Contract.Requires(null != condition);
            Contract.Requires(null != iteration);
            Condition = condition;
            Iteration = iteration;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return $"[{Condition}]({Iteration})";
        }
    }
}
