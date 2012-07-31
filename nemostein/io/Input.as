package nemostein.io
{
	import flash.geom.Point;
	import nemostein.Updatable;
	
	public interface Input extends Updatable
	{
		function pressed(key:int):Boolean;
		function justPressed(key:int):Boolean
		function justReleased(key:int):Boolean
		function press(key:int):void
		function release(key:int):void
		function get wheelDown():Boolean;
		function get wheelUp():Boolean;
		function get mouse():Point;
		function get leftMouseDown():Point;
		function get leftMouseUp():Point;
		function get rightMouseDown():Point;
		function get rightMouseUp():Point;
		function get middleMouseDown():Point;
		function get middleMouseUp():Point;
	}
}