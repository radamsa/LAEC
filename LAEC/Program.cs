using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class Program
    {
        static void Main(string[] args)
        {
            var scanner = new Scanner();
            var parser = new Parser(scanner);

            scanner.SetSource("S0 <- false;", 0);
            if (parser.Parse())
                Console.WriteLine("Success.");

            Console.WriteLine(parser.ParseTree);
        }
    }
}
