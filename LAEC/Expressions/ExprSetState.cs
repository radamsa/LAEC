using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class ExprSetState : Expr
    {
        public Link Link { get; }
        public bool State { get; }

        public ExprSetState(Link link, bool state)
        {
            Link = link;
            State = state;
        }

        public override string ToString()
        {
            return Link + " <- " + State;
        }

		public override String Compile()
		{
			return Link.Compile( State );
		}
	}
}
