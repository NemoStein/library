package nemostein.controllers
{
	public interface Collider
	{
		function isColliding(collidableA:Collidable, collidableB:Collidable):Boolean;
		function collide(collidableA:Collidable, collidableB:Collidable):void;
		function collideAll(collidables:Vector.<Collidable>):void;
		function collideAgainst(target:Collidable, collidables:Vector.<Collidable>):void;
		function collideGroups(collidablesA:Vector.<Collidable>, collidablesB:Vector.<Collidable>):void;
	}
}