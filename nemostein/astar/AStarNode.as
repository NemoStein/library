package nemostein.astar
{
	
	public class AStarNode
	{
		static public const CLEAR:int = 0;
		static public const OPENED:int = 1;
		static public const CLOSED:int = 2;
		
		public var e:int;
		public var f:int;
		public var g:int;
		public var h:int;
		public var x:int;
		public var y:int;
		
		public var state:int;
		public var block:Boolean;
		public var parent:AStarNode;
		
		public function AStarNode(x:int, y:int, cost:int, block:Boolean)
		{
			this.x = x;
			this.y = y;
			
			this.block = block;
			e = cost;
		}
		
		public function reset():void
		{
			f = 0;
			g = 0;
			h = 0;
			
			state = CLEAR;
			parent = null;
		}
		
		public function toString():String
		{
			var string:String = "[Cell(" + x + ", " + y + ")";
			
			if (block)
			{
				string += " block";
			}
			else
			{
				string += " e=" + e + " f=" + f + " g=" + g + " h=" + h;
				
				switch (state)
				{
					case CLEAR: 
					{
						string += " clear";
						break;
					}
					
					case OPENED: 
					{
						string += " opened";
						break;
					}
					
					case CLOSED: 
					{
						string += " closed";
						break;
					}
				}
			}
			
			if (parent)
			{
				string += " parent=(" + parent.x + ", " + parent.y + ")";
			}
			
			string += "]";
			
			return string;
		}
	}
}