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
	import flash.geom.Point;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	import models.PlayerModel;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.VAlign;
	
	public class PlayerDetailsView extends AbstractView
	{
		//-----------------------------------------------
		// CONSTANTS
		//-----------------------------------------------
		private static const PLAYER_DATA_CONTAINER_POS_X:int = 39;
		private static const PLAYER_DATA_CONTAINER_POS_Y:int = 81;
		private static const PLAYER_DATA_CONTAINER_ROT:int = -5;
		private static const PLAYER_DATA_PICTURE_HOLDER_NAME:String = "PICTURE_HOLDER";
		private static const PLAYER_SHADOW_OFFSET_POS_Y:int = 27;
		private static const PREVENT_CLICK_ZONE_COLOR:uint = 0x000000;
		private static const PREVENT_CLICK_ZONE_ALPHA:Number = 0.0;
		
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		private var _model:PlayerModel;
		private var _preventClickZone:Image;
		private var _playerBg:Image;
		private var _playerShadow:Image;
		private var _dataContainer:Sprite;
		
		public function PlayerDetailsView(controller:TeamBuildingController)
		{
			super();
			_controller = controller;
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
		 * 
		 */
		public function initView():void
		{
			loadResources();
		}
		
		/**
		 * updates the data displayed in the view with ones provided in the PlayerModel 
		 * @param model the model containing the data to be displayed in the view 
		 * 
		 */
		public function update(model:PlayerModel):void
		{
			_model = model;
			
			for (var i:int = 0; i < _dataContainer.numChildren; i++)
			{
				// #TODO : create custom classes which simply extends TextField, so that we can simply import this class and not flash.text.TextField
				
				var disobj:DisplayObject = _dataContainer.getChildAt(i);
				if (disobj is TextField)
				{
					var tf:TextField = disobj as TextField;
					trace("tf ", disobj.name);
					var langObj:Object = LanguageFile.getInstance().getObjectFromId(tf.name);
					tf.text = replaceVariableContentWithPlayerData(langObj.content);
				}
				else if (disobj is Sprite)
				{
					trace("sprite");
					var sprite:Sprite = disobj as Sprite;
					if (sprite.name == PLAYER_DATA_PICTURE_HOLDER_NAME)
					{
						ResourcesManager.getInstance().loadResource(_model.pictureUrl, onPictureLoaded);
					}
				}
			}
			
			_dataContainer.flatten();
		}
		
		/**
		 * Enables or disables click in the view
		 * @param on Boolean value indicating if the clicks must be enabled or disabled
		 * 
		 */
		public function setInteractivity(on:Boolean):void
		{
			if (on)
			{
				container.stage.addEventListener(TouchEvent.TOUCH, onStageTouched);
			}
			else
			{
				container.stage.removeEventListener(TouchEvent.TOUCH, onStageTouched);
			}
		}
		
		/**
		 * Removes interactivity at the same time the view is hidden
		 * 
		 */
		override public function hide():void
		{
			super.hide();
			setInteractivity(false);
		}
		
		/**
		 * Sets the interactivity at the same time that the view is displayed
		 * 
		 */
		override public function show():void
		{
			super.show();
			setInteractivity(true);
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
			var bdt:BitmapData = new BitmapData(container.stage.stageWidth, container.stage.stageHeight, false, PREVENT_CLICK_ZONE_COLOR);
			_preventClickZone = TextureManager.instance.imageFromBitmap(Constants.PREVENT_CLICK_ZONE_TEXTURE_NAME, new Bitmap(bdt), true);
			bdt.dispose();
			_preventClickZone.alpha = PREVENT_CLICK_ZONE_ALPHA;
			_preventClickZone.touchable = true;
			container.addChildAt(_preventClickZone, 0);
			
			var playerProfileContainer:Sprite = new Sprite();
			container.addChild(playerProfileContainer);
			var playerProfileTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McPlayerProfilePopupFinal"), Constants.PLAYER_PROFILE_ATLAS);
			_playerBg = TextureManager.instance.imageFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_BG);
			_playerBg.pivotX = _playerBg.width >> 1;
			_playerBg.pivotY = _playerBg.height >> 1;
			_playerBg.x = playerProfileContainer.stage.stageWidth >> 1;
			_playerBg.y = playerProfileContainer.stage.stageHeight >> 1;
			playerProfileContainer.addChild(_playerBg);
			_playerShadow = TextureManager.instance.imageFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_SHADOWS);
			_playerShadow.pivotX = _playerShadow.width >> 1;
			_playerShadow.pivotY = _playerShadow.height >> 1;
			_playerShadow.x = _playerBg.x;
			_playerShadow.y = _playerBg.y + PLAYER_SHADOW_OFFSET_POS_Y;
			playerProfileContainer.addChildAt(_playerShadow, 0);
			
			_dataContainer = new Sprite();
			_dataContainer.x = _playerBg.x - _playerBg.width / 2 + PLAYER_DATA_CONTAINER_POS_X;
			_dataContainer.y = _playerBg.y - _playerBg.height / 2 + PLAYER_DATA_CONTAINER_POS_Y;
			_dataContainer.rotation = MathUtils.degreesToRadians(PLAYER_DATA_CONTAINER_ROT);
			_dataContainer.touchable = false;
			playerProfileContainer.addChild(_dataContainer);
			
			var mc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McPlayerProfileDataReference");
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				// #TODO : create custom classes which simply extends TextField, so that we can simply import this class and not flash.text.TextField
				
				var disobj:flash.display.DisplayObject = mc.getChildAt(i);
				if (ClassicTextFieldWrapper.isClassicTextField(disobj))
				{
					trace("tf ", disobj.name);
					var ref:ClassicTextFieldWrapper = new ClassicTextFieldWrapper(disobj);
					var langObj:Object = LanguageFile.getInstance().getObjectFromId(ref.name);
					var tf:starling.text.TextField = new starling.text.TextField(disobj.width, disobj.height, "");
					tf.name = ref.name;
					tf.x = ref.x;
					tf.y = ref.y;
					tf.vAlign = VAlign.TOP;
					tf.hAlign = ref.defaultTextFormat.align;
					tf.fontName = langObj.format.font;
					tf.fontSize = (ref.defaultTextFormat.size == null) ? 12 : Number(ref.defaultTextFormat.size);
					_dataContainer.addChild(tf);
				}
				else
				{
					trace("other");
					var sprite:Sprite = new Sprite();
					sprite.name = disobj.name;
					sprite.x = disobj.x;
					sprite.y = disobj.y;
					_dataContainer.addChild(sprite);
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
		
		private function onPictureLoaded():void
		{
			var pictureHolder:Sprite = _dataContainer.getChildByName(PLAYER_DATA_PICTURE_HOLDER_NAME) as Sprite;
			var picture:Image = TextureManager.instance.imageFromBitmap(_model.pictureUrl, ResourcesManager.getInstance().newBitmap(_model.pictureUrl));
			
			picture.pivotX = picture.width >> 1;
			picture.pivotY = picture.height >> 1;
			pictureHolder.addChild(picture);
			pictureHolder.visible = true;
			
			_dataContainer.flatten();
		}
		
		private function onStageTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(container.stage);
			if (touch.phase == TouchPhase.ENDED && e.getTouch(_playerBg) == null)
			{
				// the player has clicked outside the player sheet, so we hide it
				onClosePlayerDetails();
			}
		}
		
		private function onClosePlayerDetails():void
		{
			_controller.onClosePlayerDetails();
		}
	}
}