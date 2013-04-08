package models.vo
{
	public class PlayerVO
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
		 * The level of the manager
		 */
		public var level:int;
		
		/**
		 * The list of attributes of the player (the order is important as each index is associated to a specific attribute)
		 */
		public var attributes:Vector.<int>;
		
		public function PlayerVO(data:Object)
		{
			facebookId = data.facebookId;
			nickname = data.people.nickname;
			level = data.level;
			attributes = Vector.<int>(data.attributes);
		}
	}
}