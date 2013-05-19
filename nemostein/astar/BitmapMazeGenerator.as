package nemostein.astar
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import nemostein.color.Color;
	
	public class BitmapMazeGenerator
	{
		static public function generate(maze:BitmapData):Array
		{
			var cols:int = maze.width;
			var rows:int = maze.height;
			
			var result:Array = new Array();
			
			for (var x:int = 0; x < cols; x++)
			{
				result[x] = new Array();
				
				for (var y:int = 0; y < rows; y++)
				{
					var data:AStarNodeData = new AStarNodeData();
					
					var color:Color = new Color(maze.getPixel(x, y));
					if (color.red == 0)
					{
						data.block = true;
					}
					
					data.cost = 0xff - color.blue;
					
					result[x][y] = data;
				}
			}
			
			return result;
		}
	}
}