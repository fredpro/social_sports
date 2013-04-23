package views.models
{
	import com.fourcade.app.starling.MasterClass;
	
	import models.ManagerModel;
	import models.PlayerModel;
	import models.UserModel;
	
	public class TeamBuildingViewModel extends MasterClass
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _unlockedPlayers:Vector.<TeamBuildingViewUser>;
		private var _lockedPlayers:Vector.<TeamBuildingViewUser>;
		private var _teams:Vector.<Vector.<TeamBuildingViewUser>>;
		private var _teamsId:Vector.<int>;
		
		public function TeamBuildingViewModel()
		{
			super();
		}

		//------------------
		// GETTERS AND SETTERS
		//------------------

		/**
		 * The list of unlocked players that the manager can add to his teams. The players are instances of TeamBuildingViewPlayer.
		 */
		public function get unlockedPlayers():Vector.<TeamBuildingViewUser>
		{
			return _unlockedPlayers;
		}

		/**
		 * The list of locked players that the manager can add to his teams. The players are instances of TeamBuildingViewPlayer.
		 */
		public function get lockedPlayers():Vector.<TeamBuildingViewUser>
		{
			return _lockedPlayers;
		}

		/**
		 * The list of teams belonging to the manager. Each team is a list of TeamBuildingViewPlayer (which are the same instances from the _unlockedPlayers and _lockedPlayers variables).
		 */
		public function get teams():Vector.<Vector.<TeamBuildingViewUser>>
		{
			return _teams;
		}
		
		/**
		 * The sport ids of the team displayed in the TeamBuildingView. It goes along with the _teams vector.
		 */
		public function get teamsId():Vector.<int>
		{
			return _teamsId;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		
		/**
		 * creates a TeamBuildingViewModel instance from data from a ManagerModel instance. Only useful data is copied in the TeamBuildingViewModel
		 * @return A TeamBuildingViewModel instance
		 * 
		 */
		public function exportFromManagerModel(manager:ManagerModel):TeamBuildingViewModel
		{
			var result:TeamBuildingViewModel = new TeamBuildingViewModel();
			
			var l:int = manager.unlockedPlayers.length;
			_unlockedPlayers = new Vector.<TeamBuildingViewUser>(l);
			for (var i:int = 0; i < l; i++)
			{
				var unlockedPlayer:PlayerModel = manager.unlockedPlayers[i];
				var user:TeamBuildingViewUser = new TeamBuildingViewUser(unlockedPlayer.facebookId, unlockedPlayer.name, unlockedPlayer.nickname, unlockedPlayer.level, unlockedPlayer.normalPictureUrl, unlockedPlayer.smallPictureUrl);
				_unlockedPlayers[i] = user;
			}
			
			l = manager.lockedPlayers.length;
			_lockedPlayers = new Vector.<TeamBuildingViewUser>(l);
			for (i = 0; i < l; i++)
			{
				var lockedUser:UserModel = manager.lockedPlayers[i];
				user = new TeamBuildingViewUser(lockedUser.facebookId, lockedUser.name, lockedUser.nickname, lockedUser.level, lockedUser.normalPictureUrl, lockedUser.smallPictureUrl);
				_lockedPlayers[i] = user;
			}
			
			l = manager.teams.length;
			_teams = new Vector.<Vector.<TeamBuildingViewUser>>(l);
			_teamsId = new Vector.<int>(l);
			for (i = 0; i < l; i++)
			{
				_teamsId[i] = manager.teams[i].sportId;
				
				var tl:int = manager.teams[i].players.length;
				_teams[i] = new Vector.<TeamBuildingViewUser>(tl);
				for (var j:int = 0; j < tl; j++)
				{
					if (manager.teams[i].players[j] != null)
					{
						_teams[i][j] = getUnlockedPlayerFromId(manager.teams[i].players[j].facebookId);
					}
				}
			}
			
			return result;
		}
		
		//----------------------------------------
		// PRIVATE METHODS
		//----------------------------------------
		
		private function getUnlockedPlayerFromId(id:String):TeamBuildingViewUser
		{
			var result:TeamBuildingViewUser = null;
			
			var l:int = _unlockedPlayers.length;
			for (var i:int = 0; (i < l && result == null); i++)
			{
				var user:TeamBuildingViewUser = _unlockedPlayers[i];
				if (user.facebookId == id)
				{
					result = user;
				}
			}
			
			return result;
		}
	}
}