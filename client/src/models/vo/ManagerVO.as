package models.vo
{
	public class ManagerVO extends UserVO
	{		
		/**
		 * The XP of the manager
		 */
		public var xp:int;
		
		/**
		 * The number of coins of the manager
		 */
		public var coins:int;
		
		/**
		 * The percentage of progress of the next player unlocking (when it reaches 100, then the next player is unlocked)
		 */
		public var unlockingProgress:int;
		
		/**
		 * The ordered list of players still to be unlocked (in the same order that they are supposed to be unlocked). These are only users as their attributes must not be sent to the client to avoid 'hacking'
		 */
		public var lockedPlayers:Vector.<UserVO>;
		
		/**
		 * The list of players unlocked, and thus available to add to any team
		 */
		public var unlockedPlayers:Vector.<PlayerVO>;
		
		/**
		 * The list of teams of the manager
		 */
		public var teams:Vector.<TeamVO>;
		
		public function ManagerVO(data:Object)
		{
			super(data.people);
			
			xp = data.xp;
			coins = data.coins;			
			unlockingProgress = data.unlocking_progress;
			
			var l:int = data.locked_players.length;
			lockedPlayers = new Vector.<UserVO>(l);
			for (var i:int = 0; i < l; i++)
			{
				var user:UserVO = new UserVO(data.locked_players[i].people);
				lockedPlayers[i] = user;
			}
			
			l = data.unlocked_players.length;
			unlockedPlayers = new Vector.<PlayerVO>(l);
			for (i = 0; i < l; i++)
			{
				var player:PlayerVO = new PlayerVO(data.unlocked_players[i]);
				unlockedPlayers[i] = player;
			}
			
			l = data.teams.length;
			teams = new Vector.<TeamVO>(l);
			for (i = 0; i < l; i++)
			{
				var team:TeamVO = new TeamVO(data.teams[i]);
				teams[i] = team;
			}
		}
	}
}