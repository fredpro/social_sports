package proxies
{    
//    import amfvo.RequestVo;
//    import amfvo.ResponseVo;
    
    import amfvo.ResponseVo;
    
    import com.fourcade.app.starling.proxy.AbstractProxy;
    import com.fourcade.utils.StringUtils;
    
    import enums.Constants;
    
    import flash.events.AsyncErrorEvent;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.system.Security;
    import flash.utils.describeType;
    
    import models.TeamModel;
    
    public class WebServerProxy extends AbstractProxy
    {
        //-----------------------------------------------
        // CONSTANTS
        //-----------------------------------------------
        private static const SESSION_EXPIRED_ERROR_CODE:int = 202;
        private static const REQUEST_RESPONSE_FORMAT_ERROR_CODE:int = 666;
        
        //-----------------------------------------------
        // VARIABLES
        //-----------------------------------------------
        private var _mainController:MainController;
        private var _requestQueue:Vector.<WebServerRequest>;
        private var _currentRequest:WebServerRequest;
        private var _running:Boolean;
		private var _loader:URLLoader;
//        private var _connection:NetConnection;
//        private var _responder:Responder;
//        private var _connected:Boolean;
        
        /**
         * mxp4 proxy constructor, need a reference to the main controller 
         * @param controller
         * 
         */
        public function WebServerProxy(controller:MainController)
        {
            super();
            _mainController = controller;
            _requestQueue = new Vector.<WebServerRequest>();
            _running = false;
			_loader = new URLLoader();
			configureListeners(_loader);
//            _connected = false;
//            _responder = new Responder(onRequestResponse, onRequestError);
//            _connection = new NetConnection();
//            _connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, onAsyncError);
//            _connection.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
//            _connection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
//            _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
//            _connection.connect(Constants.WEB_SERVER_GATEWAY);
            
            registerClassAliases();
        }
        
        //-----------------------------------------------
        // PUBLIC METHODS
        //-----------------------------------------------
        
        public function getUserProfile(callback:Function):void
        {
            _requestQueue.push(new WebServerRequest("manager/profile/me", null, callback));
            start();
            trace("___GET GAME CONFIG ___");
        }           
		
		/**
		 * The team has been updated, so we must send the modification to the server
		 * @teamId the id of the team that has been updated
		 * @team the list of players of the corresponding team
		 * 
		 */
		public function onTeamUpdated(teams:Vector.<Vector.<String>>, callback:Function):void
		{
			var params:Object = new Object();
			params["teams"] = JSON.stringify(teams);
			_requestQueue.push(new WebServerRequest("manager/teams/update", params, callback));
			start();
		}
        
        //-----------------------------------------------
	    // PRIVATE METHODS
	    //-----------------------------------------------
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE, onRequestResponse);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHTTPStatus);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
		}
	    
	    private function registerClassAliases():void
	    {
//	        registerClassAlias("amfvo.RequestVo", RequestVo);
//	        registerClassAlias("amfvo.ResponseVo", ResponseVo);
	    }
	    
	    private function start():void
	    {
	        if (!_running)
	        {
	            processNextRequest();
	            _running = true;
	        }
	    }
	    
	    private function processNextRequest():void
	    {
	        if (_requestQueue.length > 0)
	        {
	            _currentRequest = _requestQueue.shift();
	            sendRequest(_currentRequest);
	        }
	        else
	        {
	            _currentRequest = null;
	            _running = false;
	        }
	    }
	    
	    private function sendRequest(request:WebServerRequest):void
	    {
//	        _connection.call(request.method, _responder, new RequestVo(request.params));
			var urlRequest:URLRequest = new URLRequest(Constants.WEB_SERVER_GATEWAY + "/" + request.method);
			urlRequest.method = URLRequestMethod.POST;  
			if (request.params != null)
			{
				var variables:URLVariables = new URLVariables();
				for (var key:String in request.params)
				{
					variables[key] = request.params[key];
				}
				urlRequest.data = variables;
			}
			_loader.load(urlRequest);
	    }
	    
	    private function onRequestResponse(data:Object):void
	    {
			trace("DATA", data.target.data);
	        var responseVo:ResponseVo = new ResponseVo(0, "", JSON.parse(data.target.data));
	        if (responseVo.status == 0 && responseVo.result == null)
	        {
	            throw new Error("wrong request response data", REQUEST_RESPONSE_FORMAT_ERROR_CODE);
	            _mainController.displayErrorPopup();
	        }
	        else
	        {            
	            if(responseVo.status > 0)
	            {
	                trace("MXP4 Proxy ERROR : " + responseVo.status + " " + responseVo.statusMessage);
	                
	                _mainController.displayErrorPopup();
	            }
	            else
	            {
	                var callback:Function = _currentRequest.callback;
	                processNextRequest();
	                if (callback != null)
	                {
	                    callback.call(null, responseVo);
	                }
	            }
	        }
	    }
	    
	    /**
	     * Called when a request to the service has been answered with an error. 
	     * @param data an Object describing the error
	     * 
	     */
	    private function onRequestError(data:Object):void
	    {
	        trace("Error on request:");
	        trace(data.description);
	        _mainController.displayErrorPopup();
	    }
	    
	    private function onAsyncError(event:AsyncErrorEvent):void
	    {
	        trace("Async Error:");
	        trace(event.error.toString());
	    }
	    
	    /**
	     * Called when an input or output error occurs that causes a network operation to fail. 
	     * @param event The event object describing this error.
	     * 
	     */
	    private function onIoError(event:IOErrorEvent):void
	    {
	        trace("I/O Error in connection to the mxp4 platform:");
	        trace(event.toString());
	    }
	    
	    private function onHTTPStatus(event:HTTPStatusEvent):void
	    {
	        trace("HTTP Status event:", event.status);
	    }
	    
	    private function onSecurityError(event:SecurityErrorEvent):void
	    {
	        trace("Security Error:");
	        trace(event.toString());
	    }

        
        public function sendUseBooster(callback:Function, playOccurenceId:int, boosterId:String):void
        { 
            trace("___ SEND USE BOOSTER ___", "playOccurenceId", playOccurenceId, "boosterId", boosterId); 
            var params:Object = new Object();
            params.playOccurenceId = playOccurenceId;
            params.boosterId = boosterId;
//            _requestQueue.push(new Mxp4Request("Application_Amf_ShopManager.useBooster", params, callback));
//            start(); //#TODO remove when server call works
        }   
	}
}

class WebServerRequest
{
    private var _method:String;
    private var _params:Object;
    private var _callback:Function;
    
    public function WebServerRequest(method:String, params:Object, callback:Function=null):void
    {
        _method = method;
        _params = (params == null) ? [] : params;
        _callback = callback;
    }
    
    /**
     * The callback function called once request success.
     */
    public function get callback():Function
    {
        return _callback;
    }
    
    /**
     * The remote method called by the request.
     * @return The name of the remote method.
     * 
     */
    public function get method():String
    {
        return _method;
    }
    
    /**
     * The arguments passed to the remote function.
     * @return An array containing the arguments.
     * 
     */
    public function get params():Object
    {
        return _params;
    }
}
