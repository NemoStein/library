package nemostein.bezier 
{

	public class Paths 
	{
		private var _forward:Vector.<Path>;
		private var _backward:Vector.<Path>;
		
		public function Paths(forward:Vector.<Path>, backward:Vector.<Path>) 
		{
			_forward = forward;
			_backward = backward;
		}
		
		public function getPath(reverse:Boolean = false, index:int = -1):Path
		{
			var paths:Vector.<Path> = reverse ? _backward : _forward;
			
			if (index >= 0 && index < paths.length)
			{
				return paths[index];
			}
			
			return paths[int(Math.random() * paths.length)];
		}
		
		public function get forward():Vector.<Path> 
		{
			return _forward;
		}
		
		public function get backward():Vector.<Path> 
		{
			return _backward;
		}
	}
}