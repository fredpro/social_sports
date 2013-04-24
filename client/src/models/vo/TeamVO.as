package models.vo
{
	import enums.Constants;

	public class TeamVO
	{
		/**
		 * The id of the sport represented by this team
		 */
		public var sportId:int;
		
		/**
		 * The list of players' facebook id which are currently in the team. The players shall be found in the manager's unlockedPlayers list
		 */
		public var players:Vector.<String>;
		
		public function TeamVO(data:Object)
		{
			sportId = data.sport_id;
			var l:int = data.players.length;
			players = new Vector.<String>(l);
			for (var i:int = 0; i < l; i++)
			{
				players[i] = data.players[i];
			}
		}
		
		public function destroy():void
		{
			var l:int = players.length;
			for (var i:int = 0; i < l; i++)
			{
				players[i] = null;
			}
			players = null;
		}
	}
}