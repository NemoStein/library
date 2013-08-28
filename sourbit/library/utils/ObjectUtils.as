package sourbit.library.utils
{
	
	public class ObjectUtils
	{
		static public function trace(object:*):void
		{
			trace(recursive_trace(object));
		}
		
		static private function recursive_trace(object:*, ident:String = ""):String
		{
			var output:String = ident + "{\r";
			
			for (var content:* in object)
			{
				if (typeof(object[content]) == "object")
				{
					output += ident + "\t[" + content + ":" + typeof(object[content]) + "]\r";
					output += recursive_trace(object[content], ident + "\t");
				}
				else
				{
					output += ident + "\t[" + content + ":" + typeof(object[content]) + "] => " + object[content] + "\r";
				}
			}
			
			output += ident + "}\r";
			
			return output;
		}
	}
}