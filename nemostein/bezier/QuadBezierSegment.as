package nemostein.bezier
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class QuadBezierSegment
	{
		private var _a:Point; // start anchor point
		private var _b:Point; // end anchor point
		private var _c:Point; // control point
		
		private var _length:Number; // arc length of the curve
		
		private var _startAngle:Number;
		private var _angularDisplacement:Number;
		
		/**
		 * Quadratic Bezier Segment.
		 *
		 * @param ax x-component of the start anchor point.
		 * @param ay y-component of the start anchor point.
		 * @param bx x-component of the end anchor point.
		 * @param by y-component of the end anchor point.
		 * @param cx x-component of the control point.
		 * @param cy y-component of the control point.
		 */
		public function QuadBezierSegment(ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number)
		{
			_a = new Point(ax, ay);
			_b = new Point(bx, by);
			_c = new Point(cx, cy);
			
			var ac:Point = _c.subtract(_a);
			var cb:Point = _b.subtract(_c);
			
			_startAngle = Math.atan2(ac.y, ac.x);
			
			_angularDisplacement = Math.acos((ac.x * cb.x + ac.y * cb.y) / (ac.length * cb.length));
			_angularDisplacement *= ((ac.x * cb.y - ac.y * cb.x) < 0) ? -1 : 1;
			
			_length = getArcLength(_a.x, _a.y, _b.x, _b.y, _c.x, _c.y);
		}
		
		/**
		 * Interpolate using DeCasteljau's Algorithm
		 */
		public function interpolate(t:Number, result:Point):void
		{
			// Original
			//var d:Point = Point.interpolate(_c, _a, t);
			//var e:Point = Point.interpolate(_b, _c, t);
			//var f:Point = Point.interpolate(e, d, t);
			//
			//return [f.x, f.y, (_startAngle + _angularDisplacement * t) * (180 / Math.PI)];
			
			// First optimization
			//var caX:Number = _a.x + t * (_c.x - _a.x);
			//var caY:Number = _a.y + t * (_c.y - _a.y);
			//
			//var bcX:Number = _c.x + t * (_b.x - _c.x);
			//var bcY:Number = _c.y + t * (_b.y - _c.y);
			//
			//var x:Number = caX + t * (bcX - caX);
			//var y:Number = caY + t * (bcY - caY);
			//
			//return [x, y, (_startAngle + _angularDisplacement * t) * (180 / Math.PI)];
			
			// Second optimization
			//return [
				//(_a.x + t * (_c.x - _a.x)) + t * ((_c.x + t * (_b.x - _c.x)) - (_a.x + t * (_c.x - _a.x))),
				//(_a.y + t * (_c.y - _a.y)) + t * ((_c.y + t * (_b.y - _c.y)) - (_a.y + t * (_c.y - _a.y))),
				//(_startAngle + _angularDisplacement * t) * (180 / Math.PI)
			//];
			
			// Third optimization
			result.x = (_a.x + t * (_c.x - _a.x)) + t * ((_c.x + t * (_b.x - _c.x)) - (_a.x + t * (_c.x - _a.x)));
			result.y = (_a.y + t * (_c.y - _a.y)) + t * ((_c.y + t * (_b.y - _c.y)) - (_a.y + t * (_c.y - _a.y)));
		}
		
		public function get length():Number
		{
			return _length;
		}
		
		static private function getArcLength(_ax:Number, _ay:Number, _bx:Number, _by:Number, _cx:Number, _cy:Number):Number
		{
			var ax:Number = _ax - 2 * _cx + _bx;
			var ay:Number = _ay - 2 * _cy + _by;
			var bx:Number = 2 * (_cx - _ax);
			var by:Number = 2 * (_cy - _ay);
			
			var a:Number = 4 * (ax * ax + ay * ay);
			var b:Number = 4 * (ax * bx + ay * by);
			var c:Number = bx * bx + by * by;
			
			var abc:Number = 2 * Math.sqrt(a + b + c);
			var a2:Number = Math.sqrt(a);
			var a32:Number = 2 * a * a2;
			var c2:Number = 2 * Math.sqrt(c);
			var ba:Number = b / a2;
			
			var length:Number = (a32 * abc + a2 * b * (abc - c2) + (4 * c * a - b * b) * Math.log((2 * a2 + ba + abc) / (ba + c2))) / (4 * a32);
			
			if(!length)
			{
				var pointA:Point = new Point(_ax, _ay);
				var pointB:Point = new Point(_bx, _by);
				
				length = Point.distance(pointA, pointB);
			}
			
			return length;
		}
	}
}