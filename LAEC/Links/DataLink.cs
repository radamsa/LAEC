using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class DataLink : Link
    {
        public Type ValueType { get; }

        public DataLink(Node source, Node target)
            : base(source, target)
        {
        }

        public DataLink(Node source, Node target, Type valueType)
            : base(source, target)
        {
            ValueType = valueType;
        }

        public override string ToString()
        {
            return "D(" + Source + ", " + Target + ")";
        }

		public override String Compile()
		{
			return "D( \"" + Source + "\", \"" + Target + "\" )";
		}

		public override String Compile( bool State )
		{
			var s = String.Format(
				"D( \"{0}\", \"{1}\", {2} )",
				Source,
				Target,
				State ? "output" : "null"
			);
			
			return s;
		}
    }
}
