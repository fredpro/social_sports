package models
{
	import com.fourcade.app.starling.MasterClass;
	
	import enums.Constants;
	
	import models.vo.TeamVO;
	
	public class TeamModel extends MasterClass
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _sportId:int;
		
		private var _players:Vector.<PlayerModel>;
		
		private var _manager:ManagerModel;
		
		public function TeamModel()
		{
			super();
		}

		//------------------
		// GETTERS AND SETTERS
		//------------------
		public function get sportId():int
		{
			return _sportId;
		}

		public function get players():Vector.<PlayerModel>
		{
			return _players;
		}
		
		public function get manager():ManagerModel
		{
			return _manager;
		}
		
		public function set manager(value:ManagerModel):void
		{
			_manager = value;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		
		/**
		 * Update The current model from a VO object comming from the server
		 * @param vo the TeamVO which comes from the server (or has been created from a JSON object)
		 * 
		 */
		public function update(team:TeamVO):void
		{
			_sportId = team.sportId;
			
			_players = new Vector.<PlayerModel>(Constants.TEAM_SIZE[_sportId]);
			var l:int = Math.min(team.players.length, Constants.TEAM_SIZE[_sportId]);
			for (var i:int = 0; i < l; i++)
			{
				_players[i] = _manager.getUnlockedPlayerById(team.players[i]);
			}
			
			team.destroy();
		}
		
		/**
		 * Returns the list of the team's players as a String with the players' facebook ids seprated by ,
		 * @return String
		 * 
		 */
		public function exportPlayersListAsString():String
		{
			var l:int = _players.length;
			var list:Vector.<String> = new Vector.<String>(l);
			for (var i:int = 0; i < l; i++)
			{
				if (_players[i] != null)
				{
					list[i] = _players[i].facebookId;
				}
			}
			return list.join();
		}
		
		
		//------------------
		// PRIVATE METHODS
		//------------------
	}
}