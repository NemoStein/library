package nemostein.utils 
{

	public class StringUtils 
	{
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