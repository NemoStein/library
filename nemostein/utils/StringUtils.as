package nemostein.utils
{
	
	public class StringUtils
	{
		static public function formatNumber(value:Number, decimal:String = ".", hundreds:String = ","):String
		{
			var output:String = "";
			var numberParts:Array = value.toString().split(".");
			var numbers:Array = String(numberParts[0]).split("");
			
			var char:String;
			var i:int;
			
			while (char = numbers.pop())
			{
				if (i > 0 && i % 3 == 0)
				{
					output = hundreds + output;
				}
				
				output = char + output;
				
				i++;
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