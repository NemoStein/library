package nemostein.utils
{
	import flash.geom.Point;
	
	public final class MathUtils
	{
		[Inline]
		static public const PI2:Number = Math.PI * 2;
		
		[Inline]
		static public function rad(value:Number):Number
		{
			return Math.PI / 180 * value;
		}
		
		[Inline]
		static public function deg(value:Number):Number
		{
			return 180 / Math.PI * value;
		}
		
		[Inline]
		static public function piWrap(value:Number):Number
		{
			while (value > Math.PI)
			{
				value -= PI2;
			}
			
			while (value < -Math.PI)
			{
				value += PI2;
			}
			
			return value;
		}
		
		static public function isInsideTriangle(vertexA:Point, vertexB:Point, vertexC:Point, point:Point):Boolean
		{
			var planeAB:Number = (vertexA.x - point.x) * (vertexB.y - point.y) - (vertexB.x - point.x) * (vertexA.y - point.y);
			var planeBC:Number = (vertexB.x - point.x) * (vertexC.y - point.y) - (vertexC.x - point.x) * (vertexB.y - point.y);
			var planeCA:Number = (vertexC.x - point.x) * (vertexA.y - point.y) - (vertexA.x - point.x) * (vertexC.y - point.y);
			
			var signAB:int = planeAB > 0 ? 1 : planeAB < 0 ? -1 : 0;
			var signBC:int = planeBC > 0 ? 1 : planeBC < 0 ? -1 : 0;
			var signCA:int = planeCA > 0 ? 1 : planeCA < 0 ? -1 : 0;
			
			return signAB == signBC && signBC == signCA;
		}
		
		static public function isInsidePolygon(vertices:Vector.<Point>, point:Point):Boolean
		{
			var count:int = vertices.length;
			
			if (count < 3)
			{
				return false;
			}
			
			var top:Number = Infinity;
			var bottom:Number = -Infinity;
			var left:Number = Infinity;
			var right:Number = -Infinity;
			
			for (var i:int = 0; i < count; ++i)
			{
				var vertex:Point = vertices[i];
				
				if(vertex.y < top)
				{
					top = vertex.y;
				}
				
				if (vertex.y > bottom)
				{
					bottom = vertex.y;
				}
				
				if (vertex.x < left)
				{
					left = vertex.x;
				}
				
				if(vertex.x > right)
				{
					right = vertex.x;
				}
			}
			
			if (point.y < top || point.y > bottom || point.x < left || point.x > right)
			{
				return false;
			}
			
			for (var j:int = 1; j < count - 1; ++j)
			{
				if (isInsideTriangle(vertices[0], vertices[j], vertices[j + 1], point))
				{
					return true;
				}
			}
			
			return false;
		}
	}
}