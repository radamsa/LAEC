//
// Файл Startup.cs
// Точка входа
//

using System;
using System.Threading;

namespace Solution
{
	class Startup
	{
		private static void Main()
		{
			##Init##

			State.Start = true;

			Console.ReadLine();

			State.Finish = true;
		}
	}
}
