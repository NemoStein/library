package nemostein.astar
{
	import flash.geom.Point;
	
	public class AStarGrid
	{
		private var _maze:Array;
		private var _cells:Vector.<AStarNode>;
		
		private var _rows:int;
		private var _cols:int;
		
		private var _heuristicValue:int;
		
		public function AStarGrid(maze:Array)
		{
			_maze = maze;
			
			_cols = _maze.length;
			_rows = _maze[0].length;
			
			initialize();
		}
		
		private function initialize():void
		{
			var passableCount:int;
			
			_cells = new Vector.<AStarNode>(_cols * _rows, true);
			for (var x:int = 0; x < _cols; ++x)
			{
				for (var y:int = 0; y < _rows; ++y)
				{
					var data:AStarNodeData = _maze[x][y];
					_cells[x * _rows + y] = new AStarNode(x, y, data);
					
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
			var cell:AStarNode
			var pathFound:Boolean;
			
			for (x = 0; x < _cols; ++x)
			{
				for (y = 0; y < _rows; ++y)
				{
					cell = getCellAt(x, y);
					cell.reset();
				}
			}
			
			var initial:AStarNode = getCellAt(start.x, start.y);
			var target:AStarNode = getCellAt(end.x, end.y);
			
			var opened:Vector.<AStarNode> = new <AStarNode>[];
			
			initial.state = AStarNode.OPENED;
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
				
				var current:AStarNode = opened[lowestI];
				opened[lowestI] = opened[openedLength - 1];
				opened.pop();
				
				current.state = AStarNode.CLOSED;
				
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
						
						var neighbour:AStarNode = getCellAt(x, y);
						
						var neighbourX:int = neighbour.x;
						var neighbourY:int = neighbour.y;
						
						var possibleBlock:AStarNode;
						
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
						
						if (!neighbour.block && neighbour.state != AStarNode.CLOSED)
						{
							var multplier:Number = 1;
							if (x != currentX && y != currentY)
							{
								multplier = 1.4;
							}
							
							var travelCost:int = int(neighbour.e * multplier + 0.5) + current.g;
							
							switch (neighbour.state)
							{
								case AStarNode.CLEAR: 
								{
									neighbour.state = AStarNode.OPENED;
									neighbour.parent = current;
									
									var distanceX:Number = abs(neighbourX - target.x);
									var distanceY:Number = abs(neighbourY - target.y);
									
									neighbour.g = travelCost;
									neighbour.h = (min(distanceX, distanceY) * 1.4 + abs(distanceX - distanceY)) * _heuristicValue;
									neighbour.f = neighbour.g + neighbour.h;
									
									opened.push(neighbour);
									
									break;
								}
								
								case AStarNode.OPENED: 
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
		final private function min(valueA:Number, valueB:Number):Number
		{
			if (valueA < valueB)
			{
				return valueA;
			}
			else
			{
				return valueB;
			}
		}
		
		[Inline]
		final private function max(valueA:Number, valueB:Number):Number
		{
			if (valueA > valueB)
			{
				return valueA;
			}
			else
			{
				return valueB;
			}
		}
		
		[Inline]
		final private function getCellAt(x:int, y:int):AStarNode
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
		
		public function get cells():Vector.<AStarNode>
		{
			return _cells;
		}
	}
}