package nemostein.io
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Input
	{
		/*** Mouse Variables **********************************************************/
		private var _mouse:Point = new Point();
		private var _leftMouseDown:Point = new Point();
		private var _leftMouseUp:Point = new Point();
		private var _rightMouseDown:Point = new Point();
		private var _rightMouseUp:Point = new Point();
		private var _middleMouseDown:Point = new Point();
		private var _middleMouseUp:Point = new Point();
		
		public var wheelDown:Boolean;
		public var wheelUp:Boolean;
		/******************************************************************************/
		
		private var _pressedKeys:Vector.<Boolean>;
		private var _justPressedKeys:Vector.<Boolean>;
		private var _justReleasedKeys:Vector.<Boolean>;
		
		private var _keyCount:int;
		private var _stage:Stage;
		
		/*** Public *******************************************************************/
		public function Input(stage:Stage = null)
		{
			reset();
			
			if (stage)
			{
				activate(stage);
			}
		}
		
		public function activate(stage:Stage):void
		{
			reset();
			
			_stage = stage;
			
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onLeftMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onLeftMouseUp);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			_stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleMouseDown);
			_stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleMouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		public function deactivate():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_stage.removeEventListener(MouseEvent.MOUSE_DOWN, onLeftMouseDown);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onLeftMouseUp);
			_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, onRightMouseDown);
			_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, onRightMouseUp);
			_stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleMouseDown);
			_stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleMouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			_stage = null;
			
			reset();
		}
		
		public function pressed(key:int):Boolean
		{
			return _pressedKeys[key];
		}
		
		public function justPressed(key:int):Boolean
		{
			return _justPressedKeys[key];
		}
		
		public function justReleased(key:int):Boolean
		{
			return _justReleasedKeys[key];
		}
		
		public function press(key:int):void
		{
			_justPressedKeys[key] = !_pressedKeys[key];
			_pressedKeys[key] = true;
		}
		
		public function release(key:int):void
		{
			_justReleasedKeys[key] = _pressedKeys[key];
			_pressedKeys[key] = false;
		}
		
		public function update():void
		{
			for (var i:int = 0; i < _keyCount; i++)
			{
				_justPressedKeys[i] = false;
				_justReleasedKeys[i] = false;
			}
			
			wheelUp = false;
			wheelDown = false;
			
			_mouse.x = _stage.mouseX;
			_mouse.y = _stage.mouseY;
		}
		
		private function reset():void
		{
			_keyCount = 227;
			
			_pressedKeys = new Vector.<Boolean>(_keyCount, true);
			_justPressedKeys = new Vector.<Boolean>(_keyCount, true);
			_justReleasedKeys = new Vector.<Boolean>(_keyCount, true);
			
			for (var i:int = 0; i < _keyCount; i++)
			{
				_pressedKeys[i] = false;
				_justPressedKeys[i] = false;
				_justReleasedKeys[i] = false;
			}
		}
		
		/*** Keyboard Stuff ***********************************************************/
		private function onKeyDown(event:KeyboardEvent):void
		{
			press(event.keyCode);
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			release(event.keyCode);
		}
		
		/******************************************************************************/
		
		/*** Mouse Stuff **************************************************************/
		private function onLeftMouseDown(event:MouseEvent):void
		{
			_leftMouseDown.x = event.stageX;
			_leftMouseDown.y = event.stageY;
			
			press(Keys.LEFT_MOUSE);
		}
		
		private function onLeftMouseUp(event:MouseEvent):void
		{
			_leftMouseUp.x = event.stageX;
			_leftMouseUp.y = event.stageY;
			
			release(Keys.LEFT_MOUSE);
		}
		
		private function onRightMouseDown(event:MouseEvent):void
		{
			_rightMouseDown.x = event.stageX;
			_rightMouseDown.y = event.stageY;
			
			press(Keys.RIGHT_MOUSE);
		}
		
		private function onRightMouseUp(event:MouseEvent):void
		{
			_rightMouseUp.x = event.stageX;
			_rightMouseUp.y = event.stageY;
			
			release(Keys.RIGHT_MOUSE);
		}
		
		private function onMiddleMouseDown(event:MouseEvent):void
		{
			_middleMouseDown.x = event.stageX;
			_middleMouseDown.y = event.stageY;
			
			press(Keys.MIDDLE_MOUSE);
		}
		
		private function onMiddleMouseUp(event:MouseEvent):void
		{
			_middleMouseUp.x = event.stageX;
			_middleMouseUp.y = event.stageY;
			
			release(Keys.MIDDLE_MOUSE);
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			wheelUp = (event.delta > 0);
			wheelDown = (event.delta < 0);
		}
		
		/******************************************************************************/
		
		public function get mouse():Point
		{
			return _mouse.clone();
		}
		
		public function get leftMouseDown():Point
		{
			return _leftMouseDown.clone();
		}
		
		public function get leftMouseUp():Point
		{
			return _leftMouseUp.clone();
		}
		
		public function get rightMouseDown():Point
		{
			return _rightMouseDown.clone();
		}
		
		public function get rightMouseUp():Point
		{
			return _rightMouseUp.clone();
		}
		
		public function get middleMouseDown():Point
		{
			return _middleMouseDown.clone();
		}
		
		public function get middleMouseUp():Point
		{
			return _middleMouseUp.clone();
		}
	}
}