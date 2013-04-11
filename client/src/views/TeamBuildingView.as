package views
{
	import com.fourcade.app.starling.mvc.AbstractView;
	import com.fourcade.resourcesManager.ResourcesManager;
	import com.fourcade.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	import views.models.TeamBuildingViewModel;
	import views.models.TeamBuildingViewUser;
	
	public class TeamBuildingView extends AbstractView
	{
		//-----------------------------------------------
		// CONSTANTS
		//-----------------------------------------------
		private static const PLAYER_LINE_TF_HEIGHT:int = 20;
		private static const PLAYER_LINE_X_OFFSET:int = 20;
		private static const PLAYER_LINE_Y_OFFSET:int = 50;
		private static const PLAYER_LINE_LEVEL_TF_X_OFFSET:int = 200;
		
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		private var _model:TeamBuildingViewModel;
		private var _playersContainer:Sprite;
		
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
			ResourcesManager.getInstance().loadResource(null, onResourcesLoaded);
		}
		
		private function onResourcesLoaded():void
		{
			_playersContainer = new Sprite();
			_playersContainer.y = PLAYER_LINE_Y_OFFSET;
			container.addChild(_playersContainer);
			
			var l:int = _model.unlockedPlayers.length;
			for (var i:int = 0; i < l; i++)
			{
				var playerLineSprite:Sprite = new Sprite();
				var player:TeamBuildingViewUser = _model.unlockedPlayers[i];
				var nameTF:TextField = new TextField(200, 20, player.name);
				nameTF.name = "name_tf";
				nameTF.color = 0x000000;
				nameTF.hAlign = "left";
				nameTF.vAlign = "bottom";
				playerLineSprite.addChild(nameTF);
				
				var levelTF:TextField = new TextField(50, 20, String(player.level));
				levelTF.hAlign = "left";
				levelTF.vAlign = "bottom";
				levelTF.x = PLAYER_LINE_LEVEL_TF_X_OFFSET;
				playerLineSprite.addChild(levelTF);
				
				playerLineSprite.x = PLAYER_LINE_X_OFFSET;
				playerLineSprite.y = i*PLAYER_LINE_TF_HEIGHT;
				_playersContainer.addChild(playerLineSprite);
				playerLineSprite.useHandCursor = true;
			}
			
			var nextPosY:int = playerLineSprite.y + PLAYER_LINE_TF_HEIGHT;
			
			l = _model.lockedPlayers.length;
			for (i = 0; i < l; i++)
			{
				playerLineSprite = new Sprite();
				player = _model.lockedPlayers[i];
				nameTF = new TextField(200, 20, player.name);
				nameTF.color = 0x666666;
				nameTF.hAlign = "left";
				nameTF.vAlign = "bottom";
				playerLineSprite.addChild(nameTF);
				
				levelTF = new TextField(50, 20, String(player.level));
				nameTF.color = 0x666666;
				levelTF.hAlign = "left";
				levelTF.vAlign = "bottom";
				levelTF.x = PLAYER_LINE_LEVEL_TF_X_OFFSET;
				playerLineSprite.addChild(levelTF);
				
				playerLineSprite.x = PLAYER_LINE_X_OFFSET;
				playerLineSprite.y = nextPosY + i*20;
				_playersContainer.addChild(playerLineSprite);
				playerLineSprite.useHandCursor = true;
			}
			
			_playersContainer.addEventListener(TouchEvent.TOUCH, onPlayerLineTouched);
		}
		
		private function onPlayerLineTouched(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(_playersContainer);
			if (touch != null && touch.phase == TouchPhase.ENDED)
			{
				var point:Point = touch.getLocation(_playersContainer);
				var index:int = Math.floor(point.y / PLAYER_LINE_TF_HEIGHT);
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