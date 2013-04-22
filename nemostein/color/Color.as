package nemostein.color
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
			_alpha = value < 0 ? 0 : value & 0xff;
		}
		
		public function get red():int
		{
			return _red;
		}
		
		public function set red(value:int):void
		{
			_red = value < 0 ? 0 : value & 0xff;
		}
		
		public function get green():int
		{
			return _green;
		}
		
		public function set green(value:int):void
		{
			_green = value < 0 ? 0 : value & 0xff;
		}
		
		public function get blue():int
		{
			return _blue;
		}
		
		public function set blue(value:int):void
		{
			_blue = value < 0 ? 0 : value & 0xff;
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
		
		/*** Statics ********************************************************************/
		
		public static function middle(colors:Vector.<Color>, shell:Color = null):Color
		{
			if (!shell)
			{
				shell = new Color();
			}
			
			var totalColors:int = colors.length;
			var totalA:uint = 0;
			var totalR:uint = 0;
			var totalG:uint = 0;
			var totalB:uint = 0;
			
			for (var i:int = 0; i < totalColors; i++)
			{
				var currentColor:Color = colors[i];
				
				totalA += currentColor._alpha;
				totalR += currentColor._red;
				totalG += currentColor._green;
				totalB += currentColor._blue;
			}
			
			shell.alpha = Math.ceil(totalA / totalColors);
			shell.red = Math.ceil(totalR / totalColors);
			shell.green = Math.ceil(totalG / totalColors);
			shell.blue = Math.ceil(totalB / totalColors);
			
			return shell;
		}
		
		public static function blend(from:Color, to:Color, percent:Number = 0.5, shell:Color = null):Color
		{
			if (!shell)
			{
				shell = new Color();
			}
			
			percent= percent < 0 ? 0 : percent > 1 ? 1 : percent;
			
			shell.alpha = Math.ceil(from._alpha * (1 - percent) + to._alpha * percent);
			shell.red = Math.ceil(from._red * (1 - percent) + to._red * percent);
			shell.green = Math.ceil(from._green * (1 - percent) + to._green * percent);
			shell.blue = Math.ceil(from._blue * (1 - percent) + to._blue * percent);
			
			return shell;
		}
		
		public static function subtract(base:Color, brush:Color, intensity:Number = 1, relative:Boolean = false):uint
		{
			var alpha:int = brush._alpha * intensity;
			var red:int = brush._red * intensity;
			var green:int = brush._green * intensity;
			var blue:int = brush._blue * intensity;
			
			var baseAlpha:int = base._alpha;
			var baseRed:int = base._red;
			var baseGreen:int = base._green;
			var baseBlue:int = base._blue;
			
			if (relative)
			{
				alpha *= baseAlpha / 0xff;
				red *= baseRed / 0xff;
				green *= baseGreen / 0xff;
				blue *= baseBlue / 0xff;
			}
			
			alpha = baseAlpha - alpha;
			red = baseRed - red;
			green = baseGreen - green;
			blue = baseBlue - blue;
			
			if (alpha < 0)
			{
				alpha = 0;
			}
			
			if (red < 0)
			{
				red = 0;
			}
			
			if (green < 0)
			{
				green = 0;
			}
			
			if (blue < 0)
			{
				blue = 0;
			}
			
			return (alpha << 24) + (red << 16) + (green << 8) + blue;
		}
	}
}