package sourbit.library.color
{
	
	public class Color
	{
		private var _alpha:int;
		private var _red:int;
		private var _green:int;
		private var _blue:int;
		
		public function Color(color:uint = 0)
		{
			if (color)
			{
				argb = color;
			}
		}
		
		public function get alpha():int
		{
			return _alpha;
		}
		
		public function set alpha(value:int):void
		{
			_alpha = value < 0 ? 0 : value > 0xff ? 0xff : value;
		}
		
		public function get red():int
		{
			return _red;
		}
		
		public function set red(value:int):void
		{
			_red = value < 0 ? 0 : value > 0xff ? 0xff : value;
		}
		
		public function get green():int
		{
			return _green;
		}
		
		public function set green(value:int):void
		{
			_green = value < 0 ? 0 : value > 0xff ? 0xff : value;
		}
		
		public function get blue():int
		{
			return _blue;
		}
		
		public function set blue(value:int):void
		{
			_blue = value < 0 ? 0 : value > 0xff ? 0xff : value;
		}
		
		public function get argb():uint
		{
			return (_alpha << 24) + (_red << 16) + (_green << 8) + _blue;
		}
		
		public function get rgb():uint
		{
			return (_red << 16) + (_green << 8) + _blue;
		}
		
		public function set argb(value:uint):void
		{
			_alpha = (value >> 24) & 0xff;
			_red = (value >> 16) & 0xff;
			_green = (value >> 8) & 0xff;
			_blue = value & 0xff;
		}
		
		public function setComponents(a:int, r:int, g:int, b:int):void
		{
			alpha = a;
			red = r;
			green = g;
			blue = b;
		}
		
		public function toString():String 
		{
			return "[Color 0x" + argb.toString(16) + "]";
		}
		
		/*** Statics ********************************************************************/
		
		public static function middle(colors:Vector.<Color>, result:Color = null):Color
		{
			if (!result)
			{
				result = new Color();
			}
			
			var totalColors:int = colors.length;
			var totalA:int = 0;
			var totalR:int = 0;
			var totalG:int = 0;
			var totalB:int = 0;
			
			for (var i:int = 0; i < totalColors; ++i)
			{
				var currentColor:Color = colors[i];
				
				totalA += currentColor._alpha;
				totalR += currentColor._red;
				totalG += currentColor._green;
				totalB += currentColor._blue;
			}
			
			result.alpha = int(totalA / totalColors + 0.5);
			result.red = int(totalR / totalColors + 0.5);
			result.green = int(totalG / totalColors + 0.5);
			result.blue = int(totalB / totalColors + 0.5);
			
			return result;
		}
		
		public static function blend(from:Color, to:Color, percent:Number = 0.5, result:Color = null):Color
		{
			if (!result)
			{
				result = new Color();
			}
			
			percent = percent < 0 ? 0 : percent > 1 ? 1 : percent;
			
			result.alpha = int(from._alpha * (1 - percent) + to._alpha * percent + 0.5);
			result.red = int(from._red * (1 - percent) + to._red * percent + 0.5);
			result.green = int(from._green * (1 - percent) + to._green * percent + 0.5);
			result.blue = int(from._blue * (1 - percent) + to._blue * percent + 0.5);
			
			return result;
		}
		
		public static function subtract(colorA:Color, colorB:Color, intensity:Number = 1, relative:Boolean = false, result:Color = null):Color
		{
			if (!result)
			{
				result = new Color();
			}
			
			var alpha:Number = colorB._alpha * intensity;
			var red:Number = colorB._red * intensity;
			var green:Number = colorB._green * intensity;
			var blue:Number = colorB._blue * intensity;
			
			if (relative)
			{
				alpha *= colorA._alpha / 0xff;
				red *= colorA._red / 0xff;
				green *= colorA._green / 0xff;
				blue *= colorA._blue / 0xff;
			}
			
			result.alpha = colorA._alpha - alpha;
			result.red = colorA._red - red;
			result.green = colorA._green - green;
			result.blue = colorA._blue - blue;
			
			return result;
		}
	}
}