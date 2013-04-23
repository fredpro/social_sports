package models
{
	import com.fourcade.app.starling.MasterClass;
	
	import models.vo.UserVO;
	
	public class UserModel extends MasterClass
	{
		//------------------
		// CONSTANTS
		//------------------
		public static const LARGE_PICTURE_SIZE:int = 150;
		public static const NORMAL_PICTURE_SIZE:int = 80;
		public static const SMALL_PICTURE_SIZE:int = 20;
		
		//------------------
		// VARIABLES
		//------------------
		protected var _facebookId:String;
		
		protected var _name:String;
		
		protected var _nickname:String;
				
		protected var _largePictureUrl:String;
		protected var _normalPictureUrl:String;
		protected var _smallPictureUrl:String;
		
		protected var _level:int;
		
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
		 * The url of the manager's facebook large picture
		 */
		public function get largePictureUrl():String
		{
			return _largePictureUrl;
		}
		
		/**
		 * The url of the manager's facebook normal picture
		 */
		public function get normalPictureUrl():String
		{
			return _normalPictureUrl;
		}
		
		/**
		 * The url of the manager's facebook small picture
		 */
		public function get smallPictureUrl():String
		{
			return _smallPictureUrl;
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
			//_pictureUrl = vo.pictureUrl;
			_largePictureUrl = "https://graph.facebook.com/" + _facebookId + "/picture?width=" + LARGE_PICTURE_SIZE + "&height=" + LARGE_PICTURE_SIZE;
			_normalPictureUrl = "https://graph.facebook.com/" + _facebookId + "/picture?width=" + NORMAL_PICTURE_SIZE + "&height=" + NORMAL_PICTURE_SIZE;
			_smallPictureUrl = "https://graph.facebook.com/" + _facebookId + "/picture?width=" + SMALL_PICTURE_SIZE + "&height=" + SMALL_PICTURE_SIZE;
			_level = vo.level;				
		}
		
		
	}
}