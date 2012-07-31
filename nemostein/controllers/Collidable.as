package nemostein.controllers
{
	public interface Collidable extends Controllable
	{
		function get width():Number;
		function set width(value:Number):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function collide(angle:Number, against:Collidable):void;
	}
}