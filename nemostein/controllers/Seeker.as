package nemostein.controllers
{
	import nemostein.Updatable;
	
	public interface Seeker extends Updatable
	{
		function get target():Controllable;
		function set target(value:Controllable):void;
		
		function addSource(source:Controllable):void;
		function removeSource(source:Controllable):void;
	}
}
