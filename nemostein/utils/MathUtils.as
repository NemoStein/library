package nemostein.utils
{
	public final class MathUtils
	{
		public static const PI2:Number = Math.PI * 2;
		
		public static function rad(value:Number):Number
		{
			return Math.PI / 180 * value;
		}
		
		public static function deg(value:Number):Number
		{
			return 180 / Math.PI * value;
		}
		
		public static function piWrap(value:Number):Number
		{
			while (value > Math.PI)
			{
				value -= PI2;
			}
			
			while(value < -Math.PI)
			{
				value += PI2;
			}
			
			return value;
		}
	}
}