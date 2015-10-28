using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    enum NodeType
    {
        Start,
        Finish,
        Empty,
        Nothing,
        Return,
        UserDefined
    }

    class Node : Statement
    {
        public static readonly Node Start = new Node(NodeType.Start);
        public static readonly Node Finish = new Node(NodeType.Finish);
        public static readonly Node Empty = new Node(NodeType.Empty);
        public static readonly Node Nothing = new Node(NodeType.Nothing);
        public static readonly Node Return = new Node(NodeType.Return);

        public string Name { get; }
        public NodeType Type { get; }

        public Node(string name)
        {
            Contract.Requires(!string.IsNullOrWhiteSpace(name));
            Name = name;
            Type = NodeType.UserDefined;
        }

        private Node(NodeType type)
        {
            Type = type;
            if (Type == NodeType.Empty)
                Name = "E";
            if (Type == NodeType.Nothing)
                Name = "N";
            if (Type == NodeType.Return)
                Name = "R";
        }

        public override string ToString()
        {
            return Name;
        }
    }
}
