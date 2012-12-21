package nemostein.bezier
{
	import flash.geom.Point;
	
	public class Path
	{
		private var _quadBezierSegment:QuadBezierSegment;
		private var _length:Number;
		
		private var _forward:Vector.<Path>;
		private var _backward:Vector.<Path>;
		
		public var id:int;
		
		public function Path(start:Point, end:Point, anchor:Point, id:int)
		{
			this.id = id;
			
			_quadBezierSegment = new QuadBezierSegment(start.x, start.y, end.x, end.y,  anchor.x, anchor.y);
			_length = _quadBezierSegment.length;
			
			_forward = new Vector.<Path>();
			_backward = new Vector.<Path>();
		}
		
		public function interpolate(distance:Number, reverse:Boolean, resultPosition:Point):Boolean
		{
			var ratio:Number = distance / _length;
			
			if (reverse)
			{
				ratio = 1 - ratio;
			}
			
			var path:Path = this;
			
			if (ratio > 1)
			{
				path = next;
			}
			else if (ratio < 0)
			{
				path = previous;
			}
			
			if (path)
			{
				path._quadBezierSegment.interpolate(ratio, resultPosition);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function addPath(path:Path):void
		{
			_forward.push(path);
			path._backward.push(this);
		}
		
		public function get next():Path 
		{
			if (_forward.length)
			{
				return _forward[int(Math.random() * _forward.length)];
			}
			
			return null;
		}
		
		public function get previous():Path 
		{
			if (_backward.length)
			{
				return _backward[int(Math.random() * _backward.length)];
			}
			
			return null;
		}
		
		public function get length():Number 
		{
			return _length;
		}
		
		public function get quadBezierSegment():QuadBezierSegment 
		{
			return _quadBezierSegment;
		}
		
		public function get forward():Vector.<Path> 
		{
			return _forward;
		}
		
		public function get backward():Vector.<Path> 
		{
			return _backward;
		}
		
		public function toString():String 
		{
			return "[Path " + id + "]";
		}
	}
}