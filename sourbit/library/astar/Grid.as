package sourbit.library.astar
{
	import flash.geom.Point;
	
	public class Grid
	{
		private var _maze:Array;
		private var _cells:Vector.<Node>;
		
		private var _rows:int;
		private var _cols:int;
		
		private var _heuristicValue:int;
		
		/**
		 * 
		 * @param	int[cols][rows] maze
		 */
		public function Grid(maze:Array)
		{
			_maze = maze;
			
			_cols = _maze.length;
			_rows = _maze[0].length;
			
			initialize();
		}
		
		private function initialize():void
		{
			var passableCount:int;
			
			_cells = new Vector.<Node>(_cols * _rows, true);
			for (var x:int = 0; x < _cols; ++x)
			{
				for (var y:int = 0; y < _rows; ++y)
				{
					_cells[x * _rows + y] = new Node(x, y, _maze[x][y]);
					
					if (!data.block)
					{
						_heuristicValue += data.cost;
						++passableCount;
					}
				}
			}
			
			_heuristicValue /= passableCount;
		}
		
		public function find(start:Point, end:Point):Array
		{
			var x:int;
			var y:int;
			var cell:Node
			var pathFound:Boolean;
			
			for (x = 0; x < _cols; ++x)
			{
				for (y = 0; y < _rows; ++y)
				{
					cell = getCellAt(x, y);
					cell.reset();
				}
			}
			
			var initial:Node = getCellAt(start.x, start.y);
			var target:Node = getCellAt(end.x, end.y);
			
			var opened:Vector.<Node> = new <Node>[];
			
			initial.state = Node.OPENED;
			opened.push(initial);
			
			search: while (opened.length)
			{
				var openedLength:int = opened.length;
				var lowestF:int = int.MAX_VALUE;
				var lowestI:int;
				
				for (var i:int = 0; i < openedLength; ++i)
				{
					cell = opened[i];
					
					if (cell.f < lowestF)
					{
						lowestF = cell.f;
						lowestI = i;
					}
				}
				
				var current:Node = opened[lowestI];
				opened[lowestI] = opened[openedLength - 1];
				opened.pop();
				
				current.state = Node.CLOSED;
				
				if (current == target)
				{
					pathFound = true;
					break search;
				}
				
				var currentX:int = current.x;
				var currentY:int = current.y;
				
				for (x = currentX - 1; x <= currentX + 1; ++x)
				{
					if (x < 0 || x >= _cols)
					{
						continue;
					}
					
					for (y = currentY - 1; y <= currentY + 1; ++y)
					{
						if (y < 0 || y >= _rows || (currentX == x && currentY == y))
						{
							continue;
						}
						
						var neighbour:Node = getCellAt(x, y);
						
						var neighbourX:int = neighbour.x;
						var neighbourY:int = neighbour.y;
						
						var possibleBlock:Node;
						
						if (neighbourX < currentX)
						{
							possibleBlock = getCellAt(currentX - 1, currentY);
							if (possibleBlock.block)
							{
								continue;
							}
						}
						else if (neighbourX > currentX)
						{
							possibleBlock = getCellAt(currentX + 1, currentY);
							if (possibleBlock.block)
							{
								continue;
							}
						}
						
						if (neighbourY < currentY)
						{
							possibleBlock = getCellAt(currentX, currentY - 1);
							if (possibleBlock.block)
							{
								continue;
							}
						}
						else if (neighbourY > currentY)
						{
							possibleBlock = getCellAt(currentX, currentY + 1);
							if (possibleBlock.block)
							{
								continue;
							}
						}
						
						if (!neighbour.block && neighbour.state != Node.CLOSED)
						{
							var multplier:Number = 1;
							if (x != currentX && y != currentY)
							{
								multplier = 1.4;
							}
							
							var travelCost:int = int(neighbour.e * multplier + 0.5) + current.g;
							
							switch (neighbour.state)
							{
								case Node.CLEAR: 
								{
									neighbour.state = Node.OPENED;
									neighbour.parent = current;
									
									var distanceX:Number = abs(neighbourX - target.x);
									var distanceY:Number = abs(neighbourY - target.y);
									
									if(distanceX < distanceY)
									{
										neighbour.h = (distanceX * 1.4 + abs(distanceX - distanceY)) * _heuristicValue;
									}
									else
									{
										neighbour.h = (distanceY * 1.4 + abs(distanceX - distanceY)) * _heuristicValue;
									}
									
									neighbour.g = travelCost;
									neighbour.f = neighbour.g + neighbour.h;
									
									opened.push(neighbour);
									
									break;
								}
								
								case Node.OPENED: 
								{
									if (neighbour.g > travelCost)
									{
										neighbour.parent = current;
										
										neighbour.g = travelCost;
										neighbour.f = neighbour.g + neighbour.h;
									}
								}
							}
						}
					}
				}
			}
			
			var path:Array;
			if (pathFound)
			{
				path = [];
				while (target.parent)
				{
					path.push(target);
					target = target.parent;
				}
				path.push(target);
				path.reverse();
			}
			
			return path;
		}
		
		[Inline]
		final private function abs(value:Number):Number
		{
			if (value < 0)
			{
				return -value;
			}
			else
			{
				return value;
			}
		}
		
		[Inline]
		final private function getCellAt(x:int, y:int):Node
		{
			return _cells[x * _rows + y];
		}
		
		public function toString():String
		{
			var result:String = "";
			
			for (var x:int = 0; x < _cols; ++x)
			{
				for (var y:int = 0; y < _rows; ++y)
				{
					result += getCellAt(x, y).toString() + "\r";
				}
				
				result += "\r";
			}
			
			return result;
		}
		
		public function get cells():Vector.<Node>
		{
			return _cells;
		}
	}
}