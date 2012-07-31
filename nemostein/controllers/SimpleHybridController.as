package nemostein.controllers
{
	import nemostein.io.Input;
	import nemostein.io.UserInput;
	import nemostein.Updatable;
	import nemostein.utils.MathUtils;
	
	public class SimpleHybridController implements Controller, Updatable
	{
		public static const DEFAULT_KEY_UP:int = UserInput.W;
		public static const DEFAULT_KEY_DOWN:int = UserInput.S;
		public static const DEFAULT_KEY_LEFT:int = UserInput.A;
		public static const DEFAULT_KEY_RIGHT:int = UserInput.D;
		public static const DEFAULT_MOVE_SPEED:Number = 150;
		public static const DEFAULT_TURN_SPEED:Number = 150;
		
		protected var _keyUp:int;
		protected var _keyDown:int;
		protected var _keyLeft:int;
		protected var _keyRight:int;
		protected var _moveSpeed:Number;
		protected var _turnSpeed:Number;
		
		protected var _angle:Number;
		
		protected var _target:Controllable;
		protected var _input:Input;
		
		public function SimpleHybridController(input:Input, target:Controllable = null)
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
			_moveSpeed = DEFAULT_MOVE_SPEED;
			_turnSpeed = DEFAULT_TURN_SPEED * 0.025;
			
			if (target)
			{
				_angle = _target.angle;
			}
		}
		
		public function update():void
		{
			if (!_target)
			{
				return;
			}
			
			updateKeyboard();
			updateMouse();
		}
		
		protected function updateKeyboard():void
		{
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
		}
		
		protected function updateMouse():void
		{
			var xDistance:Number = _input.mouse.x - _target.x;
			var yDistance:Number = _input.mouse.y - _target.y;
			
			var turnSpeedCap:Number = _turnSpeed * 0.02;
			
			var angleDifference:Number = MathUtils.piWrap(Math.atan2(yDistance, xDistance) - _angle);
			
			if (angleDifference > turnSpeedCap)
			{
				angleDifference = turnSpeedCap;
			}
			else if (angleDifference < -turnSpeedCap)
			{
				angleDifference = -turnSpeedCap;
			}
			
			_angle += angleDifference;
			
			_target.angle = _angle;
		}
		
		public function get target():Controllable
		{
			return _target;
		}
		
		public function set target(value:Controllable):void
		{
			_target = value;
			_angle = _target.angle;
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