package models.vo
{
	public class PlayerVO
	{
		/**
		 * The facebook id of the player
		 */
		public var facebookId:String;
		
		/**
		 * The name of the player
		 */
		public var name:String;
		
		/**
		 * The nickname of the player
		 */
		public var nickname:String;
		
		/**
		 * The url of the facebook avatar of the player
		 */
		public var pictureUrl:String
		
		/**
		 * The level of the player
		 */
		public var level:int;
		
		/**
		 * The list of attributes of the player (the order is important as each index is associated to a specific attribute)
		 */
		public var attributes:Vector.<int>;
		
		public function PlayerVO(data:Object)
		{
			facebookId = data.facebookId;
			name = data.people.name;
			nickname = data.people.nickname;
			pictureUrl = data.people.pictureUrl;
			level = data.level;
			attributes = Vector.<int>(data.attributes);
		}
	}
}