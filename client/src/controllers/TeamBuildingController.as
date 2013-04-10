package controllers
{
	import views.TeamBuildingView;
	import views.models.TeamBuildingViewModel;

	public class TeamBuildingController extends AbstractViewController
	{
		//--------------------------------------------
		// VARIABLES
		//--------------------------------------------
		private var _teamBuildingView:TeamBuildingView;
		
		public function TeamBuildingController(main:MainController)
		{
			super(main);
			_teamBuildingView = new TeamBuildingView(this);
		}
		
		//--------------------------------------------
		// PUBLIC METHODS
		//--------------------------------------------
		public function initView(model:TeamBuildingViewModel):void
		{
			_teamBuildingView.initView(model);
		}
	}
}