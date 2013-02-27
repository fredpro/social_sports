package
{
    import starling.display.Sprite;
    import starling.events.Event;
    
    public class MainStarlingContainer extends Sprite
    {
        public function MainStarlingContainer()
        {
            super();
            
            addEventListener(Event.ADDED_TO_STAGE, onAdded);            
        }
        
        
        private function onAdded(e:Event):void
        {
            new MainController(this);
        }
    }
}