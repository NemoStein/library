package nemostein.animation
{
	import nemostein.Updatable;
	
	public class FrameSequence implements Updatable
	{
		public var frames:int;
		public var onComplete:Function;
		
		private var _frame:int;
		private var _keyFrames:Array;
		private var _running:Boolean;
		
		public function FrameSequence(frames:int = 0)
		{
			this.frames = frames;
			
			initialize();
		}
		
		private function initialize():void
		{
			_keyFrames = new Array();
		}
		
		public function addKeyFrame(frame:int, callback:Function, expand:Boolean = false):void
		{
			_keyFrames[frame] = callback;
			
			if (expand && frame >= frames)
			{
				frames = frame + 1;
			}
		}
		
		public function start():void
		{
			_running = true;
		}
		
		public function stop():void
		{
			_running = false;
		}
		
		public function reset():void
		{
			_frame = 0;
		}
		
		public function update():void
		{
			if (_running)
			{
				var keyFrame:Function = _keyFrames[frame];
				if (keyFrame)
				{
					keyFrame(_frame);
				}
				
				++_frame;
				
				if (_frame == frames)
				{
					stop();
					reset();
					
					if (onComplete)
					{
						onComplete();
					}
				}
			}
		}
		
		public function get running():Boolean
		{
			return _running;
		}
	}
}