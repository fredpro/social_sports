package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.lang.LanguageFile;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.CustomClassicTextField;
	import com.fourcade.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import enums.Constants;
	
	import flash.display.Bitmap;
	
	import models.PlayerModel;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
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
			 for (var i:int = 0; i < 1; i++)//mc.numChildren; i++)
			 {
				 // #TODO : create custom classes which simply extends TextField, so that we can simply import this class and not flash.text.TextField
				 
				 var disobj:flash.display.DisplayObject = mc.getChildAt(i);
				 if (CustomClassicTextField.isClassicTextField(disobj))
				 {
					 trace("tf ", disobj.name);
					 var ref:CustomClassicTextField = new CustomClassicTextField(disobj);
					 var tf:TextField = new TextField(disobj.width, disobj.height, "");
					 var langObj:Object = LanguageFile.getInstance().getObjectFromId(ref.name);
					 tf.text = replaceVariableContentWithPlayerData(langObj.content);
					 tf.fontName = langObj.format.font;
					 tf.fontSize = (ref.defaultTextFormat.size == null) ? 12 : Number(ref.defaultTextFormat.size);
					 dataContainer.addChild(tf);
				 }
				 else if (disobj is Bitmap)
				 {
					 trace("bmp");
				 }
			 }
		}
		
		private function replaceVariableContentWithPlayerData(ref:String):String
		{
			var result:String = "";
			
			var endPos:int = 0;
			var startPos:int = 0;
			while(startPos > -1)
			{
				startPos = ref.indexOf("[%", endPos);
				if (startPos > -1)
				{
					result += ref.substring(endPos, startPos);
					endPos = ref.indexOf("%]", startPos + 2);
					if (endPos > -1)
					{
						result += _model.replaceVariableInText(ref.substring(startPos + 2, endPos));
						endPos += 2;
					}
				}
			}
			result += ref.substring(endPos);
			
			return result;
		}
	}
}