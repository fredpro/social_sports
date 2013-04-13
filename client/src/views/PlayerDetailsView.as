package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.lang.LanguageFile;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.ClassicTextFieldWrapper;
	import com.fourcade.utils.MathUtils;
	import com.fourcade.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import enums.Constants;
	import enums.Resources;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import models.PlayerModel;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class PlayerDetailsView extends AbstractView
	{
		//-----------------------------------------------
		// CONSTANTS
		//-----------------------------------------------
		private static const PLAYER_DATA_CONTAINER_POS_X:int = 39;
		private static const PLAYER_DATA_CONTAINER_POS_Y:int = 81;
		private static const PLAYER_DATA_CONTAINER_ROT:int = -5;
		
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
			 var mc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McPlayerProfilePopupFinal");
			 for (var i:int = 0; i < mc.data_mc.numChildren; i++)
			 {
				 // #TODO : create custom classes which simply extends TextField, so that we can simply import this class and not flash.text.TextField
				 
				 var disobj:flash.display.DisplayObject = mc.data_mc.getChildAt(i);
				 if (disobj is flash.text.TextField)
				 {
					 var tf:flash.text.TextField = disobj as flash.text.TextField;
					 var langObj:Object = LanguageFile.getInstance().getObjectFromId(tf.name);
					 tf.text = replaceVariableContentWithPlayerData(langObj.content);
					 var format:TextFormat = tf.defaultTextFormat;
					 format.font = langObj.format.font;
//					 tf.embedFonts  = true;
					 tf.defaultTextFormat = format;
					 tf.setTextFormat(format);
				 }
				 else if (disobj is Bitmap)
				 {
					 trace("bmp");
				 }
			 }
			 
			 var bmpDt:BitmapData = new BitmapData(mc.width, mc.height);
			 bmpDt.draw(mc);
			 var img:Image = new Image(Texture.fromBitmapData(bmpDt));
			 container.addChild(img);
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