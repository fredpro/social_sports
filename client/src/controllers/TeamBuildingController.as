package controllers
{
	import views.PlayerDetailsView;
	import views.TeamBuildingView;
	import views.models.TeamBuildingViewModel;

	public class TeamBuildingController extends AbstractViewController
	{
		//--------------------------------------------
		// VARIABLES
		//--------------------------------------------
		private var _teamBuildingView:TeamBuildingView;
		private var _playerDetailsView:PlayerDetailsView;
		
		public function TeamBuildingController(main:MainController)
		{
			super(main);
			_teamBuildingView = new TeamBuildingView(this);
		}
		
		//--------------------------------------------
		// PUBLIC METHODS
		//--------------------------------------------
		/**
		 * inits the view with the data given in the TeamBuildingViewModel
		 * @param model The TeamBuildingViewModel instance containing only the specific data needed in the view
		 * 
		 */
		public function initView(model:TeamBuildingViewModel):void
		{
			_teamBuildingView.initView(model);
		}
		
		/**
		 * A player line in the TeamBuildingView has been clicked. So we display the PlayerDetailView for the given player
		 * @param facebookId the facebook id of the player we want to display the stats
		 * 
		 */
		public function onPlayerLineClicked(facebookId:String):void
		{
			if (_playerDetailsView != null)
			{
				_playerDetailsView.destroyView();
			}
			_playerDetailsView = new PlayerDetailsView();
			_playerDetailsView.initView(_main.model.getPlayerDetails(facebookId));
		}
	}
}