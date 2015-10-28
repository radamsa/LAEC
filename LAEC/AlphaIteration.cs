using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class AlphaIteration : Statement
    {
        public List<Expr> Actors { get; }
        public Node DutyNode { get; }

        public AlphaIteration(List<Expr> actors, Node dutyNode)
        {
            Contract.Requires(null != actors);
            Contract.Requires(null != dutyNode);
            Contract.Requires(dutyNode.Type != NodeType.UserDefined);
            Actors = actors;
            DutyNode = dutyNode;
        }

        /// <summary>
        /// Returns a string that represents the current object.
        /// </summary>
        /// <returns>
        /// A string that represents the current object.
        /// </returns>
        public override string ToString()
        {
            return "{" + string.Join("; ", from i in Actors select i.ToString()) + "} | " + DutyNode;
        }
    }
}
