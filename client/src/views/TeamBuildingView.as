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
	import starling.text.TextField;
	
	import views.models.TeamBuildingViewModel;
	import views.models.TeamBuildingViewUser;
	
	public class TeamBuildingView extends AbstractView
	{
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		private var _model:TeamBuildingViewModel;
		
		public function TeamBuildingView(controller:TeamBuildingController)
		{
			super();
			_controller = controller;
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
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
			var l:int = _model.unlockedPlayers.length;
			for (var i:int = 0; i < l; i++)
			{
				var player:TeamBuildingViewUser = _model.unlockedPlayers[i];
				var nameTF:TextField = new TextField(200, 20, player.name);
				nameTF.color = 0x000000;
				nameTF.hAlign = "left";
				nameTF.vAlign = "bottom";
				nameTF.x = 20;
				nameTF.y = 50 + i*(nameTF.height);
				container.addChild(nameTF);
				
				var levelTF:TextField = new TextField(50, 20, String(player.level));
				levelTF.hAlign = "left";
				levelTF.vAlign = "bottom";
				levelTF.x = 240;
				levelTF.y = 50 + i*(levelTF.height);
				container.addChild(levelTF);
			}
			
			var nextPosY:int = levelTF.y + levelTF.height;
			
			l = _model.lockedPlayers.length;
			for (i = 0; i < l; i++)
			{
				player = _model.lockedPlayers[i];
				nameTF = new TextField(200, 20, player.name);
				nameTF.color = 0x666666;
				nameTF.hAlign = "left";
				nameTF.vAlign = "bottom";
				nameTF.x = 20;
				nameTF.y = nextPosY + i*(nameTF.height);
				container.addChild(nameTF);
				
				levelTF = new TextField(50, 20, String(player.level));
				nameTF.color = 0x666666;
				levelTF.hAlign = "left";
				levelTF.vAlign = "bottom";
				levelTF.x = 240;
				levelTF.y = nextPosY + i*(levelTF.height);
				container.addChild(levelTF);
			}
		}
	}
}