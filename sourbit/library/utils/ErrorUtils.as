package sourbit.library.utils
{
	import flash.utils.getQualifiedClassName;
	
	public class ErrorUtils
	{
		static public function abstractMethod(object:Object, className:String, methodName:String):UninitializedError
		{
			var qualifiedClassName:String = getQualifiedClassName(object);
			
			return new UninitializedError(className + "::" + methodName + " MUST be overridden in " + qualifiedClassName.split("::")[1] + " (" + qualifiedClassName + ").");
		}
	}
}
