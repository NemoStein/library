package nemostein.bezier
{
	import flash.geom.Point;
	
	public class Path
	{
		private var _segments:Vector.<QuadBezierSegment>;
		private var _length:Number;
		
		public function Path()
		{
			_length = 0;
			_segments = new Vector.<QuadBezierSegment>();
		}
		
		public function addSegment(ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number):void
		{
			var quadBezierSegment:QuadBezierSegment = new QuadBezierSegment(ax, ay, bx, by, cx, cy);
			
			_length += quadBezierSegment.length;
			
			_segments.push(quadBezierSegment);
		}
		
		public function interpolate(distance:Number, reverse:Boolean, result:Point):Boolean
		{
			var index:int;
			var currentLength:Number = 0;
			var currentSegment:QuadBezierSegment;
			
			if(!reverse)
			{
				currentSegment = _segments[0];
				
				while (currentLength + currentSegment.length < distance)
				{
					if (++index == _segments.length)
					{
						return false;
					}
					
					currentLength += currentSegment.length;
					currentSegment = _segments[index];
				}
				
				currentSegment.interpolate((distance - currentLength) / currentSegment.length, result);
			}
			else
			{
				index = _segments.length - 1;
				currentSegment = _segments[index];
				
				while (currentLength + currentSegment.length < distance)
				{
					if (--index < 0)
					{
						return false;
					}
					
					currentLength += currentSegment.length;
					currentSegment = _segments[index];
				}
				
				currentSegment.interpolate(1 - (distance - currentLength) / currentSegment.length, result);
			}
			
			return true;
		}
	}
}