package nemostein.controllers
{
	import nemostein.io.Input;
	import nemostein.Updatable;
	import nemostein.utils.MathUtils;
	
	public class SimpleKeyboardController implements Controller, Updatable
	{
		public static const DEFAULT_KEY_UP:int = Input.W;
		public static const DEFAULT_KEY_DOWN:int = Input.S;
		public static const DEFAULT_KEY_LEFT:int = Input.A;
		public static const DEFAULT_KEY_RIGHT:int = Input.D;
		public static const DEFAULT_KEY_TURN_LEFT:int = Input.LEFT;
		public static const DEFAULT_KEY_TURN_RIGHT:int = Input.RIGHT;;
		public static const DEFAULT_MOVE_SPEED:Number = 150;
		public static const DEFAULT_TURN_SPEED:Number = 200;
		
		protected var _keyUp:int;
		protected var _keyDown:int;
		protected var _keyLeft:int;
		protected var _keyRight:int;
		protected var _keyTurnLeft:int;
		protected var _keyTurnRight:int;
		protected var _moveSpeed:Number;
		protected var _turnSpeed:Number;
		
		protected var _target:Controllable;
		protected var _input:Input;
		
		public function SimpleKeyboardController(input:Input, target:Controllable = null)
		{
			_input = input;
			_target = target;
			
			initialize();
		}
		
		protected function initialize():void
		{
			_keyUp = DEFAULT_KEY_UP;
			_keyDown = DEFAULT_KEY_DOWN;
			_keyLeft = DEFAULT_KEY_LEFT;
			_keyRight = DEFAULT_KEY_RIGHT;
			_keyTurnLeft = DEFAULT_KEY_TURN_LEFT;
			_keyTurnRight = DEFAULT_KEY_TURN_RIGHT;
			_moveSpeed = DEFAULT_MOVE_SPEED;
			_turnSpeed = DEFAULT_TURN_SPEED;
		}
		
		public function update():void
		{
			if (!_target)
			{
				return;
			}
			
			var up:Boolean = _input.pressed(_keyUp);
			var down:Boolean = _input.pressed(_keyDown);
			var left:Boolean = _input.pressed(_keyLeft);
			var right:Boolean = _input.pressed(_keyRight);
			
			var axisSpeed:Number = _moveSpeed;
			
			if ((up || down) && (left || right))
			{
				axisSpeed = Math.sqrt(_moveSpeed * _moveSpeed * 2) / 2;
			}
			
			axisSpeed *= 0.02;
			
			if (up)
			{
				_target.y -= axisSpeed;
			}
			else if (down)
			{
				_target.y += axisSpeed;
			}
			
			if (left)
			{
				_target.x -= axisSpeed;
			}
			else if (right)
			{
				_target.x += axisSpeed;
			}
			
			if (_input.pressed(_keyTurnLeft))
			{
				_target.angle -= MathUtils.rad(_turnSpeed *  0.02);
			}
			
			if (_input.pressed(_keyTurnRight))
			{
				_target.angle += MathUtils.rad(_turnSpeed *  0.02);
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
		
		public function get keyUp():int
		{
			return _keyUp;
		}
		
		public function get keyDown():int
		{
			return _keyDown;
		}
		
		public function get keyLeft():int
		{
			return _keyLeft;
		}
		
		public function get keyRight():int
		{
			return _keyRight;
		}
		
		public function get keyTurnLeft():int
		{
			return _keyTurnLeft;
		}
		
		public function get keyTurnRight():int
		{
			return _keyTurnRight;
		}
		
		public function get moveSpeed():Number
		{
			return _moveSpeed;
		}
		
		public function get turnSpeed():Number
		{
			return _turnSpeed;
		}
	}
}