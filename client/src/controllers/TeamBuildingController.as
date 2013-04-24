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
			_playerDetailsView = new PlayerDetailsView(this);
			_playerDetailsView.initView();
			_playerDetailsView.hide();
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
		 * A player line, corresponding to an unlocked player, in the TeamBuildingView has been clicked. So we display the PlayerDetailView for the given player
		 * @param facebookId the facebook id of the player we want to display the stats
		 * 
		 */
		public function onUnlockedPlayerLineClicked(facebookId:String):void
		{
			_playerDetailsView.update(_main.model.getPlayerDetails(facebookId));
			_playerDetailsView.show();
		}
		
		/**
		 * A player line, corresponding to a locked player, in the TeamBuildingView has been clicked.
		 * @param facebookId the facebook id of the player
		 * 
		 */
		public function onLockedPlayerLineClicked(facebookId:String):void
		{
			// #TODO : do something with locked player's line
		}
		
		/**
		 * The player details view has been closed
		 * 
		 */
		public function onClosePlayerDetails():void
		{
			_playerDetailsView.hide();
		}
	}
}