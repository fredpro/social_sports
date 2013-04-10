package views.models
{
		
	/**
	 * class used to store only useful data copied from PlayerModel's instances
	 * @author Fred
	 * 
	 */
	public class TeamBuildingViewUser
	{
		private var _facebookId:String;
		private var _name:String;
		private var _nickname:String;
		private var _level:int;
		private var _pictureUrl:String;
		
		public function TeamBuildingViewUser(facebookId:String, name:String, nickname:String, level:int, pictureUrl:String):void
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
}