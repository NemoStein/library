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
		
		private var _i:int;
		private var _source:Controllable;
		private var _moveSpeed:Number;
		private var _turnSpeed:Number;
		private var _moveAngle:Number;
		private var _xDistance:Number;
		private var _yDistance:Number;
		private var _angle:Number;
		private var _sin:Number;
		private var _cos:Number;
		
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
			
			for each (var source:Object in sources)
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
			
			for (_i = 0; _i < _sourceCount; ++_i)
			{
				_source = _sources[_i];
				
				if (_source == null)
				{
					continue;
				}
				
				_moveSpeed = _moveSpeeds[_i];
				_turnSpeed = _turnSpeeds[_i];
				_moveAngle = _moveAngles[_i];
				
				_xDistance = _target.x - _source.x;
				_yDistance = _target.y - _source.y;
				
				_angle = MathUtils.piWrap(Math.atan2(_yDistance, _xDistance) - _moveAngle);
				
				_moveAngle = MathUtils.piWrap(_moveAngle + _angle * (_turnSpeed / _moveSpeed) * 0.02);
				
				_source.x += Math.cos(_moveAngle) * _moveSpeed * 0.02;
				_source.y += Math.sin(_moveAngle) * _moveSpeed * 0.02;
				
				_source.angle = _moveAngles[_i] = _moveAngle;
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
			for (_i = 0; _i < _sourceCount; ++_i)
			{
				if (_sources[_i] == source)
				{
					_sources[_i] = null;
					break;
				}
			}
		}
	}
}