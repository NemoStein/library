package nemostein.controllers
{
	import flash.automation.Configuration;
	import nemostein.Updatable;
	import nemostein.utils.MathUtils;
	
	public class SimpleSeeker implements Seeker, Updatable
	{
		public static const DEFAULT_MOVE_SPEED:Number = 100;
		public static const DEFAULT_TURN_SPEED:Number = 100;
		
		protected var _target:Controllable;
		protected var _sources:Vector.<Controllable>;
		protected var _sourceCount:int;
		
		protected var _moveSpeeds:Vector.<Number>;
		protected var _turnSpeeds:Vector.<Number>;
		protected var _moveAngles:Vector.<Number>;
		
		public function SimpleSeeker(target:Controllable = null, ...sources:Array)
		{
			_target = target;
			
			initialize(sources);
		}
		
		protected function initialize(sources:Array):void
		{
			_sources = new Vector.<Controllable>();
			_moveSpeeds = new Vector.<Number>();
			_turnSpeeds = new Vector.<Number>();
			_moveAngles = new Vector.<Number>();
			
			for each(var source:Object in sources)
			{
				if (!(source is Controllable))
				{
					throw new ArgumentError("Sources must implement Controllable");
				}
				
				addSource(Controllable(source));
			}
		}
		
		public function update():void
		{
			if (!_target || _sources.length == 0)
			{
				return;
			}
			
			for (var i:int = 0; i < _sourceCount; ++i)
			{
				var source:Controllable = _sources[i];
				
				if (source == null)
				{
					continue;
				}
				
				var moveSpeed:Number = _moveSpeeds[i];
				var turnSpeed:Number = _turnSpeeds[i];
				var moveAngle:Number = _moveAngles[i];
				
				var xDistance:Number = _target.x - source.x;
				var yDistance:Number = _target.y - source.y;
				
				var angle:Number = MathUtils.piWrap(Math.atan2(yDistance, xDistance) - moveAngle);
				
				moveAngle = MathUtils.piWrap(moveAngle + angle * (turnSpeed / moveSpeed) * 0.02);
				
				source.x += Math.cos(moveAngle) * moveSpeed * 0.02;
				source.y += Math.sin(moveAngle) * moveSpeed * 0.02;
				
				source.angle = _moveAngles[i] = moveAngle;
			}
		}
		
		public function get target():Controllable
		{
			return _target;
		}
		
		public function set target(value:Controllable):void
		{
			_target = value;
		}
		
		public function addSource(source:Controllable):void
		{
			_sources.push(source);
			
			_moveSpeeds.push(DEFAULT_MOVE_SPEED);
			_turnSpeeds.push(DEFAULT_TURN_SPEED);
			_moveAngles.push(Math.random() * MathUtils.PI2);
			
			++_sourceCount;
		}
		
		public function removeSource(source:Controllable):void
		{
			for (var i:int = 0; i < _sourceCount; ++i)
			{
				if (_sources[i] == source)
				{
					_sources[i] = null;
					break;
				}
			}
		}
	}
}