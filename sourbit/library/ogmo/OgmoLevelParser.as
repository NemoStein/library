package sourbit.library.ogmo
{
	
	public class OgmoLevelParser
	{
		static public function parse(xml:XML):OgmoLevel
		{
			var level:OgmoLevel = new OgmoLevel();
			
			for each (var item:XML in xml.children())
			{
				var id:String = item.name();
				var mode:String = item.@exportMode;
				var tiles:Array = [];
				
				switch (mode)
				{
					case "CSV": 
					{
						var rows:Array = item.toString().split("\n");
						for each (var cols:String in rows) 
						{
							tiles.push(cols.split(","));
						}
						break;
					}
				}
				
				level.addLayer(id, tiles);
			}
			
			return level;
		}
	}
}