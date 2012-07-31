package nemostein.controllers
{
	import com.troygilbert.CollisionUtils;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.globalization.Collator;
	import nemostein.Updatable;
	import nemostein.utils.MathUtils;
	
	public class SimpleCollider implements Collider, Updatable
	{
		private var _i:int;
		private var _j:int;
		
		private var _xA:Number;
		private var _yA:Number;
		private var _xB:Number;
		private var _yB:Number;
		
		private var _countA:int;
		private var _countB:int;
		
		private var _target:Collidable;
		
		public function isColliding(collidableA:Collidable, collidableB:Collidable):Boolean
		{
			if (collidableA == collidableB)
			{
				return true;
			}
			
			_xA = collidableA.x;
			_yA = collidableA.y;
			
			_xB = collidableB.x;
			_yB = collidableB.y;
			
			if (_xA < _xB - collidableA.width || _xA > _xB + collidableB.width || _yA < _yB - collidableA.height || _yA > _yB + collidableB.height)
			{
				return false;
			}
			
			return true;
		}
		
		public function collide(collidableA:Collidable, collidableB:Collidable):void
		{
			if (isColliding(collidableA, collidableB))
			{
				var angleA:Number = Math.atan2(collidableA.y - collidableB.y, collidableA.x - collidableB.x);
				var angleB:Number = MathUtils.piWrap(angleA + Math.PI);
				
				collidableA.collide(angleA, collidableB);
				collidableB.collide(angleB, collidableA);
			}
		}
		
		public function collideAll(collidables:Vector.<Collidable>):void
		{
			_countA = collidables.length;
			
			for (_i = 0; _i < _countA; ++_i)
			{
				_target = collidables[_i];
				
				for (_j = _i; _j < _countA; ++_j)
				{
					if (_j == _i)
					{
						continue;
					}
					
					collide(_target, collidables[_j]);
				}
			}
		}
		
		public function collideAgainst(target:Collidable, collidables:Vector.<Collidable>):void
		{
			_countA = collidables.length;
			
			for (_i = 0; _i < _countA; ++_i)
			{
				collide(target, collidables[_i]);
			}
		}
		
		public function collideGroups(collidablesA:Vector.<Collidable>, collidablesB:Vector.<Collidable>):void
		{
			_countA = collidablesA.length;
			_countB = collidablesB.length;
			
			for (_i = 0; _i < _countA; ++_i)
			{
				_target = collidablesA[_i];
				
				for (_j = 0; _j < _countB; ++_j)
				{
					collide(_target, collidablesB[_j]);
				}
			}
		}
	}
}