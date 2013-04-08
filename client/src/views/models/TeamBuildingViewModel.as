package views.models
{
	import com.mxp4.app.starling.MasterClass;
	
	public class TeamBuildingViewModel extends MasterClass
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _unlockedPlayers:Vector.<TeamBuildingViewPlayer>;
		private var _lockedPlayers:Vector.<TeamBuildingViewPlayer>;
		private var _teams:Vector.<Vector.<TeamBuildingViewPlayer>>;
		
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
		public function get unlockedPlayers():Vector.<TeamBuildingViewPlayer>
		{
			return _unlockedPlayers;
		}

		/**
		 * @private
		 */
		public function set unlockedPlayers(value:Vector.<TeamBuildingViewPlayer>):void
		{
			_unlockedPlayers = value;
		}

		/**
		 * The list of locked players that the manager can add to his teams. The players are instances of TeamBuildingViewPlayer.
		 */
		public function get lockedPlayers():Vector.<TeamBuildingViewPlayer>
		{
			return _lockedPlayers;
		}

		/**
		 * @private
		 */
		public function set lockedPlayers(value:Vector.<TeamBuildingViewPlayer>):void
		{
			_lockedPlayers = value;
		}

		/**
		 * The list of teams belonging to the manager. Each team is a list of TeamBuildingViewPlayer (which are the same instances from the _unlockedPlayers and _lockedPlayers variables).
		 */
		public function get teams():Vector.<Vector.<TeamBuildingViewPlayer>>
		{
			return _teams;
		}

		/**
		 * @private
		 */
		public function set teams(value:Vector.<Vector.<TeamBuildingViewPlayer>>):void
		{
			_teams = value;
		}
	}
}

/**
 * Internal class used to store only useful data copied from PlayerModel's instances
 * @author Fred
 * 
 */
class TeamBuildingViewPlayer
{
	private var _facebookId:String;
	private var _name:String;
	private var _nickname:String;
	private var _level:int;
	private var _pictureUrl:String;
	
	public function TeamBuildingViewPlayer(facebookId:String, name:String, nickname:String, level:int, pictureUrl:String):void
	{
		_facebookId = facebookId;
		_name = name;
		_nickname = nickname;
		_level = level;
		_pictureUrl = pictureUrl;
	}

	public function get facebookId():String
	{
		return _facebookId;
	}

	public function get name():String
	{
		return _name;
	}

	public function get nickname():String
	{
		return _nickname;
	}

	public function get level():int
	{
		return _level;
	}

	public function get pictureUrl():String
	{
		return _pictureUrl;
	}
}