package
{
	import com.fourcade.resourcesManager.ResourcesManager;
	
	import enums.Constants;
	
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	import starling.core.Starling;
	
	[SWF(frameRate="60", width="760", height="600")]
	
	public class SocialSports extends Sprite
	{
		//-----------------------------------------------
		// VARIABLES
		//-----------------------------------------------
		private var _starling:Starling;
		
		public function SocialSports()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			ResourcesManager.assetsListXmlPath = "./assets_list.xml";
			
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			// create our Starling instance 
			_starling = new Starling(MainStarlingContainer, stage);
			// set anti-aliasing (higher the better quality but slower performance) 
			_starling.antiAliasing = 1;
			// start it!
			_starling.start(); 
			
			_starling.showStats = Constants.DEBUG_MODE;
		}
	}
}