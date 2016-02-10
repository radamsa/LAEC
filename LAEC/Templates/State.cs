//
// Файл State.cs
// Базовый класс для состояний
//

using System;
using System.Collections.Generic;
using System.Collections.Concurrent;

namespace Solution
{
	class State
	{
		//======================================================================
		// Поля
		//======================================================================

		private static bool finish = false;
		private static Object runningLock = new Object();
		private static bool start = false;
		private static Object startLock = new Object();
		private static ConcurrentDictionary<String, bool> links;
		private static ConcurrentDictionary<String, Object> data;

		//======================================================================
		// Свойства
		//======================================================================

		public static bool Start
		{
			get { lock ( startLock ) { return start; } }
			set { lock ( startLock ) { start = value; } }
		}

		public static bool Finish
		{
			get { lock ( runningLock ) { return finish; } }
			set { lock ( runningLock ) { finish = value; } }
		}

		//======================================================================
		// Статический конструктор
		//======================================================================

		static State()
		{
			links = new ConcurrentDictionary<String, bool>();
			data = new ConcurrentDictionary<String, Object>();
		}
		
		//======================================================================
		// Методы
		//======================================================================
		
		public void T( String Sa, String Sb, bool State )
		{
			links[Sa + Sb] = State;
		}

		public bool T( String Sa, String Sb )
		{
			try
			{
				return links[Sa + Sb];
			}

			catch ( KeyNotFoundException )
			{
				return false;
			}
		}

		public void D( String Sa, String Sb, Object Value )
		{
			data[Sa + Sb] = Value;
		}

		public Object D( String Sa, String Sb )
		{
			try
			{
				return data[Sa + Sb];
			}
			
			catch ( KeyNotFoundException )
			{
				return null;
			}
		}

		//======================================================================
	}
}
