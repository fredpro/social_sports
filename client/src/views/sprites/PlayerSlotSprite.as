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
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.VAlign;
	
	import views.models.TeamBuildingViewUser;

	public class PlayerSlotSprite extends Sprite
	{
		private var _emptyImg:Image;
		private var _playerSlotContainer:Sprite;
		private var _playerProfile:TeamBuildingViewUser;
		private var _playerBg:Image;
		private var _playerTextBg:Image;
		private var _nameTxt:TextField;
		private var _levelTxt:TextField;
		private var _pictureHolder:Sprite;
		
		public function PlayerSlotSprite()
		{
			_emptyImg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_EMPTY_SLOT);
			addChild(_emptyImg);
			_emptyImg.visible = true;
			
			// creates the player slot
			_playerSlotContainer = new Sprite();
			_playerSlotContainer.visible = false;
			addChild(_playerSlotContainer);
			var slotRefMc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McPlayerSlot");
			
			var disobj:flash.display.DisplayObject = slotRefMc.getChildByName("bg_mc");
			_playerBg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_PLAYER_SLOT_BG);
			_playerBg.x = disobj.x;
			_playerBg.y = disobj.y;
			_playerSlotContainer.addChild(_playerBg);
			
			disobj = slotRefMc.getChildByName("PICTURE_HOLDER");
			_pictureHolder = new Sprite();
			_pictureHolder.name = disobj.name;
			_pictureHolder.x = disobj.x;
			_pictureHolder.y = disobj.y;
			_playerSlotContainer.addChild(_pictureHolder);
			
			disobj = slotRefMc.getChildByName("text_bg_mc");
			_playerTextBg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_PLAYER_SLOT_TEXT_BG);
			_playerTextBg.x = disobj.x;
			_playerTextBg.y = disobj.y;
			_playerSlotContainer.addChild(_playerTextBg);
			
			_nameTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_PLAYER_SLOT_NAME"));
			_playerSlotContainer.addChild(_nameTxt);
			_levelTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_PLAYER_SLOT_LEVEL"));
			_playerSlotContainer.addChild(_levelTxt);
		}
		
		public function destroy():void
		{
			if (_emptyImg != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_EMPTY_SLOT);
				_emptyImg.dispose();
				_emptyImg = null;
			}
			if (_playerBg != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_PLAYER_SLOT_BG);
				_playerBg.dispose();
				_playerBg = null;
			}
			if (_playerTextBg != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_PLAYER_SLOT_TEXT_BG);
				_playerTextBg.dispose();
				_playerTextBg = null;
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
			_pictureHolder.removeChildren(0, -1, true);
			_pictureHolder = null;
			for (i = 0; i < _playerSlotContainer.numChildren; i++)
			{
				displayObject = _playerSlotContainer.getChildAt(i);
				if (displayObject is Image)
				{
					var image:Image = _playerSlotContainer.getChildAt(0) as Image;
					TextureManager.instance.freeTexture(image.name);
					Image(displayObject).dispose();
				}
			}
			_playerSlotContainer.removeChildren(0, -1, true);
			_playerSlotContainer = null;
		}
		
		//-----------------------------------------------
		// GETTERS AND SETTERS
		//-----------------------------------------------
		
		public function get playerProfile():TeamBuildingViewUser
		{
			return _playerProfile;
		}
		
		public function set playerProfile(player:TeamBuildingViewUser):void
		{
			if (_playerProfile != null)
			{
				ResourcesManager.getInstance().cancelLoading(_playerProfile.normalPictureUrl, onPictureLoaded);
			}
			_playerProfile = player;
			updatePlayerProfile();
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		public function updatePlayerProfile():void
		{
			if (_playerProfile == null)
			{
				_emptyImg.visible = true;
				_playerSlotContainer.visible= false;
			}
			else
			{
				_emptyImg.visible = false;
				_playerSlotContainer.visible= true;
				_nameTxt.text = _playerProfile.name;
				_levelTxt.text = String(_playerProfile.level);
				if (_pictureHolder.numChildren > 0 && _pictureHolder.getChildAt(0).name != _playerProfile.normalPictureUrl)
				{
					TextureManager.instance.freeTexture(_pictureHolder.getChildAt(0).name);
					_pictureHolder.removeChildAt(0);
				}
				if (_pictureHolder.numChildren == 0 || _pictureHolder.getChildAt(0).name != _playerProfile.normalPictureUrl)
				{
					if (TextureManager.instance.doTextureExists(_playerProfile.normalPictureUrl) || ResourcesManager.getInstance().isBaseClassExist(_playerProfile.normalPictureUrl))
					{
						onPictureLoaded();
					}
					else
					{
						ResourcesManager.getInstance().loadResource(_playerProfile.normalPictureUrl, onPictureLoaded);
					}
				}
			}
			
			flatten();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
		private function onPictureLoaded():void
		{
			var picture:Image;
			if (TextureManager.instance.doTextureExists(_playerProfile.normalPictureUrl))
			{
				picture = TextureManager.instance.imageFromTexture(_playerProfile.normalPictureUrl);
			}
			else
			{
				picture = TextureManager.instance.imageFromBitmap(_playerProfile.normalPictureUrl, ResourcesManager.getInstance().newBitmap(_playerProfile.normalPictureUrl));
			}
			
			picture.pivotX = picture.width >> 1;
			picture.pivotY = picture.height >> 1;
			_pictureHolder.addChild(picture);
			
			if (_playerSlotContainer.visible)
			{
				flatten();
			}
		}
	}
}