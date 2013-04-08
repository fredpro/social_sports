package models.vo
{
	import enums.Constants;

	public class TeamVO
	{
		public var sportId:int;
		
		public var players:Vector.<String>;
		
		public function TeamVO(data:Object)
		{
			sportId = data.sportId;
			var l:int = Constants.TEAM_SIZE[sportId];
			players = new Vector.<String>(l);
			for (var i:int = 0; i < l; i++)
			{
				players[i] = data["playerId_" + (i+1)];
			}
		}
	}
}