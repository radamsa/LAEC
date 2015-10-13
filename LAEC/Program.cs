using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LAEC
{
    class Program
    {
        static void Main(string[] args)
        {
            try {
                var scanner = new Scanner();
                var parser = new Parser(scanner);

                scanner.SetSource("[Start] ({ Start <-false; S0; T(S0, S1) <-true } | R);", 0);
                if (parser.Parse())
                    Console.WriteLine("Success.");

                Console.WriteLine(parser.ParseTree);
            }
            catch(Exception ex)
            {
                Console.WriteLine(ex);
            }

            //Console.WriteLine("Press ENTER ...");
            //Console.ReadLine();
        }
    }
}
