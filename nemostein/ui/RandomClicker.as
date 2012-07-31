package nemostein.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public class RandomClicker
	{
		private var _target:DisplayObject;
		
		private var _targetWidth:Number;
		private var _targetHeight:Number;
		private var _timer:Timer;
		
		public function RandomClicker(target:DisplayObject)
		{
			_target = target;
			
			initialize();
		}
		
		private function initialize():void
		{
			_targetWidth = _target.width;
			_targetHeight = _target.height;
		}
		
		public function start(clicks:int = 1, delay:int = 20):void
		{
			_timer = new Timer(delay, clicks);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTimer);
			_timer.start();
		}
		
		private function onTimerTimer(event:TimerEvent):void
		{
			_target.dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, Math.random() * _targetWidth, Math.random() * _targetHeight));
		}
	}
}