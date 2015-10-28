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
            try
            {
                var scanner = new Scanner();
                var parser = new Parser(scanner);

                //scanner.SetSource("qS0 = [Start] ({ Start <-false; S0; T(S0, S1) <-true } | R);", 0);
                scanner.SetSource(File.OpenRead("test.lae"));
                if (parser.Parse())
                {
                    Console.WriteLine("Success.");
                    foreach (var item in parser.ParseTree)
                        Console.WriteLine("stmt: {0}", item);
                }

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }

            //Console.WriteLine("Press ENTER ...");
            //Console.ReadLine();
        }
    }
}
