package controllers
{
	import views.TeamBuildingView;

	public class TeamBuildingController extends AbstractViewController
	{
		//--------------------------------------------
		// VARIABLES
		//--------------------------------------------
		private var _teamBuildingView:TeamBuildingView;
		
		public function TeamBuildingController(main:MainController)
		{
			super(main);
			_teamBuildingView= new TeamBuildingView(this);
			_teamBuildingView.initView();
		}
	}
}