package sourbit.library.tools
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	public class Report
	{
		static private const SERVER_URL:String = "http://sourbit.com.br/report.php";
		
		static private var _report:URLVariables;
		static private var _request:URLRequest;
		static private var _loader:URLLoader;
		
		static private var _onResultCallback:Function;
		
		static public function recordLevelTime(level:int, time:int):void
		{
			if (!_report)
			{
				_report = new URLVariables();
				_request = new URLRequest(SERVER_URL);
				_loader = new URLLoader();
				
				_request.method = URLRequestMethod.POST;
				_request.data = _report;
				
				_loader.addEventListener(Event.COMPLETE, onLoaderComplete);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
			}
			
			var key:String = level + "[]";
			
			if (!_report[key])
			{
				_report[key] = [];
			}
			
			_report[key].push(time);
		}
		
		static public function save(onResultCallback:Function):void
		{
			_onResultCallback = onResultCallback;
			_loader.load(_request);
		}
		
		static private function onLoaderIoError(event:IOErrorEvent):void
		{
			if (_onResultCallback)
			{
				_onResultCallback(false);
				_onResultCallback = null;
			}
			
			trace("Couldn't save the Report");
		}
		
		static private function onLoaderComplete(event:Event):void
		{
			if (_onResultCallback)
			{
				_onResultCallback(true);
				_onResultCallback = null;
			}
			
			_report = new URLVariables();
		}
	}
}