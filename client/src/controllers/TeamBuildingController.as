package controllers
{
	import views.PlayerDetailsView;
	import views.TeamBuildingView;
	import views.models.TeamBuildingViewModel;
	import views.models.TeamBuildingViewUser;

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
		
		/**
		 * The team has been updated, so we must send the modification to the server
		 * @teamId the id of the team that has been updated
		 * @playersList the list of players of the corresponding team
		 * 
		 */
		public function onTeamUpdated(teamsList:Vector.<Vector.<TeamBuildingViewUser>>):void
		{
			var l:int = teamsList.length;
			var teams:Vector.<Vector.<String>> = new Vector.<Vector.<String>>(l);
			for (var i:int = 0; i < l; i++)
			{
				var players:Vector.<TeamBuildingViewUser> = teamsList[i];
				var tl:int = players.length;
				var team:Vector.<String> = new Vector.<String>(tl);
				teams[i] = team;
				for (var j:int = 0; j < tl; j++)
				{
					if (players[j] != null)
					{
						team[j] = players[j].facebookId;
					}
					else
					{
						team[j] = "";
					}
				}
			}
			_main.onTeamUpdated(teams);
		}
	}
}