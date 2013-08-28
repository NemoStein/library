package sourbit.library.intro
{
	import flash.display.Sprite;
	
	public class Intro extends Sprite
	{
		public var onComplete:Function;
		
		public function Intro()
		{
		
		}
		
		public function start():void
		{
			end();
		}
		
		protected final function end():void
		{
			if(onComplete != null)
			{
				onComplete();
			}
		}
	}
}