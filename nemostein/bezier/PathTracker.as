package nemostein.bezier
{
	import flash.geom.Point;
	
	public class PathTracker
	{
		private var _path:Path;
		private var _position:Point;
		private var _reverse:Boolean;
		private var _distance:Number;
		
		public function PathTracker(path:Path, reverse:Boolean = false)
		{
			_path = path;
			_reverse = reverse;
			
			_position = new Point();
			
			_distance = 0;
		}
		
		public function move(speed:Number):Boolean
		{
			var forwardDistance:Number = _distance + speed;
			
			if (forwardDistance > _path.length)
			{
				forwardDistance -= _path.length;
				_path = !_reverse ? _path.next : _path.previous;
			}
			
			if(_path)
			{
				_distance = forwardDistance;
				_path.interpolate(forwardDistance, _reverse, _position);
				
				return true;
			}
			
			return false;
		}
		
		public function get path():Path 
		{
			return _path;
		}
		
		public function get x():Number 
		{
			return _position.x;
		}
		
		public function get y():Number 
		{
			return _position.y;
		}
	}
}