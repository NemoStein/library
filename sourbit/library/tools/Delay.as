package sourbit.library.tools
{
	import org.flixel.FlxG;
	
	public class Delay
	{
		/**
		 * Delay timer
		 */
		private var _timer:Number;
		/**
		 * The time target
		 */
		private var _delay:Number;
		/**
		 *  if the delay is going to happen again once ended
		 */
		private var _repeat:Boolean;
		/**
		 * The function called when the delay ends
		 */
		private var _callback:Function;
		/**
		 * If the timer its active, couting
		 */
		private var _active:Boolean;
		
		/**
		 *  Sets a delayed callback that can be repeated
		 *
		 * @param	delay		How much time untill call the callback.
		 * @param	repeat		If its going to repeat once ended.
		 * @param	callback	The function to call when reached the delay.
		 */
		public function Delay(delay:Number,repeat:Boolean,callback:Function)
		{
			_timer = 0;
			_delay = delay;
			
			_repeat = repeat;
			_callback = callback;
			
			_active = false;
		}
		
		/**
		 * update the timer untill reaches the delay, then cheks if repeated
		 * if so, start over
		 */
		public function update():void
		{
			if (!_active) return;
			
			_timer += FlxG.elapsed;
			if (_timer >= _delay)
			{
				if (_repeat)
				{
					reset();
				}
				else
				{
					_active = false;
				}
				
				if (_callback)
				{
					_callback();
				}
			}
		}
		
		/**
		 * Active and start over the counter
		 */
		public function start():void
		{
			reset();
			_active = true;
		}
		
		/**
		 *  pause the counter
		 */
		public function pause():void
		{
			_active = false;
		}
		
		/**
		 * resume the counter
		 */
		public function resume():void
		{
			_active = true;
		}
		
		/**
		 * reset the timer
		 */
		public function reset():void
		{
			_timer = 0;
		}
		
		public function get delay():Number
		{
			return _delay;
		}
		
		public function set delay(value:Number):void
		{
			_delay = value;
			reset();
		}
		
		public function get active():Boolean
		{
			return _active;
		}
	}
}