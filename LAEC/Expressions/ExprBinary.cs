using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    internal enum ExprOp
    {
        And,
        Or
    }

    internal class ExprBinary : Expr
    {
        public ExprOp Op { get; }
        public Expr Left { get; }
        public Expr Right { get; }

        public ExprBinary(ExprOp op, Expr left, Expr right)
        {
            Contract.Requires(null != left);
            Contract.Requires(null != right);
            Op = op;
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
            string opSign;
            switch (Op)
            {
                case ExprOp.And:
                    opSign = "&";
                    break;
                case ExprOp.Or:
                    opSign = "|";
                    break;
                default:
                    throw new InvalidOperationException( String.Format( "Неизвестный знак '{0}' в выражении.", Op ) );
            }

            return String.Format( "{0} {1} {2}", Left, opSign, Right );
        }

		public override String Compile()
        {
            string opSign;
            switch (Op)
            {
                case ExprOp.And:
                    opSign = " && ";
                    break;
                case ExprOp.Or:
                    opSign = " || ";
                    break;
                default:
                    throw new InvalidOperationException( String.Format( "Неизвестный знак '{0}' в выражении.", Op ) );
            }

            return Left.Compile() + opSign + Right.Compile();
        }
    }
}
