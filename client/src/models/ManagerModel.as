package models
{	
	import models.vo.ManagerVO;
	
	import views.models.TeamBuildingViewModel;

	public class ManagerModel extends UserModel
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _facebookId:String;
		
		private var _nickname:String;
		
		private var _xp:int;
		
		private var _level:int;
		
		private var _coins:int;
		
		private var _lockedPlayers:Vector.<PlayerModel>;
		
		private var _unlockedPlayers:Vector.<PlayerModel>;
		
		private var _unlockingProgress:int;
		
		private var _teams:Vector.<TeamModel>;
		
		public function ManagerModel()
		{
			super();
		}
		
		//------------------
		// GETTERS AND SETTERS
		//------------------

		/**
		 * The facebook id of the manager
		 */
		public function get facebookId():String
		{
			return _facebookId;
		}

		/**
		 * The nickname of the manager (given by himself)
		 */
		public function get nickname():String
		{
			return _nickname;
		}

		/**
		 * The XP of the manager
		 */
		public function get xp():int
		{
			return _xp;
		}

		/**
		 * The level of the manager
		 */
		public function get level():int
		{
			return _level;
		}

		/**
		 * The number of coins of the manager
		 */
		public function get coins():int
		{
			return _coins;
		}

		/**
		 * The ordered list of players still to be unlocked (in the same order that they are supposed to be unlocked)
		 */
		public function get lockedPlayers():Vector.<PlayerModel>
		{
			return _lockedPlayers;
		}

		/**
		 * The list of players unlocked, and thus available to add to any team
		 */
		public function get unlockedPlayers():Vector.<PlayerModel>
		{
			return _unlockedPlayers;
		}

		/**
		 * The percentage of progress of the next player unlocking (when it reaches 100, then the next player is unlocked)
		 */
		public function get unlockingProgress():int
		{
			return _unlockingProgress;
		}

		/**
		 * The list of teams of the manager
		 */
		public function get teams():Vector.<TeamModel>
		{
			return _teams;
		}

		
		//------------------
		// PUBLIC METHODS
		//------------------
	
		/**
		 * Update The current model from a VO object coming from the server
		 * @param vo the ManagerVO which comes from the server (or has been created from a JSON object)
		 * 
		 */
		public function update(vo:ManagerVO):void
		{
			_facebookId = vo.facebookId;
			_nickname = vo.nickname;
			_xp = vo.xp;
			_level = vo.level;
			_coins = vo.coins;
			_unlockingProgress = vo.unlockingProgress;
			
			// #TODO : find the best solution to reuse existing PlayerModel, and use same reference for several Managers
			var l:int = vo.lockedPlayers.length;
			_lockedPlayers = new Vector.<PlayerModel>(l);
			for (var i:int = 0; i < l; i++)
			{
				var player:PlayerModel = new PlayerModel();
				player.update(vo.lockedPlayers[i]);
				_lockedPlayers[i] = player;
			}
			
			l = vo.unlockedPlayers.length;
			_unlockedPlayers = new Vector.<PlayerModel>(l);
			for (i = 0; i < l; i++)
			{
				player = new PlayerModel();
				player.update(vo.unlockedPlayers[i]);
				_unlockedPlayers[i] = player;
			}
			
			l = vo.teams.length;
			_teams = new Vector.<TeamModel>(l);
			for (i = 0; i < l; i++)
			{
				var team:TeamModel = new TeamModel();
				team.manager = this;
				team.update(vo.teams[i]);
				_teams[i] = team;
			}
		}
		
		/**
		 * Returns a player from the unlocked list of players with the given facebook id
		 * @param id The facebook id of the player we want to get 
		 * @return A PlayerModel instance
		 * 
		 */
		public function getUnlockedPlayerById(id:String):PlayerModel
		{
			var result:PlayerModel = null;
			
			for (var i:int = 0; (i <_unlockedPlayers.length && result == null); i++)
			{
				if (_unlockedPlayers[i].facebookId == id)
				{
					result = _unlockedPlayers[i];
				}
			}
			
			return result;
		}
		
		//------------------
		// PRIVATE METHODS
		//------------------
	}
}