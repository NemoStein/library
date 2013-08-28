package sourbit.library.ogmo
{
	import flash.utils.Dictionary;
	
	public class OgmoLevel
	{
		private var _layers:Dictionary;
		
		public function OgmoLevel()
		{
			_layers = new Dictionary();
		}
		
		public function listLayers():Array
		{
			var array:Array = [];
			
			for (var id:String in _layers) 
			{
				array.push(id);
			}
			
			return array;
		}
		
		public function getLayer(id:String):Array
		{
			return _layers[id];
		}
		
		public function addLayer(id:String, data:Array):void
		{
			_layers[id] = data;
		}
	}
}