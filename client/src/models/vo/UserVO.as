package models.vo
{
	public class UserVO
	{
		/**
		 * The facebook id of the manager
		 */
		public var facebookId:String;
		
		/**
		 * The name of the manager (from his facebook profile)
		 */
		public var name:String;
		
		/**
		 * The nickname of the manager (given by himself)
		 */
		public var nickname:String;
		
		/**
		 * The url of the manager's facebook picture
		 */
		public var pictureUrl:String;
		
		/**
		 * The level of the manager
		 */
		public var level:int;
		
		public function UserVO(data:Object)
		{
			facebookId = data.facebook_id;
			name = data.name;
			nickname = data.nickname;
			pictureUrl = data.picture_url;
			level = data.level;
		}
	}
}