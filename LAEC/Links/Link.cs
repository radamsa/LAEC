using System;
using System.Collections.Generic;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class Link : Statement
    {
        public static readonly Link Start = new Link(true);
        public static readonly Link Finish = new Link(false);

        private readonly bool m_isStart;

        public Node Source { get; }
        public Node Target { get; }

        public bool IsStart => null == Source && null == Target && m_isStart;
        public bool IsFinish => null == Source && null == Target && !m_isStart;

        private Link(bool isStart)
        {
            m_isStart = isStart;
            Source = null;
            Target = null;
        }

        public Link(Node source, Node target)
        {
            Contract.Requires(null != source);
            Contract.Requires(null != target);
            Source = source;
            Target = target;
        }

        public override string ToString()
        {
            if (IsStart)
                return "Start";
            if (IsFinish)
                return "Finish";
            return $"<unknown link>({Source}, {Target})";
        }
    }
}
