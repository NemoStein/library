package nemostein.io
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import nemostein.Updatable;
	
	public class UserInput implements Input
	{
		/*** Input Constants **********************************************************/
		public static const LEFT_MOUSE:int = 1;
		public static const RIGHT_MOUSE:int = 2;
		public static const MIDDLE_MOUSE:int = 3;
		
		public static const ENTER:int = 13;
		public static const ESCAPE:int = 27;
		public static const SPACE:int = 32;
		public static const BACKSPACE:int = 8;
		public static const CONTROL:int = 17;
		public static const SHIFT:int = 16;
		public static const TAB:int = 9;
		public static const CAPS_LOCK:int = 20;
		
		public static const F1:int = 112;
		public static const F2:int = 113;
		public static const F3:int = 114;
		public static const F4:int = 115;
		public static const F5:int = 116;
		public static const F6:int = 117;
		public static const F7:int = 118;
		public static const F8:int = 119;
		public static const F9:int = 120;
		public static const F10:int = 121;
		public static const F11:int = 122;
		public static const F12:int = 123;
		
		public static const INSERT:int = 45;
		public static const DELETE:int = 46;
		public static const HOME:int = 36;
		public static const END:int = 35;
		public static const PAGE_DOWN:int = 34;
		public static const PAGE_UP:int = 33;
		
		public static const UP:int = 38;
		public static const DOWN:int = 40;
		public static const LEFT:int = 37;
		public static const RIGHT:int = 39;
		
		public static const NUMPAD_0:int = 96;
		public static const NUMPAD_1:int = 97;
		public static const NUMPAD_2:int = 98;
		public static const NUMPAD_3:int = 99;
		public static const NUMPAD_4:int = 100;
		public static const NUMPAD_5:int = 101;
		public static const NUMPAD_6:int = 102;
		public static const NUMPAD_7:int = 103;
		public static const NUMPAD_8:int = 104;
		public static const NUMPAD_9:int = 105;
		public static const NUMPAD_ADD:int = 107;
		public static const NUMPAD_DECIMAL:int = 110;
		public static const NUMPAD_DIVIDE:int = 111;
		public static const NUMPAD_ENTER:int = 108;
		public static const NUMPAD_MULTIPLY:int = 106;
		public static const NUMPAD_SUBTRACT:int = 109;
		
		public static const NUMBER_0:int = 48;
		public static const NUMBER_1:int = 49;
		public static const NUMBER_2:int = 50;
		public static const NUMBER_3:int = 51;
		public static const NUMBER_4:int = 52;
		public static const NUMBER_5:int = 53;
		public static const NUMBER_6:int = 54;
		public static const NUMBER_7:int = 55;
		public static const NUMBER_8:int = 56;
		public static const NUMBER_9:int = 57;
		
		public static const A:int = 65;
		public static const B:int = 66;
		public static const C:int = 67;
		public static const D:int = 68;
		public static const E:int = 69;
		public static const F:int = 70;
		public static const G:int = 71;
		public static const H:int = 72;
		public static const I:int = 73;
		public static const J:int = 74;
		public static const K:int = 75;
		public static const L:int = 76;
		public static const M:int = 77;
		public static const N:int = 78;
		public static const O:int = 79;
		public static const P:int = 80;
		public static const Q:int = 81;
		public static const R:int = 82;
		public static const S:int = 83;
		public static const T:int = 84;
		public static const U:int = 85;
		public static const V:int = 86;
		public static const W:int = 87;
		public static const X:int = 88;
		public static const Y:int = 89;
		public static const Z:int = 90;
		
		public static const APOS:int = 192;
		public static const MINUS:int = 189;
		public static const PLUS:int = 187;
		public static const BACKSLASH:int = 226;
		public static const COMMA:int = 188;
		public static const DOT:int = 190;
		public static const SEMICOLON:int = 191;
		public static const SLASH:int = 193;
		/******************************************************************************/
		
		/*** Mouse Variables **********************************************************/
		private var _wheelDown:Boolean;
		private var _wheelUp:Boolean;
		
		private var _mouse:Point = new Point();
		private var _leftMouseDown:Point = new Point();
		private var _leftMouseUp:Point = new Point();
		private var _rightMouseDown:Point = new Point();
		private var _rightMouseUp:Point = new Point();
		private var _middleMouseDown:Point = new Point();
		private var _middleMouseUp:Point = new Point();
		/******************************************************************************/
		
		private var _pressedKeys:Vector.<Boolean>;
		private var _justPressedKeys:Vector.<Boolean>;
		private var _justReleasedKeys:Vector.<Boolean>;
		
		private var _keyCount:int;
		private var _stage:Stage;
		
		/*** Public *******************************************************************/
		public function UserInput(stage:Stage = null)
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
			_stage.addEventListener(Event.EXIT_FRAME, onStageExitFrame);
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
			_stage.removeEventListener(Event.EXIT_FRAME, onStageExitFrame);
			
			_stage = null;
			
			reset();
		}
		
		private function onStageExitFrame(event:Event):void
		{
			update();
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
		
		public function get wheelDown():Boolean
		{
			return _wheelDown;
		}
		
		public function get wheelUp():Boolean
		{
			return _wheelUp;
		}
		
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
		
		public function update():void
		{
			for (var i:int = 0; i < _keyCount; i++)
			{
				_justPressedKeys[i] = false;
				_justReleasedKeys[i] = false;
			}
			
			_wheelUp = false;
			_wheelDown = false;
			
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
			
			press(LEFT_MOUSE);
		}
		
		private function onLeftMouseUp(event:MouseEvent):void
		{
			_leftMouseUp.x = event.stageX;
			_leftMouseUp.y = event.stageY;
			
			release(LEFT_MOUSE);
		}
		
		private function onRightMouseDown(event:MouseEvent):void
		{
			_rightMouseDown.x = event.stageX;
			_rightMouseDown.y = event.stageY;
			
			press(RIGHT_MOUSE);
		}
		
		private function onRightMouseUp(event:MouseEvent):void
		{
			_rightMouseUp.x = event.stageX;
			_rightMouseUp.y = event.stageY;
			
			release(RIGHT_MOUSE);
		}
		
		private function onMiddleMouseDown(event:MouseEvent):void
		{
			_middleMouseDown.x = event.stageX;
			_middleMouseDown.y = event.stageY;
			
			press(MIDDLE_MOUSE);
		}
		
		private function onMiddleMouseUp(event:MouseEvent):void
		{
			_middleMouseUp.x = event.stageX;
			_middleMouseUp.y = event.stageY;
			
			release(MIDDLE_MOUSE);
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			_wheelUp = (event.delta > 0);
			_wheelDown = (event.delta < 0);
		}
		/******************************************************************************/
	}
}