using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class CheckNodeResult : Expr
    {
        public Node Node { get; }
        public List<Expr> Left { get; }
        public List<Expr> Right { get; }

        public CheckNodeResult(Node node, List<Expr> left, List<Expr> right)
        {
            Contract.Requires(null != node);
            Contract.Requires(null != left);
            Contract.Requires(null != right);
            Node = node;
            Left = left;
            Right = right;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            var left = string.Join("; ", from i in Left select i.ToString());
            var right = string.Join("; ", from i in Right select i.ToString());

            return $"[Q({Node})]({left} | {right})";
        }
    }
}
