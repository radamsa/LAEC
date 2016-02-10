//
// Файл qS0.cs
// Сгенерированный файл состояния
//

using System;
using System.Threading;

namespace Solution
{
	class ##StateName## : State
	{
		public ##StateName##()
		{
			var thread = new Thread( StateThread );
			thread.Start();
		}

		public void StateThread()
		{
			while ( !Finish )
			{
				Object input = null;
				Object output = null;
				
				if ( !( ##StartCondition## ) )
				{
					Thread.Sleep( 1000 );
					continue;
				}

				##BeforeRun##

				// Всегда
				var result = Run( input, out output );

				##AfterRun##
			}
		}

		public bool Run( Object input, out Object output )
		{
			// Пользовательский код //
			
			Console.WriteLine( "##StateName##" );
			output = new Object();
			return true;

			// Пользовательский код //
		}
	}
}
