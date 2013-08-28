package sourbit.library.intro
{
	import flash.display.Sprite;
	
	public class IntroSequence extends Sprite
	{
		public var onComplete:Function;
		
		private var _sequence:Array;
		private var _index:int;
		private var _intro:Intro;
		
		public function IntroSequence(onComplete:Function)
		{
			this.onComplete = onComplete;
			
			initialize();
		}
		
		private function initialize():void
		{
			_sequence = [];
		}
		
		public function addIntro(intro:Intro):IntroSequence
		{
			if (intro == null)
			{
				throw new ArgumentError("Parameter intro can't be null.");
			}
			
			_sequence.push(intro);
			intro.onComplete = onIntroComplete;
			
			return this;
		}
		
		public function start():IntroSequence
		{
			onIntroComplete();
			
			return this;
		}
		
		private function onIntroComplete():void
		{
			if (_intro == null)
			{
				_index = 0;
			}
			else
			{
				removeChild(_intro);
				++_index;
			}
			
			if (_index < _sequence.length)
			{
				_intro = _sequence[_index];
				
				addChild(_intro);
				
				_intro.start();
			}
			else if (onComplete != null)
			{
				onComplete();
			}
		}
	}
}