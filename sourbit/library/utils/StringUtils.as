package sourbit.library.utils
{
	
	public class StringUtils
	{
		static public const PAD_BOTH:String = "padBoth";
		static public const PAD_LEFT:String = "padLeft";
		static public const PAD_RIGHT:String = "padRight";
		
		static public function formatNumber(value:Number, decimal:String = ".", hundreds:String = ","):String
		{
			var output:String = "";
			var numberParts:Array = value.toString().split(".");
			var numbers:Array = String(numberParts[0]).split("");
			
			var char:String;
			var i:int;
			
			char = numbers.pop();
			while (char)
			{
				if (i > 0 && i % 3 == 0)
				{
					output = hundreds + output;
				}
				
				output = char + output;
				
				i++;
				char = numbers.pop();
			}
			
			if (numberParts[1])
			{
				output += decimal + numberParts[1];
			}
			
			return output;
		}
		
		static public function uuid():String
		{
			const chars:Array = ['8', '9', 'A', 'B'];
			
			return randomHex(8) + '-' + randomHex(4) + '-4' + randomHex(3) + '-' + chars[int(Math.random() * 3)] + randomHex(3) + '-' + randomHex(12);
		}
		
		static public function pad(input:*, pad:*, length:int, mode:String = PAD_RIGHT, cap:Boolean = false):String 
		{	
			var result:String = String(input);
			
			while (result.length < length)
			{
				if (mode == PAD_BOTH || mode == PAD_LEFT)
				{
					result = String(pad) + result;
				}
				
				if (mode == PAD_BOTH || mode == PAD_RIGHT)
				{
					result = result + String(pad);
				}
			}
			
			if (cap)
			{
				var resultLength:int = result.length;
				var capLength:int = resultLength - length;
				
				if (mode == PAD_LEFT)
				{
					result = result.substr(capLength);
				}
				else if (mode == PAD_LEFT)
				{
					result = result.substr(0, length);
				}
				else if (mode == PAD_BOTH)
				{
					result = result.substr(int(capLength / 2), length);
				}
			}
			
			return result;
		}
		
		static private function randomHex(length:uint):String
		{
			const chars:Array = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'];
			const id:Array = [];
			
			while (length--)
			{
				id.push(chars[int(Math.random() * 16)]);
			}
			
			return id.join('');
		}
	}
}