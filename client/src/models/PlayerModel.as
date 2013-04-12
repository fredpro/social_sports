package models
{
	import models.vo.PlayerVO;
	import models.vo.UserVO;

	public class PlayerModel extends UserModel
	{
		//------------------
		// CONSTANTS
		//------------------
		
		//------------------
		// VARIABLES
		//------------------
		private var _attributes:Vector.<int>;
		
		public function PlayerModel()
		{
			super();
		}
		
		//------------------
		// GETTERS AND SETTERS
		//------------------
		
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
		override public function update(uservo:UserVO):void
		{
			super.update(uservo);
			
			var vo:PlayerVO = uservo as PlayerVO;
			_attributes = vo.attributes;
		}


		public function replaceVariableInText(variableInText:String):String
		{
			var result:String = "";
			
			switch (variableInText)
			{
				case "NAME":
					result = _name;
					break;
			}
			
			return result;
		}
	}
}