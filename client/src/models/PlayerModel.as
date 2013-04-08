package models
{
	import models.vo.PlayerVO;

	public class PlayerModel extends UserModel
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _facebookId:String;
		
		private var _nickname:String;
		
		private var _level:int;
		
		private var _attributes:Vector.<int>;
		
		public function PlayerModel()
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
		 * The nickname of the manager (given by himself)
		 */
		public function get nickname():String
		{
			return _nickname;
		}
		
		/**
		 * The level of the manager
		 */
		public function get level():int
		{
			return _level;
		}
		
		/**
		 * The list of attributes of the player (the order is important as each index is associated to a specific attribute)
		 */
		public function get attributes():Vector.<int>
		{
			return _attributes;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		
		/**
		 * Update The current model from a VO object comming from the server
		 * @param vo the PlayerVO which comes from the server (or has been created from a JSON object)
		 * 
		 */
		public function update(vo:PlayerVO):void
		{
			_facebookId = vo.facebookId;
			_nickname = vo.nickname;
			_level = vo.level;
			_attributes = vo.attributes;
		}


	}
}