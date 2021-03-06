package sourbit.library.tools
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	public class Report
	{
		private var _request:URLRequest;
		private var _loader:URLLoader;
		private var _data:Object;
		
		private var _onResultCallback:Function;
		
		public function Report(serviceURL:String)
		{
			_loader = new URLLoader();
			_request = new URLRequest(serviceURL);
			_request.method = URLRequestMethod.POST;
			
			resetData();
			
			_loader.addEventListener(Event.COMPLETE, onLoaderComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoaderIoError);
		}
		
		public function record(name:*, ... data:Array):Report
		{
			recordGrouped.apply(this, [null, name].concat(data));
			
			return this;
		}
		
		public function recordGrouped(group:*, name:*, ... data:Array):Report
		{
			// Shadowing by design
			var group:String = trim(group);
			var name:String = trim(name);
			
			if (_data[group] == undefined)
			{
				_data[group] = {};
			}
			
			if (_data[group][name] == undefined)
			{
				_data[group][name] = [];
			}
			
			for each (var item:* in data)
			{
				_data[group][name].push(String(item));
			}
			
			return this;
		}
		
		/**
		 * @param	onResultCallback function(success:Boolean):void
		 */
		public function save(onResultCallback:Function = null):Report
		{
			_onResultCallback = onResultCallback;
			_request.data = JSON.stringify(_data);
			_loader.load(_request);
			
			return this;
		}
		
		private function onLoaderIoError(event:IOErrorEvent):void
		{
			if (_onResultCallback)
			{
				_onResultCallback(false);
				_onResultCallback = null;
			}
			
			trace("Couldn't save the Report");
			trace(event.text);
		}
		
		private function onLoaderComplete(event:Event):void
		{
			if (_onResultCallback)
			{
				_onResultCallback(true);
				_onResultCallback = null;
			}
			
			resetData();
		}
		
		private function resetData():void
		{
			_data = {};
		}
		
		private function trim(value:String):String
		{
			var result:String;
			
			if (value != null)
			{
				result = String(value).replace(/^\s*(.*?)\s*$/g, "$1");
			}
			else
			{
				result = "";
			}
			
			return result;
		}
		
		public function get serviceURL():String
		{
			return _request.url;
		}
		
		public function set serviceURL(value:String):void
		{
			_request.url = value;
		}
	}
}