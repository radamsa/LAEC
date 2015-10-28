using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class TransLink : Link
    {
        public TransLink(Node source, Node target)
            : base(source, target)
        {
        }

        public override string ToString()
        {
            return "T(" + Source + ", " + Target + ")";
        }
    }
}
