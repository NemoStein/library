package nemostein.controllers
{
	import nemostein.Updatable;
	
	public interface Controller extends Updatable
	{
		function get target():Controllable;
		function set target(value:Controllable):void;
	}
}