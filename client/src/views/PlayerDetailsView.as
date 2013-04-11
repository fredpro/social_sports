package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import enums.Constants;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	import models.PlayerModel;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;
	
	public class PlayerDetailsView extends AbstractView
	{
		//-----------------------------------------------
		// CONSTANTS
		//-----------------------------------------------
		
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		private var _model:PlayerModel;
		private var _playerBg:Image;
		
		public function PlayerDetailsView()
		{
			super();
		}
		
		override public function destroyView():void
		{
			if (_playerBg != null)
			{
				TextureManager.instance.freePrefixFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_BG);
				_playerBg.dispose();
				_playerBg = null;
			}
			
			super.destroyView();
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		/**
		 * init the view so it displays what should be displayed on screen. Before calling this function, nothing should be displayed on view (otherwise, create an "update" function).
		 * @param model the model containing the data to be displayed in the view 
		 * 
		 */
		public function initView(model:PlayerModel):void
		{
			_model = model;
			
			loadResources();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
		private function loadResources():void
		{
			ResourcesManager.getInstance().loadResource("PLAYER_POPUP_SWF", onResourcesLoaded);
		}
		
		private function onResourcesLoaded():void
		{
			 var playerProfileTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McPlayerProfilePopupFinal"), Constants.PLAYER_PROFILE_ATLAS);
			 _playerBg = TextureManager.instance.imageFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_BG);
			 _playerBg.pivotX = _playerBg.width >> 1;
			 _playerBg.pivotY = _playerBg.height >> 1;
			 _playerBg.x = container.stage.stageWidth >> 1;
			 _playerBg.y = container.stage.stageHeight >> 1;
			 container.addChild(_playerBg);
			 
			 var dataContainer:Sprite = new Sprite();
			 
			 var mc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McPlayerProfileDataReference");
			 for (var i:int = 0; i < mc.numChildren; i++)
			 {
				 var disobj:flash.display.DisplayObject = mc.getChildAt(i);
				 if (disobj is flash.text.TextField)
				 {
					 trace("tf ", disobj.name);
				 }
				 else if (disobj is Bitmap)
				 {
					 trace("bmp");
				 }
			 }
		}
	}
}