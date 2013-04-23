package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.lang.LanguageFile;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.StarlingTextFieldUtils;
	import com.fourcade.utils.StarlingViewPort;
	import com.fourcade.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import enums.Constants;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ClippedSprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import views.models.TeamBuildingViewModel;
	import views.models.TeamBuildingViewUser;
	import views.sprites.LockedPlayerLineSprite;
	import views.sprites.PlayerSlotSprite;
	import views.sprites.UnlockedPlayerLineSprite;
	
	public class TeamBuildingView extends AbstractView
	{
		//-----------------------------------------------
		// CONSTANTS
		//-----------------------------------------------
		private static const BG_CONTAINER_POS_X:Number = 2;
		private static const BG_CONTAINER_POS_Y:Number = 25.5;
		private static const BG_POS_X:Number = 378;
		private static const BG_POS_Y:Number = 252;
		private static const PITCH_POS_X:Number = 548;
		private static const PITCH_POS_Y:Number = 273;
		private static const PLAYER_LINE_CONTAINER_POS_X:int = 160;
		private static const PLAYER_LINE_CONTAINER_POS_Y:int = 81;
		static private const SCROLLBAR_POS_X:Number = 310;
		static private const SCROLLBAR_POS_Y:Number = 78;
		static private const SLIDER_MASK_HEIGHT:Number = 425;
		
		private static const SOCCER_EMPTY_SLOTS_POS_LIST:Vector.<Number> = new <Number>[552, 474, 404, 340, 501, 369, 600, 369, 698, 340, 404, 215, 501, 244, 600, 244, 698, 215, 501, 121, 600, 121];
		
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		private var _model:TeamBuildingViewModel;
		private var _bg:Image;
		private var _pitch:Image;
		private var _playersLineContainer:Sprite;
		private var _viewPort:StarlingViewPort;
		private var _sliderSprite:ClippedSprite;
		private var _sliderMask:Rectangle;
		
		private var _upArrowButton:Button;        
		private var _downArrowButton:Button;        
		private var _scrollbar:Sprite;
		
		private var _slotsList:Vector.<PlayerSlotSprite>;
		
		public function TeamBuildingView(controller:TeamBuildingController)
		{
			super();
			_controller = controller;
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		/**
		 * init the view so it displays what should be displayed on screen. Before calling this function, nothing should be displayed on view (otherwise, create an "update" function).
		 * @param model the model containing the data to be displayed in the view 
		 * 
		 */
		public function initView(model:TeamBuildingViewModel):void
		{
			_model = model;
			
			loadResources();
		}
		
		//-----------------------------------------------
		// PRIVATE METHODS
		//-----------------------------------------------
		
		private function loadResources():void
		{
			ResourcesManager.getInstance().loadResource("TEAM_BUILDING_SCREEN_SWF");
			
			ResourcesManager.getInstance().loadResource(null, onResourcesLoaded);
		}
		
		private function onResourcesLoaded():void
		{
			var teamBuildingTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McTeamBuildingViewSpriteSheet"), Constants.TEAM_BUILDING_ATLAS, 1, 2);
			var teamBuildingScrollingTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McScrollbarSpriteSheet"), Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, 1, 2);
			
			var bgContainer:Sprite = new Sprite();
			bgContainer.x = BG_CONTAINER_POS_X;
			bgContainer.y = BG_CONTAINER_POS_Y;
			container.addChild(bgContainer);
			_bg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_WHITEBOARD);
			_bg.x = BG_POS_X;
			_bg.y = BG_POS_Y;
			bgContainer.addChild(_bg);
			
			_pitch = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_SOCCER_PITCH);
			_pitch.x = PITCH_POS_X;
			_pitch.y = PITCH_POS_Y;
			bgContainer.addChild(_pitch);
			
			var slotRefMc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McTeamBuildingView");
			var nameTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_NAME"));
			var langObj:Object = LanguageFile.getInstance().getObjectFromId(nameTitleTxt.name);
			nameTitleTxt.text = langObj.content;
			bgContainer.addChild(nameTitleTxt);
			var levelTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_LEVEL"));
			langObj = LanguageFile.getInstance().getObjectFromId(levelTitleTxt.name);
			levelTitleTxt.text = langObj.content;
			bgContainer.addChild(levelTitleTxt);
			var checkTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_CHECK"));
			langObj = LanguageFile.getInstance().getObjectFromId(checkTitleTxt.name);
			checkTitleTxt.text = langObj.content;
			bgContainer.addChild(checkTitleTxt);
			
			initTeam();
			
			initPlayersLine();
			
			initScrollbar();
			
			initScrollList();
		}
		
		private function initTeam():void
		{
			var l:int = _model.teams[0].length;
			_slotsList = new Vector.<PlayerSlotSprite>(l);
			for (var i:int = 0; i < l; i++)
			{
				var slot:PlayerSlotSprite = new PlayerSlotSprite();
				_slotsList[i] = slot;
				slot.x = SOCCER_EMPTY_SLOTS_POS_LIST[2*i];
				slot.y = SOCCER_EMPTY_SLOTS_POS_LIST[2*i+1];
				slot.playerProfile = _model.teams[0][i];
				container.addChild(slot);
			}
		}
		
		private function initPlayersLine():void
		{
			_playersLineContainer = new Sprite();
			_playersLineContainer.x = PLAYER_LINE_CONTAINER_POS_X;
			_playersLineContainer.y = PLAYER_LINE_CONTAINER_POS_Y;
			container.addChild(_playersLineContainer);
			_sliderSprite = new ClippedSprite();			
			var sliderContainer:Sprite = new Sprite();
			sliderContainer.addChild(_sliderSprite);
			_playersLineContainer.addChild(sliderContainer);
			
			var l:int = _model.unlockedPlayers.length;
			for (var i:int = 0; i < l; i++)
			{
				var unlockedPlayerLineSprite:UnlockedPlayerLineSprite = new UnlockedPlayerLineSprite();
				unlockedPlayerLineSprite.playerProfile = _model.unlockedPlayers[i];
				unlockedPlayerLineSprite.y = i*UnlockedPlayerLineSprite.LINE_HEIGHT + UnlockedPlayerLineSprite.LINE_HEIGHT/2;
				_sliderSprite.addChild(unlockedPlayerLineSprite);
				unlockedPlayerLineSprite.useHandCursor = true;
			}
			
			var nextPosY:int = unlockedPlayerLineSprite.y + UnlockedPlayerLineSprite.LINE_HEIGHT/2;
			
			l = _model.lockedPlayers.length;
			for (i = 0; i < l; i++)
			{
				var lockedPlayerLineSprite:LockedPlayerLineSprite = new LockedPlayerLineSprite();
				lockedPlayerLineSprite.playerProfile = _model.lockedPlayers[i];
				lockedPlayerLineSprite.y = nextPosY + i*LockedPlayerLineSprite.LINE_HEIGHT + LockedPlayerLineSprite.LINE_HEIGHT/2;
				_sliderSprite.addChild(lockedPlayerLineSprite);
				lockedPlayerLineSprite.useHandCursor = true;
			}
			
			var point:Point = _sliderSprite.localToGlobal(new Point(0, 0));
			_sliderMask = new Rectangle(0, point.y, Starling.current.stage.width, SLIDER_MASK_HEIGHT);
			
			_playersLineContainer.addEventListener(TouchEvent.TOUCH, onPlayerLineTouched);
		}
		
		private function initScrollbar():void
		{
			createScrollBar();
			_scrollbar.x = SCROLLBAR_POS_X;
			_scrollbar.y = SCROLLBAR_POS_Y;
			container.addChild(_scrollbar);
		} 
		
		private function initScrollList():void
		{
			if (_viewPort != null)
			{
				_viewPort.destroy();
				_viewPort = null;
			}
			_viewPort = new StarlingViewPort(_sliderSprite, _sliderMask, _scrollbar, _upArrowButton, _downArrowButton);
			_viewPort.scrollingDelta = 200;
			_viewPort.scrollingCursorTopDownMargin = 5;
			_viewPort.scrollViewPort(0);
		}
		
		private function createScrollBar():void
		{
			_scrollbar = new Sprite();
			
			var bgScrollbar:Image = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_BG, false, false);
			bgScrollbar.name = StarlingViewPort.SCROLL_BAR_BG_NAME;
			_scrollbar.addChild(bgScrollbar); 
			
			var scrollbarCursor:Button = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_CURSOR);
			scrollbarCursor.pivotY += 2;
			scrollbarCursor.x = bgScrollbar.x + bgScrollbar.width / 2 - scrollbarCursor.width / 2;
			scrollbarCursor.y = bgScrollbar.y;
			scrollbarCursor.name = StarlingViewPort.SCROLL_BAR_CURSOR_NAME;
			_scrollbar.addChild(scrollbarCursor);          
			
			_upArrowButton = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_UP_BUTTON);
			_upArrowButton.x = bgScrollbar.x + bgScrollbar.width / 2 - _upArrowButton.width / 2 + 0.5;
			_upArrowButton.y = bgScrollbar.y - _upArrowButton.height + 2;
			_scrollbar.addChild(_upArrowButton);
			
			_downArrowButton = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_DOWN_BUTTON);
			_downArrowButton.x = bgScrollbar.x + bgScrollbar.width / 2 - _downArrowButton.width / 2 + 0.5;
			_downArrowButton.y = bgScrollbar.y + bgScrollbar.height - 3;
			_scrollbar.addChild(_downArrowButton);
		} 
		
		private function onPlayerLineTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_sliderSprite);
			if (touch != null && touch.phase == TouchPhase.ENDED)
			{
				e.stopImmediatePropagation();
				var point:Point = touch.getLocation(_sliderSprite);
				var index:int = Math.floor(point.y / UnlockedPlayerLineSprite.LINE_HEIGHT);
				var player:TeamBuildingViewUser;
				if (index < _model.unlockedPlayers.length)
				{
					player = _model.unlockedPlayers[index];
				}
				else
				{
					player = _model.lockedPlayers[index - _model.unlockedPlayers.length];
				}
				trace("Player line touched : " + player.facebookId + " " + player.name);
				_controller.onPlayerLineClicked(player.facebookId);
			}
		}
	}
}