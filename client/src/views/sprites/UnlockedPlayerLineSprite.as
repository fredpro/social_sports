package views.sprites
{
	import com.fourcade.lang.LanguageFile;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.ClassicTextFieldWrapper;
	import com.fourcade.utils.StarlingTextFieldUtils;
	import com.fourcade.utils.TextureManager;
	
	import enums.Constants;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	import models.UserModel;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	import views.models.TeamBuildingViewUser;
	
	/**
	 * This class is a Sprite that contains graphics and TextField to represent an unlocked player in the user's players list 
	 * @author Fred
	 * 
	 */
	public class UnlockedPlayerLineSprite extends Sprite
	{
		public static const LINE_HEIGHT:Number = 25;
		
		/**
		 * The player profile
		 */
		private var _playerProfile:TeamBuildingViewUser;
		/**
		 * The bg image of the line
		 */
		private var _bgImg:Image;
		/**
		 * The textfield containing th ename of the player
		 */
		private var _nameTxt:TextField;
		/**
		 * The textfield containing the level of the player
		 */
		private var _levelTxt:TextField;
		/**
		 * The sprite that will contain the picture of the player
		 */
		private var _pictureHolder:Sprite;
		/**
		 * The container for the team icon
		 */
		private var _iconHolder:Sprite;
		/**
		 * The height of the icon
		 */
		private var _iconHeight:Number;
		
		public function UnlockedPlayerLineSprite()
		{
			_bgImg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_UNLOCKED_PLAYER_LINE_BG);
			addChild(_bgImg);
			
			// creates the player slot
			var slotRefMc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McUnlockedPlayerLine");
			
			var disobj:flash.display.DisplayObject = slotRefMc.getChildByName("PICTURE_HOLDER");
			_pictureHolder = new Sprite();
			_pictureHolder.name = disobj.name;
			_pictureHolder.x = disobj.x;
			_pictureHolder.y = disobj.y;
			addChild(_pictureHolder);
			
			_nameTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_UNLOCKED_PLAYER_LINE_NAME"));
			addChild(_nameTxt);
			_levelTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_UNLOCKED_PLAYER_LINE_LEVEL"));
			addChild(_levelTxt);
			disobj = slotRefMc.getChildByName("icon_mc");
			_iconHeight = disobj.height;
			_iconHolder = new Sprite();
			_iconHolder.x = disobj.x;
			_iconHolder.y = disobj.y;
			addChild(_iconHolder);
		}
		
		public function destroy():void
		{
			if (_bgImg != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_LOCKED_PLAYER_LINE_BG);
				_bgImg.dispose();
				_bgImg = null;
			}
			if (_levelTxt != null)
			{
				_levelTxt.nativeFilters = null;
				_levelTxt.dispose();
				_levelTxt = null;
			}
			if (_nameTxt != null)
			{
				_nameTxt.nativeFilters = null;
				_nameTxt.dispose();
				_nameTxt = null;
			}
			for (var i:int = 0; i < _pictureHolder.numChildren; i++)
			{
				var displayObject:starling.display.DisplayObject = _pictureHolder.getChildAt(i);
				if (displayObject is Image)
				{
					var picture:Image = _pictureHolder.getChildAt(0) as Image;
					TextureManager.instance.freeTexture(picture.name);
					Image(displayObject).dispose();
				}
			}
			for (i = 0; i < _iconHolder.numChildren; i++)
			{
				displayObject = _iconHolder.getChildAt(i);
				if (displayObject is Image)
				{
					picture = _iconHolder.getChildAt(0) as Image;
					TextureManager.instance.freeTexture(picture.name);
					Image(displayObject).dispose();
				}
			}
			_iconHolder.removeChildren(0, -1, true);
			_iconHolder = null;
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		/**
		 * Sets the player profile of the line, which requires an udpate of the player's data
		 * @param player The new player profile of the line
		 * 
		 */
		public function set playerProfile(player:TeamBuildingViewUser):void
		{
			_playerProfile = player;
			updatePlayerProfile();
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		/**
		 * Updates the player's data in the line (updates name, level, picture and icon)
		 * 
		 */
		public function updatePlayerProfile():void
		{
			_nameTxt.text = _playerProfile.name;
			_levelTxt.text = String(_playerProfile.level);
			if (_pictureHolder.numChildren > 0 && _pictureHolder.getChildAt(0).name != _playerProfile.smallPictureUrl)
			{
				TextureManager.instance.freeTexture(_pictureHolder.getChildAt(0).name);
				_pictureHolder.removeChildAt(0);
			}
			if (_pictureHolder.numChildren == 0)
			{
				if (TextureManager.instance.doTextureExists(_playerProfile.smallPictureUrl) || ResourcesManager.getInstance().isBaseClassExist(_playerProfile.smallPictureUrl))
				{
					onPictureLoaded();
				}
				else
				{
					ResourcesManager.getInstance().loadResource(_playerProfile.smallPictureUrl, onPictureLoaded);
				}
			}
			if (_iconHolder.numChildren > 0 && (_playerProfile.teamId == -1 || _iconHolder.getChildAt(0).name != Constants.TEAM_BUILDING_ICONS_LIST[_playerProfile.teamId]))
			{
				TextureManager.instance.freeTexture(_iconHolder.getChildAt(0).name);
				_iconHolder.removeChildAt(0);
			}
			if (_iconHolder.numChildren == 0 && _playerProfile.teamId > -1)
			{
				var icon:Image = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_ICONS_LIST[_playerProfile.teamId]);
				var ratio:Number = _iconHeight / icon.height;
				icon.width *= ratio;
				icon.height *= ratio;
				_iconHolder.addChild(icon);
			}
			
			flatten();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
		/**
		 * The picture is loaded, so we remove the one in the picture holder (if any, or if different), and add the new one
		 * 
		 */
		private function onPictureLoaded():void
		{
			var picture:Image;
			if (TextureManager.instance.doTextureExists(_playerProfile.smallPictureUrl))
			{
				picture = TextureManager.instance.imageFromTexture(_playerProfile.smallPictureUrl);
			}
			else
			{
				picture = TextureManager.instance.imageFromBitmap(_playerProfile.smallPictureUrl, ResourcesManager.getInstance().newBitmap(_playerProfile.smallPictureUrl));
			}
			picture.name = _playerProfile.smallPictureUrl;
			if (picture.width > UserModel.SMALL_PICTURE_SIZE)
			{
				var ratio:Number = UserModel.SMALL_PICTURE_SIZE / picture.width;
				picture.width *= ratio;
				picture.height *= ratio;
			}
			_pictureHolder.addChild(picture);
			
			flatten();
		}
	}
}
