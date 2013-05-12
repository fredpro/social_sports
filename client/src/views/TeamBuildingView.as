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
	
	import flashx.textLayout.formats.TextAlign;
	
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
		private static const SAVE_BUTTON_POS_X:Number = 698;
		private static const SAVE_BUTTON_POS_Y:Number = 25;
		private static const PLAYER_LINE_CONTAINER_POS_X:int = 160;
		private static const PLAYER_LINE_CONTAINER_POS_Y:int = 81;
		private static const SCROLLBAR_POS_X:Number = 310;
		private static const SCROLLBAR_POS_Y:Number = 78;
		private static const SLIDER_MASK_HEIGHT:Number = 425;
		private static const DRAGGED_PLAYER_SLOT_ALPHA:Number = 0.5;
		private static const SAVE_BUTTON_DISABLE_ALPHA:Number = 0.5;
		
		private static const SOCCER_EMPTY_SLOTS_POS_LIST:Vector.<Number> = new <Number>[552, 474, 404, 340, 501, 369, 600, 369, 698, 340, 404, 215, 501, 244, 600, 244, 698, 215, 501, 121, 600, 121];
		
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		/**
		 * The controller of the view
		 */
		private var _controller:TeamBuildingController;
		/**
		 * The model continaing all data used to create the view
		 */
		private var _model:TeamBuildingViewModel;
		/**
		 * The image to display in the background
		 */
		private var _bg:Image;
		/**
		 * The image of the pitch corresponding to the displayed sport
		 */
		private var _pitch:Image;
		/**
		 * The button to save the teams when they are modified
		 */
		private var _saveButton:Button;
		/**
		 * The container of the players' lines viewport
		 */
		private var _playersLineContainer:Sprite;
		/**
		 * The viewPort object conrtolling the players' lines display (masking, and handling the scrollbar)
		 */
		private var _viewPort:StarlingViewPort;
		/**
		 * The Sprite containing all the players' lines (unlocked or locked), displayed on the left of the screen
		 */
		private var _sliderSprite:ClippedSprite;
		/**
		 * The rectangle defining the part of the _playersLineContainer that is displayed
		 */
		private var _sliderMask:Rectangle;
		
		/**
		 * The up button of the scrollbar
		 */
		private var _upArrowButton:Button;        
		/**
		 * The down button of the scrollbar
		 */
		private var _downArrowButton:Button;        
		/**
		 * The scrollbar of the players' lines viewport
		 */
		private var _scrollbar:Sprite;
		
		/**
		 * The list of sprites containing the PlayerSlotSprites of the different teams
		 */
		private var _teamsSpriteContainerList:Vector.<Sprite>;
		/**
		 * The PlayerSlotSprite which represent the slot being dragged when the user drag's a slot through the screen.
		 * This object is unique and is not destroyed nor is nulled. It is just invisible when not used 
		 */
		private var _draggedPlayerSlot:PlayerSlotSprite;
		/**
		 * The index of teh team's slot over which the mouse is currently over (if any)
		 */
		private var _draggedOverTeamSlotIndex:int;
		/**
		 * The index of the slot from which the _draggedPlayerSlot has been taken (which represents the slots being moved)
		 */
		private var _savedDraggedTeamSlotIndex:int;
		
		/**
		 * The id of the sport currently being displayed on screen (i.e. the one on which the user is making actions)
		 */
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
			// gets the container of the player slots corresponding to the teamId;
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[teamId];
			// We change the playerProfile of the slot correponding to the playerIndex index
			PlayerSlotSprite(currentTeamSprite.getChildAt(playerIndex)).playerProfile = _model.teams[teamId][playerIndex];
			// We activate the save button
			setSaveButtonInteractivity(true);
		}
		
		/**
		 * Updates an unlocked player line in the players list
		 * @param index The index of the player line in the unlockedPlayersList whose line we want to update
		 * 
		 */
		public function updateUnlockedPlayerLine(index:int):void
		{
			// we get the unlocked player's line from the viewPort corresponding to the given index
			var unlockedPlayerLine:UnlockedPlayerLineSprite = _sliderSprite.getChildAt(index) as UnlockedPlayerLineSprite;
			// We update the slot following its playerProfile (which should have been modified, most probably in the model)
			unlockedPlayerLine.updatePlayerProfile();
		}
		
		/**
		 * Updates a locked player line in the players list
		 * @param index The index of the player line in the lockedPlayersList whose line we want to update
		 * 
		 */
		public function updateLockedPlayerLine(index:int):void
		{
			// we get the locked player's line from the viewPort corresponding to the given index
			var lockedPlayerLine:LockedPlayerLineSprite = _sliderSprite.getChildAt(index + _model.unlockedPlayers.length) as LockedPlayerLineSprite;
			// We update the slot following its playerProfile (which should have been modified, most probably in the model)
			lockedPlayerLine.updatePlayerProfile();
		}
		
		/**
		 * Sets the interactivity of the save button. if the button is disabled, it appears slightly transparent
		 * @param on Tells if the button must be disabled or not
		 * 
		 */
		public function setSaveButtonInteractivity(on:Boolean):void
		{
			if (on)
			{
				_saveButton.enabled = true;
			}
			else
			{
				_saveButton.enabled = false;
			}
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
			ResourcesManager.getInstance().loadResource("TEAM_BUILDING_SCREEN_SWF");
			
			ResourcesManager.getInstance().loadResource(null, onResourcesLoaded);
		}
		
		/**
		 * All the external resources have been loaded, so we can create the assets of the view
		 * 
		 */
		private function onResourcesLoaded():void
		{
			// First we create the Atlas containing all the Textures that will be used in the current view to create the images and buttons
			var teamBuildingTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McTeamBuildingViewSpriteSheet"), Constants.TEAM_BUILDING_ATLAS, 1, 2);
			// Secondly, we create the atlas containing the Textures of the different elements of the scollbar
			var teamBuildingScrollingTextureAtlas:TextureAtlas = TextureManager.instance.textureAtlasFromMovieClipContainer(ResourcesManager.getInstance().newMovieClip("McScrollbarSpriteSheet"), Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, 1, 2);
			
			// We create the sprite containing all the bg elements
			var bgContainer:Sprite = new Sprite();
			bgContainer.x = BG_CONTAINER_POS_X;
			bgContainer.y = BG_CONTAINER_POS_Y;
			container.addChild(bgContainer);
			// now we create the whiteboard image, and add it to the bgContainer
			_bg = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_WHITEBOARD);
			_bg.x = BG_POS_X;
			_bg.y = BG_POS_Y;
			bgContainer.addChild(_bg);
			
			// #TODO : creates dynamic picthes images for the different sports (no hardcoded Soccer pitch)
			// we create the soccer pitch image and add it to the bgContainer
			_pitch = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_SOCCER_PITCH);
			_pitch.x = PITCH_POS_X;
			_pitch.y = PITCH_POS_Y;
			bgContainer.addChild(_pitch);
			
			// we create the save button and add it to the bgContainer
			_saveButton = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_ATLAS, Constants.TEAM_BUILDING_SAVE_BUTTON);
			_saveButton.x = SAVE_BUTTON_POS_X;
			_saveButton.y = SAVE_BUTTON_POS_Y;
			var langObj:Object = LanguageFile.getInstance().getObjectFromId("TEAM_BUILDING_SAVE_BUTTON_TEXT");
			_saveButton.textHAlign = TextAlign.LEFT;
			var rect:Rectangle = _saveButton.textBounds;
			// we add an offset to the left border of the button's TextField, so we can have space for the icon
			rect.left = 35;
			_saveButton.textBounds = rect;
			_saveButton.fontName = langObj.format.font;
			_saveButton.text = langObj.content;
			// we add the interaction to the button
			_saveButton.addEventListener(TouchEvent.TOUCH, onSaveButtonTouched);
			// but we disable it until it is useful
			setSaveButtonInteractivity(false);
			bgContainer.addChild(_saveButton);
			
			// In order to place some of the other elements of the view, we take a classic MovieClip as reference, and build Starling assets from its children
			var slotRefMc:flash.display.MovieClip = ResourcesManager.getInstance().newMovieClip("McTeamBuildingView");
			// We create a TextField which will be the header of the Name column. For this we create a Starling TextField using a classicTextField as a reference
			var nameTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_NAME"));
			// we get the object from the languageFile, that will contains text and format details to apply to the created TextField
			langObj = LanguageFile.getInstance().getObjectFromId(nameTitleTxt.name);
			nameTitleTxt.text = langObj.content;
			// finally we add the TextField to the bgContainer
			bgContainer.addChild(nameTitleTxt);
			// We create a TextField which will be the header of the Level column. For this we create a Starling TextField using a classicTextField as a reference
			var levelTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_LEVEL"));
			// we get the object from the languageFile, that will contains text and format details to apply to the created TextField
			langObj = LanguageFile.getInstance().getObjectFromId(levelTitleTxt.name);
			levelTitleTxt.text = langObj.content;
			// finally we add the TextField to the bgContainer
			bgContainer.addChild(levelTitleTxt);
			// We create a TextField which will be the header of the Level column. For this we create a Starling TextField using a classicTextField as a reference
			var checkTitleTxt:TextField = StarlingTextFieldUtils.createStarlingTextFieldFromClassic(slotRefMc.getChildByName("TEAM_BUILDING_TITLE_CHECK"));
			// we get the object from the languageFile, that will contains text and format details to apply to the created TextField
			langObj = LanguageFile.getInstance().getObjectFromId(checkTitleTxt.name);
			checkTitleTxt.text = langObj.content;
			// finally we add the TextField to the bgContainer
			bgContainer.addChild(checkTitleTxt);
			
			// we create all the elements representing the Teams (aka PlayerSlotsSprite)
			initTeam();
			
			// we create the unlocked/locked players' lines in the left part of the view, which is the list of the user's friends, that are accessible as players
			initPlayersLine();
			
			// we create the scrollbar that will be used to scroll the players' lines
			initScrollbar();
			
			// using the players' lines and Scrollbar, we create the viewport that will allow to display only a part of the player's list, and scroll through it using the scrollbar
			initScrollList();
			
			// we create the PlayerSlotSprite that will contain data of the player being dragged (if any) 
			_draggedPlayerSlot = new PlayerSlotSprite();
			_draggedPlayerSlot.alpha = DRAGGED_PLAYER_SLOT_ALPHA;
			// we hide it at first, until there actually is a player being dragged
			_draggedPlayerSlot.visible = false;
			// and we add it to the top container
			container.addChild(_draggedPlayerSlot);
		}
		
		/**
		 * This methods creates a PlayerSlotSprite for each player in each team
		 * 
		 */
		private function initTeam():void
		{
			var l:int = _model.teams.length;
			// we initiate the list of team's container (one sprite for each team)
			_teamsSpriteContainerList = new Vector.<Sprite>(l);
			for (var i:int = 0; i < l; i++)
			{
				// we create the sprite container for the team #i
				_teamsSpriteContainerList[i] = new Sprite();
				var tl:int = _model.teams[i].length;
				for (var j:int = 0; j < tl; j++)
				{
					// we create one slot for each position in the team
					var slot:PlayerSlotSprite = new PlayerSlotSprite();
					_teamsSpriteContainerList[i].addChild(slot);
					slot.x = SOCCER_EMPTY_SLOTS_POS_LIST[2*j];
					slot.y = SOCCER_EMPTY_SLOTS_POS_LIST[2*j+1];
					// we set the slot's playerProfile to the one from the model (it wight be null, meaning the the slot is displayed empty
					slot.playerProfile = _model.teams[i][j];
				}
				// we intiate the interaction the team's slots
				_teamsSpriteContainerList[i].addEventListener(TouchEvent.TOUCH, onPlayerInteraction);
				_teamsSpriteContainerList[i].useHandCursor = true;
				container.addChild(_teamsSpriteContainerList[i]);
			}
		}
		
		/**
		 * Creates the lines displaying the players which arre friends of the current user. 
		 * The ones available to add to the different teams are displayed as unlocked, whereas the other ones are displayed as locked
		 * 
		 */
		private function initPlayersLine():void
		{
			// we create the sprite that will contain all the graphic elements to display the player's list as a viewport
			_playersLineContainer = new Sprite();
			// we place it
			_playersLineContainer.x = PLAYER_LINE_CONTAINER_POS_X;
			_playersLineContainer.y = PLAYER_LINE_CONTAINER_POS_Y;
			// and we add it to the top container
			container.addChild(_playersLineContainer);
			// we create the sprite that will directly contain the players' lines, and which will move vertically when we use the scrollbar
			_sliderSprite = new ClippedSprite();
			// in order to make the viewport work, we need to put the sliderSprite in another sprite where it is the only child
			var sliderContainer:Sprite = new Sprite();
			// so we add the sliderSprite to the slider Container
			sliderContainer.addChild(_sliderSprite);
			// and we add the slider container to the playersListContainer (created at the start of the function)
			_playersLineContainer.addChild(sliderContainer);
			
			// now we parse the list of unlocked players
			var l:int = _model.unlockedPlayers.length;
			for (var i:int = 0; i < l; i++)
			{
				// for each unlocked player in the model, we create an UnlockedPlayerLineSprite
				var unlockedPlayerLineSprite:UnlockedPlayerLineSprite = new UnlockedPlayerLineSprite();
				// we get the playerProfile taken from the model and set the line's playerProfile with it 
				unlockedPlayerLineSprite.playerProfile = _model.unlockedPlayers[i];
				// we place the line at the right y position, based on a constants height value (which can be modified if the line's design is changed)
				unlockedPlayerLineSprite.y = i*UnlockedPlayerLineSprite.LINE_HEIGHT + UnlockedPlayerLineSprite.LINE_HEIGHT/2;
				// then we add the line to the sliderSprite
				_sliderSprite.addChild(unlockedPlayerLineSprite);
				unlockedPlayerLineSprite.useHandCursor = true;
			}
			
			// this value is used a the position of the first of the locked lines
			var nextPosY:int = unlockedPlayerLineSprite.y + UnlockedPlayerLineSprite.LINE_HEIGHT/2;
			
			// now we parse the list of locked players
			l = _model.lockedPlayers.length;
			for (i = 0; i < l; i++)
			{
				// for each locked player in the model, we create an LockedPlayerLineSprite
				var lockedPlayerLineSprite:LockedPlayerLineSprite = new LockedPlayerLineSprite();
				// we get the playerProfile taken from the model and set the line's playerProfile with it 
				lockedPlayerLineSprite.playerProfile = _model.lockedPlayers[i];
				// we place the line at the right y position, based on a constants height value (which can be modified if the line's design is changed)
				lockedPlayerLineSprite.y = nextPosY + i*LockedPlayerLineSprite.LINE_HEIGHT + LockedPlayerLineSprite.LINE_HEIGHT/2;
				// then we add the line to the sliderSprite
				_sliderSprite.addChild(lockedPlayerLineSprite);
				lockedPlayerLineSprite.useHandCursor = true;
			}
			
			// we get the origin of the sliderSprite in the global referential
			var point:Point = _sliderSprite.localToGlobal(new Point(0, 0));
			// we set the position andd size of the mask that will hide everything of the list that is external to the rectangle
			_sliderMask = new Rectangle(0, point.y, Starling.current.stage.width, SLIDER_MASK_HEIGHT);
			
			// we add the interactivity on the players list
			_playersLineContainer.addEventListener(TouchEvent.TOUCH, onPlayerInteraction);
		}
		
		/**
		 * This function initiates the scrollbar that is used to scroll the players list 
		 * 
		 */
		private function initScrollbar():void
		{
			// we create the graphical objects of the scrollbar
			createScrollBar();
			// we position it
			_scrollbar.x = SCROLLBAR_POS_X;
			_scrollbar.y = SCROLLBAR_POS_Y;
			// we add it to the top container
			container.addChild(_scrollbar);
		} 
		
		/**
		 * This function creates the Viewport object that manages the interaction between the scrollbar and the list
		 * 
		 */
		private function initScrollList():void
		{
			// if the viewport already exists, we delete it
			if (_viewPort != null)
			{
				_viewPort.destroy();
				_viewPort = null;
			}
			// we create the viewport using elements creating in other methods
			_viewPort = new StarlingViewPort(_sliderSprite, _sliderMask, _scrollbar, _upArrowButton, _downArrowButton);
			// we set some parameters defining its behavior
			_viewPort.scrollingDelta = 200;
			_viewPort.scrollingCursorTopDownMargin = 5;
			// we reset it to its initla position
			_viewPort.scrollViewPort(0);
		}
		
		/**
		 * This function creates the different elements of the scrollbar
		 * 
		 */
		private function createScrollBar():void
		{
			_scrollbar = new Sprite();
			
			var bgScrollbar:Image = TextureManager.instance.imageFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_BG, false, false);
			bgScrollbar.name = StarlingViewPort.SCROLL_BAR_BG_NAME;
			_scrollbar.addChild(bgScrollbar); 
			
			var scrollbarCursor:Button = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_CURSOR, null, false);
			scrollbarCursor.pivotY += 2;
			scrollbarCursor.x = bgScrollbar.x + bgScrollbar.width / 2 - scrollbarCursor.width / 2;
			scrollbarCursor.y = bgScrollbar.y;
			scrollbarCursor.name = StarlingViewPort.SCROLL_BAR_CURSOR_NAME;
			_scrollbar.addChild(scrollbarCursor);          
			
			_upArrowButton = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_UP_BUTTON, null, false);
			_upArrowButton.x = bgScrollbar.x + bgScrollbar.width / 2 - _upArrowButton.width / 2 + 0.5;
			_upArrowButton.y = bgScrollbar.y - _upArrowButton.height + 2;
			_scrollbar.addChild(_upArrowButton);
			
			_downArrowButton = TextureManager.instance.buttonFromTextureAtlas(Constants.TEAM_BUILDING_SCROLLBAR_ATLAS, Constants.TEAM_BUILDING_SCROLLBAR_DOWN_BUTTON, null, false);
			_downArrowButton.x = bgScrollbar.x + bgScrollbar.width / 2 - _downArrowButton.width / 2 + 0.5;
			_downArrowButton.y = bgScrollbar.y + bgScrollbar.height - 3;
			_scrollbar.addChild(_downArrowButton);
		} 
		
		/**
		 * An interaction has been made with the player's list
		 * @param e The TouchEvent that has been triggered over a player's line
		 * 
		 */
		private function onPlayerInteraction(e:TouchEvent):void
		{
			// we get the touch object in the stage coordinates
			var touch:Touch = e.getTouch(container.stage);
			if (touch != null)
			{
				// if the touch exists, we try to get the player's line that has been ointeracted with
				var index:int = -1;
				var doStopImmediatePropagation:Boolean = false;
				// we get the point in the playersLineContainer coordinates
				var point:Point = _playersLineContainer.globalToLocal(new Point(touch.globalX, touch.globalY));
				// if the point of interaction is within the visible part of the player list...
				if (point.x > -PLAYER_LINE_CONTAINER_POS_X && point.x < -PLAYER_LINE_CONTAINER_POS_X + _playersLineContainer.width && point.y > -PLAYER_LINE_CONTAINER_POS_Y && point.y < -PLAYER_LINE_CONTAINER_POS_Y + SLIDER_MASK_HEIGHT)
				{
					// ... we call the method that handles the interaction with the players' lines
					doStopImmediatePropagation = handlePlayerLinesTouchInteraction(touch);
				}
				// otherwise ...
				else
				{
					// ... we call the method that handles the interaction with the rest of the view (for now, it is mostly the team part of the view)
					doStopImmediatePropagation = handleTeamTouchInteraction(touch);
				}
				
				// if the "handle" methods have returned a "true" value, we stop propagation of the event, 
				// meaning that ana action has already been made, and we don't want to check if there other actions to make
				if (doStopImmediatePropagation)
				{
					e.stopImmediatePropagation();
				}
			}
		}
		
		/**
		 * This methods handles the interaction with the players' lines
		 * @param touch The touch object that happened on a player's line
		 * @return A Boolean value, indicating if an action has been made, so no other check must be made with the current TouchEvent
		 * 
		 */
		private function handlePlayerLinesTouchInteraction(touch:Touch):Boolean
		{
			var doStopImmediatePropagation:Boolean = false;
			// to save some computational time, we set the currentTeamSprite in a variable
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			
			// if we have a slot being currently dragged
			if (_draggedPlayerSlot.visible)
			{
				// the dragged slot follows the touch coordinates
				_draggedPlayerSlot.x = touch.globalX;
				_draggedPlayerSlot.y = touch.globalY;
			}
			
			// we get th epoint of interaction in th ePlayersLineContainer
			var point:Point = _playersLineContainer.globalToLocal(new Point(touch.globalX, touch.globalY));
			// we get the player that is interacted with
			var index:int = Math.floor(point.y / UnlockedPlayerLineSprite.LINE_HEIGHT);
			var player:TeamBuildingViewUser;
			// if the index is less than the number of unlocked players, then the player with which we are interacting is an unlocked player
			if (index > -1 && index < _model.unlockedPlayers.length)
			{
				// so we get him from the unlockedPlayers list of the model
				player = _model.unlockedPlayers[index];
			}
			// otherwise, if it is less than the number unlocked players + the number of locked players, the player is a locked player
			else if (index > -1 && index < _model.unlockedPlayers.length + _model.lockedPlayers.length)
			{
				// so we get him from the lockedPlayers list of the model
				player = _model.lockedPlayers[index - _model.unlockedPlayers.length];
			}
			
			// if the player is not null, it means that we interacted with a player.
			// if the touch action is in ended phase...
			// ... and if there was no slot being dragged, then we consider that the user has clicked on a player
			if (player != null && touch.phase == TouchPhase.ENDED && !_draggedPlayerSlot.visible)
			{
				if (player.isUnlocked)
				{
					// if the player is unlocked, the user wants to display its values (well, it's up to the controller to decide what to do from there)
					_controller.onUnlockedPlayerLineClicked(player.facebookId);
				}
				else
				{
					// if the player is locked, we give the hand to the controller
					_controller.onLockedPlayerLineClicked(player.facebookId);
				}
				doStopImmediatePropagation = true;
			}
			// if there is a player with whom the user interacted, and that is the start of a touch interaction
			else if (player != null && touch.phase == TouchPhase.BEGAN)
			{
				// then we update the draggedPlayerSlot data
				_draggedPlayerSlot.playerProfile = player;
			}
			// if the touch phase is "moved", meaning that the action is a drag 'n drop, and the dragged player slot actually has player data in it...
			else if (touch.phase == TouchPhase.MOVED && _draggedPlayerSlot.playerProfile != null)
			{
				// ... then we show the _draggedPlayerSlot
				_draggedPlayerSlot.visible = true;
			}
			// otherwise, if the touchPhase is "ended", and there is no player clicked
			else if (touch.phase == TouchPhase.ENDED)
			{
				// then we reset the data form the dragged slot
				_draggedPlayerSlot.playerProfile = null;
				_draggedPlayerSlot.visible = false;
				// and the one from the savedDraggedTeamSlotIndex
				_savedDraggedTeamSlotIndex = -1;
				doStopImmediatePropagation = true;
			}
			
			return doStopImmediatePropagation;
		}
		
		/**
		 * This methods handles the interaction with anything other then the players' lines (mostly the team part of the view)
		 * @param touch The touch object that happened
		 * @return A Boolean value, indicating if an action has been made, so no other check must be made with the current TouchEvent
		 * 
		 */
		private function handleTeamTouchInteraction(touch:Touch):Boolean
		{
			var doStopImmediatePropagation:Boolean = false;
			// to save some computational time, we set the currentTeamSprite in a variable
			var currentTeamSprite:Sprite = _teamsSpriteContainerList[_currentlyVisibleTeamId];
			
			// if we have a slot being currently dragged
			if (_draggedPlayerSlot.visible)
			{
				// the dragged slot follows the touch coordinates
				_draggedPlayerSlot.x = touch.globalX;
				_draggedPlayerSlot.y = touch.globalY;
			}
			
			// we get the index of the slot being interacted with
			var teamSlotIndex:int = getTeamPlayerSlotIndexAtPoint(new Point(touch.globalX, touch.globalY));
			// if there is a slot being interacted with and this is the start of the interaction and the slot was not empty ...
			if (touch.phase == TouchPhase.BEGAN && teamSlotIndex > -1 && _model.teams[_currentlyVisibleTeamId][teamSlotIndex] != null)
			{
				// ... we get the player from the model and set it to the draggedSlot
				_draggedPlayerSlot.playerProfile = _model.teams[_currentlyVisibleTeamId][teamSlotIndex];
				// we set the index of the slot over which the touch currently is to the interacted slot index
				_draggedOverTeamSlotIndex = teamSlotIndex;
				// we save the index the interacted slot
				_savedDraggedTeamSlotIndex = teamSlotIndex;
			}
			// if we are moving and there is a dragged slot ...
			else if (touch.phase == TouchPhase.MOVED && _draggedPlayerSlot.playerProfile != null)
			{
				// ... we show the dragged slot
				_draggedPlayerSlot.visible = true;
				// then we set the team slot from which we start the dragging as empty (since we are dragging the slot, the slot in the team must appear empty)
				setTeamSlot(_savedDraggedTeamSlotIndex, null);
				// if there is a slot at the touch coordinates ... 
				if (teamSlotIndex > -1)
				{
					// ... and if this slot is different from the one previously stated as the one hovered by the touch ...
					if (teamSlotIndex != _draggedOverTeamSlotIndex)
					{
						// ... and this previously hovered slot actually existed ...
						if (_draggedOverTeamSlotIndex > -1)
						{
							// ... then we display it again (because when we drag a slot over another, we hide the one below so that it doesn't appear behind the dragged one)
							currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
						}	
						// Now we change the index of the slot being replaced by the dragging slot 
						_draggedOverTeamSlotIndex = teamSlotIndex;
						// we hide the slot behind the dragged one, except if it is the same as the slot originating the drag
						currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = (_draggedOverTeamSlotIndex == _savedDraggedTeamSlotIndex);
					}
					// if the slot behind the dragged one is different from the one originating the dragging, we position the dragged one at the exact position of the hovered slot
					if (_draggedOverTeamSlotIndex != _savedDraggedTeamSlotIndex)
					{
						_draggedPlayerSlot.x = currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).x;
						_draggedPlayerSlot.y = currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).y;
					}
				}
				// if there is no slot at the touch coordinates ...
				else
				{
					// ... and if the dragged slot previously was over another slot (meaning that it is not anymore) ...
					if (_draggedOverTeamSlotIndex > -1)
					{
						// ... then we show the previouslt hovered slot
						currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
						// ... and reset the index of the hovered slot
						_draggedOverTeamSlotIndex = -1;
					}
				}
			}
			// if the touch interaction is ended, and we are dragging a slot and the dragged slot is above another existing slot
			else if (touch.phase == TouchPhase.ENDED && _draggedPlayerSlot.visible && _draggedOverTeamSlotIndex > -1)
			{
				// we definitely position the player in the dragged slot to the slot behind the released point
				setTeamSlot(_draggedOverTeamSlotIndex, _draggedPlayerSlot.playerProfile);
				// so we can hide the dragged slot (which is not useful anymore)
				_draggedPlayerSlot.visible = false;
				// we show the slot above which the dragged slot was positionned
				currentTeamSprite.getChildAt(_draggedOverTeamSlotIndex).visible = true;
				// we reset the saved index of the slot originiating the drag action
				_savedDraggedTeamSlotIndex = -1;
				doStopImmediatePropagation = true;
			}
			// otherwise, if the touch is ended somewhere where there is not slot
			else if (touch.phase == TouchPhase.ENDED)
			{
				// ... and we were dragging a slot
				if (_draggedPlayerSlot.visible)
				{
					// then we put the player in the dragged slot to its original slot
					setTeamSlot(_savedDraggedTeamSlotIndex, _draggedPlayerSlot.playerProfile);
				}
				// then we reset the draggedSlot
				_draggedPlayerSlot.playerProfile = null;
				// and hide it
				_draggedPlayerSlot.visible = false;
				// we reset the saved index of the slot originiating the drag action
				_savedDraggedTeamSlotIndex = -1;
			}
			
			return doStopImmediatePropagation;
		}
		
		/**
		 * This method sets a playerprofile to a given team slot (represented by its index)
		 * @param teamSlotIndex The index of the team slot to update
		 * @param playerProfile The playerProfile to piut in the given slot (if it null, it means that the slot is emptied)
		 * 
		 */
		private function setTeamSlot(teamSlotIndex:int, playerProfile:TeamBuildingViewUser):void
		{
			// first if we were dragging a player, we put the player in the target slot to the dragged player original position (i.e. we swap the two players, including the fact that the slots may be empty)
			if (_savedDraggedTeamSlotIndex > -1)
			{
				_model.setTeamPlayer(_currentlyVisibleTeamId, _savedDraggedTeamSlotIndex, _model.teams[_currentlyVisibleTeamId][teamSlotIndex]);
			}
			// then we set the new playerProfile to the given slot index
			_model.setTeamPlayer(_currentlyVisibleTeamId, teamSlotIndex, playerProfile);
		}
		
		/**
		 * This method returns the index of the player in the team, based on screen coordinates
		 * @param point The point from which we want to get the corresponding slot
		 * @return An index in the current team's players list
		 * 
		 */
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
		
		/**
		 * The save button has been interacted
		 * @param e The Touchevent triggered
		 * 
		 */
		private function onSaveButtonTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_saveButton);
			// if there really is an interaction with the saveButton and the touch is in ended phase
			if (touch != null && touch.phase == TouchPhase.ENDED)
			{
				// then we inform the controller that we want to save the team
				_controller.onTeamUpdated(_model.teams);
				// then we disable the interactivity of the button
				setSaveButtonInteractivity(false);
			}
		}
	}
}