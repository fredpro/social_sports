package views
{
	import com.mxp4.app.starling.mvc.AbstractView;
	import com.mxp4.resourcesManager.ResourcesManager;
	import com.mxp4.utils.TextureManager;
	
	import controllers.TeamBuildingController;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	
	public class TeamBuildingView extends AbstractView
	{
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _controller:TeamBuildingController;
		
		public function TeamBuildingView(controller:TeamBuildingController)
		{
			super();
			_controller = controller;
		}
		
		//-----------------------------------------------
		// PUBLIC METHODS
		//-----------------------------------------------
		
		public function initView():void
		{
			var bd:BitmapData = new BitmapData(Starling.current.nativeStage.stageWidth, Starling.current.nativeStage.stageHeight, true, 0xFF880000);
			var bg:Sprite = new Sprite(); 
			bg.addChild(new Image(TextureManager.instance.textureFromBitmap("bg", new Bitmap(bd))));
			container.addChild(bg);
			
			var tf:TextField = new TextField(200, 200, "");
			tf.x = 200;
			tf.y = 200;
			tf.text = "hello stage : " + Starling.current.nativeStage.stageWidth + " " + Starling.current.nativeStage.stageHeight;
			container.addChild(tf);
		}
	}
}