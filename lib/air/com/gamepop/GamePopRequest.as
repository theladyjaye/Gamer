package com.gamepop
{
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestDefaults;
	import flash.net.URLVariables;
	import flash.events.Event;
	
	class GamePopRequest
	{
		private static const DOMAIN     = 'http://gamepopapp.com:7331';
		private static const USER_AGENT = 'GamePop AIR';
		
		private var apiKey : String;
		
		public function GamePopRequest(apiKey:String=null)
		{
			URLRequestDefaults.userAgent = GamePopRequest.USER_AGENT;
			this.apiKey = apiKey;
		}
		
		public function execute(action:GamePopAction, callback:Function):void
		{
			var url     : String = (~action.endpoint.indexOf("http://")) ? action.endpoint : GamePopRequest.DOMAIN + action.endpoint;
			
			var request : URLRequest = new URLRequest();
			var headers : Array      = [new URLRequestHeader('Authorization', 'OAuth ' + apiKey), 
			                            new URLRequestHeader('Accept', 'application/json')];
			
			if(action.query)
				url = url + '?' + action.query.toString();
			
			request.method           = action.method;
			request.url              = url;
			request.requestHeaders   = headers;
			
			switch(action.method)
			{
				case URLRequestMethod.POST:
					if(action.data) request.data = action.data;
				break;
			}
			
			var loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event)
			{
				var response : GamePopResponse = GamePopResponse.responseWithJSON(e.target.data);
				var error    : GamePopError = null;
				
				if(response.ok == false)
				{
					error    = new GamePopError(response.data.code, response.data.message);
				}
					
				// this callback comes from the GamePopClient
				callback(error, response);
				
				e.target.removeEventListener(Event.COMPLETE, arguments.callee);
			});
			
			loader.load(request); 
		}
	}
}