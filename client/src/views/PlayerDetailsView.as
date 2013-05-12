package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.lang.LanguageFile;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.ClassicTextFieldWrapper;
	import com.fourcade.utils.MathUtils;
	import com.fourcade.utils.StarlingTextFieldUtils;
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
		/**
		 * The controller of the view
		 */
		private var _controller:TeamBuildingController;
		/**
		 * The model that contains data to display in the view
		 */
		private var _model:PlayerModel;
		/**
		 * An image behind the player data sheet that pushes the sheet in front of what lay behind
		 */
		private var _preventClickZone:Image;
		/**
		 * The image of the the sheet without the data on it
		 */
		private var _playerBg:Image;
		/**
		 * The image of the shadow of the sheet
		 */
		private var _playerShadow:Image;
		/**
		 * The container of all the TextField in which we will write the player's data
		 */
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
						if (TextureManager.instance.doTextureExists(_model.normalPictureUrl) || ResourcesManager.getInstance().isBaseClassExist(_model.normalPictureUrl))
						{
							onPictureLoaded();
						}
						else
						{
							ResourcesManager.getInstance().loadResource(_model.normalPictureUrl, onPictureLoaded);
						}
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
		
		/**
		 * This method loads every external files that will contain graphic objects that will be used in the current view
		 * 
		 */
		private function loadResources():void
		{
			ResourcesManager.getInstance().loadResource("PLAYER_POPUP_SWF", onResourcesLoaded);
		}
		
		/**
		 * All the external resources have been loaded, so we can create the assets of the view
		 * 
		 */
		private function onResourcesLoaded():void
		{
			// we first create a rectangle the size of the screen that will help put the sheet in front, from a bitmapdata that we convert to an image
			var bdt:BitmapData = new BitmapData(container.stage.stageWidth, container.stage.stageHeight, false, PREVENT_CLICK_ZONE_COLOR);
			_preventClickZone = TextureManager.instance.imageFromBitmap(Constants.PREVENT_CLICK_ZONE_TEXTURE_NAME, new Bitmap(bdt), true);
			// we dispose the bitmap data to free memory
			bdt.dispose();
			// we set the alpha of the image
			_preventClickZone.alpha = PREVENT_CLICK_ZONE_ALPHA;
			// we say it can be touched, so it prevents (to be confirmed) clicking object behind
			_preventClickZone.touchable = true;
			// we add it to the view container
			container.addChildAt(_preventClickZone, 0);
			
			// we create the container that will contain everything to display the player sheet
			var playerProfileContainer:Sprite = new Sprite();
			// we add it to the view container
			container.addChild(playerProfileContainer);
			// We create the Atlas with all sprites to display player's sheet. the Atlas is created from a standard MovieClip
			var playerProfileTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McPlayerProfilePopupFinal"), Constants.PLAYER_PROFILE_ATLAS, 1, 2);
			// We create the sheet bg image from the TextureAtlas
			_playerBg = TextureManager.instance.imageFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_BG);
			// we move it to the center of the stage
			_playerBg.x = playerProfileContainer.stage.stageWidth >> 1;
			_playerBg.y = playerProfileContainer.stage.stageHeight >> 1;
			// we add it to the sheet container
			playerProfileContainer.addChild(_playerBg);
			// We create the sheet shadow image from the TextureAtlas
			_playerShadow = TextureManager.instance.imageFromTextureAtlas(Constants.PLAYER_PROFILE_ATLAS, Constants.PLAYER_PROFILE_SHADOWS);
			// we move it to the same position as the bg + a little offset (in order to tweak it)
			_playerShadow.x = _playerBg.x;
			_playerShadow.y = _playerBg.y + PLAYER_SHADOW_OFFSET_POS_Y;
			// we add it to the sheet container, at the bottom of the children list
			playerProfileContainer.addChildAt(_playerShadow, 0);
			
			// we create the container to put all the textfields containing the player's data 
			_dataContainer = new Sprite();
			// we position it relatively to the the bg
			_dataContainer.x = _playerBg.x - _playerBg.width / 2 + PLAYER_DATA_CONTAINER_POS_X;
			_dataContainer.y = _playerBg.y - _playerBg.height / 2 + PLAYER_DATA_CONTAINER_POS_Y;
			// we rotate it so it fits with the sheet orientation
			_dataContainer.rotation = MathUtils.degreesToRadians(PLAYER_DATA_CONTAINER_ROT);
			// we prevent clicking on it
			_dataContainer.touchable = false;
			// we add it to the sheet container
			playerProfileContainer.addChild(_dataContainer);
			
			// Now we parse all the children of the reference MovieClip, to create Starling TextFields with same properties as the ones made in Flash
			var mc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McPlayerProfileDataReference");
			for (var i:int = 0; i < mc.numChildren; i++)
			{
				var disobj:flash.display.DisplayObject = mc.getChildAt(i);
				// we use a specific util class that wraps a flash TextField, and helps handling both classic and starling textfield in the code
				if (ClassicTextFieldWrapper.isClassicTextField(disobj))
				{
					trace("tf ", disobj.name);
					// using a util method that creates a Starling TextField from a classic TextField
					var tf:starling.text.TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(disobj);
					_dataContainer.addChild(tf);
				}
				else
				{
					// if the child is not a textField, then it is the picture holder
					trace("other");
					var sprite:Sprite = new Sprite();
					sprite.name = disobj.name;
					sprite.x = disobj.x;
					sprite.y = disobj.y;
					_dataContainer.addChild(sprite);
				}
			}
		}
		
		/**
		 * Gets the player's data value, and replaces the right characters in the ref String given as param
		 * @param ref The String in which we find a substring to replace with player's value
		 * @return The updated String with the correct player value
		 * 
		 */
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
		
		/**
		 * When the player's picture is loaded, we add it to the picture holder, and remove the one already in place (if any)
		 * 
		 */
		private function onPictureLoaded():void
		{
			var pictureHolder:Sprite = _dataContainer.getChildByName(PLAYER_DATA_PICTURE_HOLDER_NAME) as Sprite;
			var picture:Image;
			if (TextureManager.instance.doTextureExists(_model.normalPictureUrl))
			{
				picture = TextureManager.instance.imageFromTexture(_model.normalPictureUrl);
			}
			else
			{
				picture = TextureManager.instance.imageFromBitmap(_model.normalPictureUrl, ResourcesManager.getInstance().newBitmap(_model.normalPictureUrl));
			}
			pictureHolder.addChild(picture);
			pictureHolder.visible = true;
			
			_dataContainer.flatten();
		}
		
		/**
		 * When a click is made on the stage. If it is outside the player's sheetn we close the sheet
		 * @param e The TouchEvent generated
		 * 
		 */
		private function onStageTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(container.stage);
			if (touch.phase == TouchPhase.ENDED && e.getTouch(_playerBg) == null)
			{
				// the player has clicked outside the player sheet, so we hide it
				onClosePlayerDetails();
			}
		}
		
		/**
		 * This method must be called to close the player's sheet
		 * 
		 */
		private function onClosePlayerDetails():void
		{
			_controller.onClosePlayerDetails();
		}
	}
}