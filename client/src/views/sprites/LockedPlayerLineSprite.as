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
	
	public class LockedPlayerLineSprite extends Sprite
	{			
		public static const LINE_HEIGHT:Number = 25;
		
		private var _playerProfile:TeamBuildingViewUser;
		private var _bgImg:Image;
		private var _nameTxt:TextField;
		private var _levelTxt:TextField;
		private var _pictureHolder:Sprite;
		private var _icon:Image;
		
		public function LockedPlayerLineSprite()
		{
			_bgImg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_LOCKED_PLAYER_LINE_BG);
			addChild(_bgImg);
			
			// creates the player slot
			var slotRefMc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McLockedPlayerLine");
			
			var disobj:flash.display.DisplayObject = slotRefMc.getChildByName("PICTURE_HOLDER");
			_pictureHolder = new Sprite();
			_pictureHolder.name = disobj.name;
			_pictureHolder.x = disobj.x;
			_pictureHolder.y = disobj.y;
			addChild(_pictureHolder);
			
			_nameTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_LOCKED_PLAYER_LINE_NAME"));
			addChild(_nameTxt);
			_levelTxt = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_LOCKED_PLAYER_LINE_LEVEL"));
			addChild(_levelTxt);
			disobj = slotRefMc.getChildByName("icon_mc");
			_icon = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_LOCK_ICON);
			var ratio:Number = disobj.height/_icon.height;
			_icon.width *= ratio;
			_icon.height *= ratio;
			_icon.x = disobj.x;
			_icon.y = disobj.y;
			addChild(_icon);
		}
		
		public function destroy():void
		{
			if (_bgImg != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_LOCKED_PLAYER_LINE_BG);
				_bgImg.dispose();
				_bgImg = null;
			}
			if (_icon != null)
			{
				TextureManager.instance.freeTextureFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_LOCK_ICON);
				_icon.dispose();
				_icon = null;
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
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		public function set playerProfile(player:TeamBuildingViewUser):void
		{
			_playerProfile = player;
			updatePlayerProfile();
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
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
			
			flatten();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
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
