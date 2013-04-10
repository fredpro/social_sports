package models
{
	import com.fourcade.app.starling.MasterClass;
	
	import models.vo.UserVO;
	
	public class UserModel extends MasterClass
	{
		//------------------
		// VARIABLES
		//------------------
		private var _facebookId:String;
		
		private var _name:String;
		
		private var _nickname:String;
		
		private var _pictureUrl:String;
		
		private var _level:int;
		
		public function UserModel()
		{
			super();
		}
		
		//------------------
		// GETTERS AND SETTERS
		//------------------
		
		/**
		 * The facebook id of the manager
		 */
		public function get facebookId():String
		{
			return _facebookId;
		}
		
		/**
		 * The name of the manager (from his facebook profile)
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * The nickname of the manager (given by himself)
		 */
		public function get nickname():String
		{
			return _nickname;
		}
		
		/**
		 * The url of the manager's facebook picture
		 */
		public function get pictureUrl():String
		{
			return _pictureUrl;
		}
		
		/**
		 * The level of the manager
		 */
		public function get level():int
		{
			return _level;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		
		/**
		 * Update The current model from a VO object coming from the server
		 * @param vo the UserVO which comes from the server (or has been created from a JSON object)
		 * 
		 */
		public function update(vo:UserVO):void
		{
			_facebookId = vo.facebookId;
			_name = vo.name;
			_nickname = vo.nickname;
			_pictureUrl = vo.pictureUrl;
			_level = vo.level;				
		}
		
		
	}
}