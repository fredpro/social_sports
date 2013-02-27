package controllers
{
    import com.mxp4.app.starling.interfaces.IViewController;
    import com.mxp4.app.starling.mvc.AbstractController;
    
    public class AbstractViewController extends AbstractController
    {
        protected var _main:MainController;
        
        public function AbstractViewController(main:MainController)
        {
            super();
            _main = main;
        }
        
        public function addLoadingAsset(nbAssets:int=1):void
        {
            _main.addLoadingAsset(nbAssets);
        }
        
        public function onLoadingProgress(percentage:Number):void
        {
            _main.onLoadingProgress(percentage);
        }
        
        public function onLoadingComplete():void
        {
            _main.onLoadingComplete();
        }
    }
}