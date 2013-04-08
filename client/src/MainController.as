package
{
	import amfvo.ResponseVo;
	
	import com.mxp4.app.starling.MasterClass;
	
	import controllers.TeamBuildingController;
	
	import enums.Constants;
	
	import models.vo.ManagerVO;
	
	import proxies.WebServerProxy;
	
	import starling.display.Sprite;
	
	public class MainController extends MasterClass
	{
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _model:MainModel;
		private var _teamBuildingController:TeamBuildingController;
		private var _webServerProxy:WebServerProxy;
		
		public function MainController(rootClip:Sprite)
		{
			super();
			setRootClip(rootClip);
			debugMode = Constants.DEBUG_MODE;
			
			_model = new MainModel();
			_teamBuildingController = new TeamBuildingController(this);
			_webServerProxy = new WebServerProxy(this);
			_webServerProxy.getUserProfile(onUserProfileResponse);
		}
		
		//-----------------------------------------------
		// GETTERS AND SETTERS
		//-----------------------------------------------
		
		public function get model():MainModel
		{
			return _model;
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------

		/**
		 * Called when a new asset is loaded during a loading session. This updates the loading screen
		 * @param nbAssets the number of assets that must be added to the loading process management
		 * 
		 */
		public function addLoadingAsset(nbAssets:int=1):void
		{
//			_loadingController.addLoadingAssetToView(nbAssets);
		}
		
		/**
		 * When the loading progress is updated by the loader, we update the loading screen
		 * @param percentage the percentage of the current loading asset
		 * 
		 */
		public function onLoadingProgress(percentage:Number):void
		{
//			_loadingController.updateLoadingProgress(percentage);
		}
		
		/**
		 * When an asset has finished downloading. We update the loading screen regarding this event
		 * 
		 */
		public function onLoadingComplete():void
		{
//			_loadingController.updateLoadingProgress(1.0);
		}
		
		/**
		 * Asks the PopupView to display the Error Popup
		 * 
		 */
		public function displayErrorPopup():void
		{
			super.displayBasicErrorPopup();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
		/* WebServerProxy responses */
		
		private function onUserProfileResponse(data:ResponseVo):void
		{
			trace("data = ", data.result);
			
			_model.updateUser(new ManagerVO(data.result));
			
			_teamBuildingController.initView(_model.createTeamBuildingViewModel());
		}
		
	}
}