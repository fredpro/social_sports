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
		private static const SCROLLBAR_POS_X:Number = 310;
		private static const SCROLLBAR_POS_Y:Number = 78;
		private static const SLIDER_MASK_HEIGHT:Number = 425;
		private static const DRAGGED_PLAYER_SLOT_ALPHA:Number = 0.5;
		
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
		
		private var _teamsSpriteContainerList:Vector.<Sprite>;
		private var _draggedPlayerSlot:PlayerSlotSprite;
		private var _draggedOverTeamSlotIndex:int;
		private var _savedDraggedTeamSlotIndex:int;
		
		private var _currentlyVisibleTeamId:int = 0;
		
		public function TeamBuildingView(controller:TeamBuildingController)
		{
			super();
			_controller = controller;
			_draggedOverTeamSlotIndex = -1;
			_savedDraggedTeamSlotIndex = -1;
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
			_model.parentView = this;
			
			loadResources();
		}
		
		/**
		 * Updates a player slot in the given team
		 * @param teamId The id of the team which slot is updated
		 * @param playerIndex The index of the slot updated in the team
		 * 
		 */
		public function updatePlayerTeamSlot(teamId:int, playerIndex:int):void
		{
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[teamId];
			PlayerSlotSprite(currentTeamSprite.getChildAt(playerIndex)).playerProfile = _model.teams[teamId][playerIndex];
			_controller.onTeamUpdated(teamId, _model.teams[teamId]);
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
			
			_draggedPlayerSlot = new PlayerSlotSprite();
			_draggedPlayerSlot.alpha = DRAGGED_PLAYER_SLOT_ALPHA;
			_draggedPlayerSlot.visible = false;
			container.addChild(_draggedPlayerSlot);
		}
		
		private function initTeam():void
		{
			var l:int = _model.teams.length;
			_teamsSpriteContainerList = new Vector.<Sprite>(l);
			for (var i:int = 0; i < l; i++)
			{
				_teamsSpriteContainerList[i] = new Sprite();
				var tl:int = _model.teams[i].length;
				for (var j:int = 0; j < tl; j++)
				{
					var slot:PlayerSlotSprite = new PlayerSlotSprite();
					_teamsSpriteContainerList[i].addChild(slot);
					slot.x = SOCCER_EMPTY_SLOTS_POS_LIST[2*j];
					slot.y = SOCCER_EMPTY_SLOTS_POS_LIST[2*j+1];
					slot.playerProfile = _model.teams[i][j];
				}
				_teamsSpriteContainerList[i].addEventListener(TouchEvent.TOUCH, onPlayerInteraction);
				_teamsSpriteContainerList[i].useHandCursor = true;
				container.addChild(_teamsSpriteContainerList[i]);
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
			
			_playersLineContainer.addEventListener(TouchEvent.TOUCH, onPlayerInteraction);
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
		
		private function onPlayerInteraction(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(container.stage);
			if (touch != null)
			{
				var index:int = -1;
				var doStopImmediatePropagation:Boolean = false;
				var point:Point = _playersLineContainer.globalToLocal(new Point(touch.globalX, touch.globalY));
				if (point.x > -PLAYER_LINE_CONTAINER_POS_X && point.x < -PLAYER_LINE_CONTAINER_POS_X + _playersLineContainer.width && point.y > -PLAYER_LINE_CONTAINER_POS_Y && point.y < -PLAYER_LINE_CONTAINER_POS_Y + SLIDER_MASK_HEIGHT)
				{
					doStopImmediatePropagation = handlePlayerLinesTouchInteraction(touch);
				}
				else
				{
					doStopImmediatePropagation = handleTeamTouchInteraction(touch);
				}
				
				if (doStopImmediatePropagation)
				{
					e.stopImmediatePropagation();
				}
			}
		}
		
		private function handlePlayerLinesTouchInteraction(touch:Touch):Boolean
		{
			var doStopImmediatePropagation:Boolean = false;
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			
			if (_draggedPlayerSlot != null)
			{
				_draggedPlayerSlot.x = touch.globalX;
				_draggedPlayerSlot.y = touch.globalY;
			}
			
			var point:Point = _playersLineContainer.globalToLocal(new Point(touch.globalX, touch.globalY));
			var index:int = Math.floor(point.y / UnlockedPlayerLineSprite.LINE_HEIGHT);
			point = _sliderSprite.globalToLocal(new Point(touch.globalX, touch.globalY));
			var player:TeamBuildingViewUser;
			if (index > -1 && index < _model.unlockedPlayers.length)
			{
				player = _model.unlockedPlayers[index];
			}
			else if (index > -1 && index < _model.unlockedPlayers.length + _model.lockedPlayers.length)
			{
				player = _model.lockedPlayers[index - _model.unlockedPlayers.length];
			}
			
			if (player != null && touch.phase == TouchPhase.ENDED)
			{
				if (player.isUnlocked)
				{
					_controller.onUnlockedPlayerLineClicked(player.facebookId);
				}
				else
				{
					_controller.onLockedPlayerLineClicked(player.facebookId);
				}
				_draggedPlayerSlot.playerProfile = null;
				_draggedPlayerSlot.visible = false;
				_savedDraggedTeamSlotIndex = -1;
				doStopImmediatePropagation = true;
			}
			else if (player != null && touch.phase == TouchPhase.BEGAN)
			{
				_draggedPlayerSlot.playerProfile = player;
			}
			else if (touch.phase == TouchPhase.MOVED && _draggedPlayerSlot.playerProfile != null)
			{
				_draggedPlayerSlot.visible = true;
				_draggedPlayerSlot.x = touch.globalX;
				_draggedPlayerSlot.y = touch.globalY;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				_draggedPlayerSlot.playerProfile = null;
				_draggedPlayerSlot.visible = false;
				_savedDraggedTeamSlotIndex = -1;
			}
			
			return doStopImmediatePropagation;
		}
		
		private function handleTeamTouchInteraction(touch:Touch):Boolean
		{
			var doStopImmediatePropagation:Boolean = false;
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			
			if (_draggedPlayerSlot != null)
			{
				_draggedPlayerSlot.x = touch.globalX;
				_draggedPlayerSlot.y = touch.globalY;
			}
			
			var teamSlotIndex:int = getTeamPlayerSlotIndexAtPoint(new Point(touch.globalX, touch.globalY));
			if (touch.phase == TouchPhase.BEGAN && teamSlotIndex > -1)
			{
				_draggedPlayerSlot.playerProfile = _model.teams[_currentlyVisibleTeamId][teamSlotIndex];
				_draggedPlayerSlot.visible = true;
				_savedDraggedTeamSlotIndex = teamSlotIndex;
				setTeamSlot(teamSlotIndex, null);
			}
			else if (touch.phase == TouchPhase.MOVED && _draggedPlayerSlot.playerProfile != null)
			{
				_draggedPlayerSlot.visible = true;
				if (teamSlotIndex > -1)
				{
					if (teamSlotIndex != _draggedOverTeamSlotIndex)
					{
						if (_draggedOverTeamSlotIndex > -1)
						{
							currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
						}	
						_draggedOverTeamSlotIndex = teamSlotIndex;
						currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = (_draggedOverTeamSlotIndex == _savedDraggedTeamSlotIndex);
					}
					if (_draggedOverTeamSlotIndex != _savedDraggedTeamSlotIndex)
					{
						_draggedPlayerSlot.x = currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).x;
						_draggedPlayerSlot.y = currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).y;
					}
				}
				else
				{
					if (_draggedOverTeamSlotIndex > -1)
					{
						currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
						_draggedOverTeamSlotIndex = -1;
					}
					_draggedPlayerSlot.x = touch.globalX;
					_draggedPlayerSlot.y = touch.globalY;
				}
			}
			else if (touch.phase == TouchPhase.ENDED && _draggedPlayerSlot != null && _draggedOverTeamSlotIndex > -1)
			{
				setTeamSlot(_draggedOverTeamSlotIndex, _draggedPlayerSlot.playerProfile);
				_draggedPlayerSlot.visible = false;
				currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
				_savedDraggedTeamSlotIndex = -1;
				doStopImmediatePropagation = true;
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				if (_draggedPlayerSlot != null)
				{
					setTeamSlot(_savedDraggedTeamSlotIndex, _draggedPlayerSlot.playerProfile);
				}
				_draggedPlayerSlot.playerProfile = null;
				_draggedPlayerSlot.visible = false;
				_savedDraggedTeamSlotIndex = -1;
			}
			
			return doStopImmediatePropagation;
		}
		
		private function setTeamSlot(teamSlotIndex:int, playerProfile:TeamBuildingViewUser):void
		{
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			if (_savedDraggedTeamSlotIndex > -1)
			{
				_model.setTeamPlayer(_currentlyVisibleTeamId, _savedDraggedTeamSlotIndex, _model.teams[_currentlyVisibleTeamId][teamSlotIndex]);
			}
			_model.setTeamPlayer(_currentlyVisibleTeamId, teamSlotIndex, playerProfile);
		}
		
		private function getTeamPlayerSlotIndexAtPoint(point:Point):int
		{
			var result:int = -1;
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			
			var l:int = currentTeamSprite.numChildren;
			for (var i:int = 0; (i < l && result < 0); i++)
			{
				var slot:PlayerSlotSprite = PlayerSlotSprite(currentTeamSprite.getChildAt(i));
				var rect:Rectangle = slot.getBounds(container.stage);
				if (point.x > rect.x && point.x < rect.x + rect.width && point.y > rect.y && point.y < rect.y + rect.height)
				{
					result = i;
				}
			}
			
			return result;
		}
	}
}