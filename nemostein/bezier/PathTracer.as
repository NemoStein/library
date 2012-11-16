package nemostein.bezier
{
	import flash.display.DisplayObject;
	
	public class PathTracer
	{
		private var step:Number;
		private var accum:Number = 0;
		
		private var segmentIndex:int = 0;
		private var numSegments:int;
		
		private var target:DisplayObject;
		private var path:Vector.<QuadBezierSegment>;
		private var segment:QuadBezierSegment;
		private var arcLength:Number;
		
		private var t:Number;
		
		public function PathTracer(target:DisplayObject, path:Vector.<QuadBezierSegment>, speed:Number)
		{
			step = speed || 0;
			this.target = target;
			this.path = path;
			
			numSegments = path.length;
			
			segment = path[segmentIndex];
			segment.interpolateObject(target, 0);
			
			arcLength = segment.getLength();
		}
		
		public function interpolate():void
		{
			accum += step;
			t = accum / arcLength;
			
			if (t > 1)
			{
				segmentIndex = (segmentIndex + 1) % numSegments;
				segment = path[segmentIndex];
				
				accum -= arcLength;
				arcLength = segment.getLength();
				t = accum / arcLength;
			}
			
			segment.interpolateObject(target, t);
		}
	}
}