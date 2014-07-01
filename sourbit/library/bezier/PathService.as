package sourbit.library.bezier
{
	import flash.geom.Point;
	
	public class PathService
	{
		static private var nodePoints:Vector.<Point>;
		static private var references:Vector.<PathReference>;
		static private var index:int;
		
		static public function resolvePaths(rawPaths:Object):Paths
		{
			nodePoints = new Vector.<Point>();
			references = new Vector.<PathReference>();
			
			var pathStarts:Vector.<Path> = new Vector.<Path>();
			var pathEnds:Vector.<Path> = new Vector.<Path>();
			var pathReferenceStarts:Vector.<PathReference> = new Vector.<PathReference>();
			var pathReferenceEnds:Vector.<PathReference> = new Vector.<PathReference>();
			
			var pathsXML:XML = new XML(rawPaths);
			var nodesXML:XML = pathsXML.nodes[0];
			var segmentsXML:XML = pathsXML.segments[0];
			
			for each (var nodeXML:XML in nodesXML.node)
			{
				nodePoints[int(nodeXML.@id)] = new Point(Number(nodeXML.@x), Number(nodeXML.@y));
			}
			
			for each (var segmentXML:XML in segmentsXML.segment)
			{
				references.push(new PathReference(int(segmentXML.@a), int(segmentXML.@b), int(segmentXML.@c)));
			}
			
			var reference:PathReference;
			
			for each (reference in references)
			{
				backtrackPath(reference);
			}
			
			for each (var pathReference:PathReference in references)
			{
				if (!pathReference.path.backward.length)
				{
					pathStarts.push(pathReference.path);
				}
				
				if (!pathReference.path.forward.length)
				{
					pathEnds.push(pathReference.path);
				}
			}
			
			return new Paths(pathStarts, pathEnds);
		}
		
		static private function backtrackPath(pathReference:PathReference):Path
		{
			if (!pathReference.path)
			{
				var a:Point = nodePoints[pathReference.start];
				var b:Point = nodePoints[pathReference.end];
				var c:Point = nodePoints[pathReference.anchor];
				
				pathReference.path = new Path(a, b, c, ++index);
				
				for each (var reference:PathReference in references)
				{
					if (reference.start == pathReference.end)
					{
						pathReference.path.addPath(backtrackPath(reference));
					}
				}
			}
			
			return pathReference.path;
		}
	}
}

import sourbit.library.bezier.Path;

class PathReference
{
	public var path:Path;
	public var start:int;
	public var end:int;
	public var anchor:int;
	
	public function PathReference(start:int, end:int, anchor:int)
	{
		this.start = start;
		this.end = end;
		this.anchor = anchor;
	}
	
	public function toString():String
	{
		return "[PathReference start=" + start + " end=" + end + " anchor=" + anchor + "]";
	}
}