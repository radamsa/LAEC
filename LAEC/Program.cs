
using System;
using System.IO;

namespace LAEC
{
    class Program
    {
		static int number = 0;

        static void Main(string[] args)
        {
            try
            {
                var scanner = new Scanner();
                var parser = new Parser(scanner);

                scanner.SetSource(File.OpenRead("test.lae"));
                if ( parser.Parse() )
                {
					String files = String.Empty;
					String init = String.Empty;
					String s = String.Empty;

                    foreach ( var item in parser.ParseTree )
					{
						String stateName = item.Target.Name;
						String startCondition = item.Expression.Condition.Compile();
						String beforeRun = String.Empty;
						String afterRun = String.Empty;

						bool before = true;

						for ( var i = 0; i < item.Expression.Iteration.Actors.Count; i++ )
						{
							if ( item.Expression.Iteration.Actors[i].GetType() == typeof( ExprCall ) )
							{
								before = false;
								continue;
							}

							if ( before )
							{
								beforeRun += item.Expression.Iteration.Actors[i].Compile() + ";\n";
							} else {
								afterRun += item.Expression.Iteration.Actors[i].Compile() + ";\n";
							}
						}

						s = File.ReadAllText( "..\\..\\Templates\\CommonState.cs" );

						s = s.Replace( "##StateName##", stateName );
						s = s.Replace( "##StartCondition##", startCondition );
						s = s.Replace( "##BeforeRun##", beforeRun );
						s = s.Replace( "##AfterRun##", afterRun );

						Directory.CreateDirectory( "Solution" );
                        File.WriteAllText( "Solution\\" + stateName + ".cs", s );

						files += "<Compile Include=\"" + stateName + ".cs\" />\n";
						init += "var s" + number.ToString() + " = new " + stateName + "();\n";
						number++;
					}

					s = File.ReadAllText( "..\\..\\Templates\\Solution.csproj" );
					s = s.Replace( "##Files##", files );
					File.WriteAllText( "Solution\\Solution.csproj", s );

					s = File.ReadAllText( "..\\..\\Templates\\Startup.cs" );
					s = s.Replace( "##Init##", init );
					File.WriteAllText( "Solution\\Startup.cs", s );

					File.Copy( "..\\..\\Templates\\State.cs", "Solution\\State.cs", true );
					File.Copy( "..\\..\\Templates\\Solution.sln", "Solution\\Solution.sln", true );
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
