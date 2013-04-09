package models.vo
{
	public class ManagerVO
	{
		/**
		 * The facebook id of the manager
		 */
		public var facebookId:String;
		
		/**
		 * The nickname of the manager (given by himself)
		 */
		public var nickname:String;
		
		/**
		 * The XP of the manager
		 */
		public var xp:int;
		
		/**
		 * The level of the manager
		 */
		public var level:int;
		
		/**
		 * The number of coins of the manager
		 */
		public var coins:int;
		
		/**
		 * The percentage of progress of the next player unlocking (when it reaches 100, then the next player is unlocked)
		 */
		public var unlockingProgress:int;
		
		/**
		 * The ordered list of players still to be unlocked (in the same order that they are supposed to be unlocked)
		 */
		public var lockedPlayers:Vector.<PlayerVO>;
		
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
			facebookId = data.facebookId;
			nickname = data.nickname;
			xp = data.xp;
			level = data.level;
			coins = data.coins;
			
			var l:int = data.lockedPlayers.length;
			lockedPlayers = new Vector.<PlayerVO>(l);
			for (var i:int = 0; i < l; i++)
			{
				var player:PlayerVO = new PlayerVO(data.lockedPlayers[i]);
				lockedPlayers[i] = player;
			}
			
			l = data.unlockedPlayers.length;
			unlockedPlayers = new Vector.<PlayerVO>(l);
			for (i = 0; i < l; i++)
			{
				player = new PlayerVO(data.unlockedPlayers[i]);
				unlockedPlayers[i] = player;
			}
			
			unlockingProgress = data.unlockingProgress;
			
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