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
			
			var pos:int = variableInText.lastIndexOf("_");
			if (pos > -1)
			{
				var id:int = parseInt(variableInText.substring(pos+1));
				if (!isNaN(id))
				{
					variableInText = variableInText.substring(0, pos);
				}
			}
			
			switch (variableInText)
			{
				case "NAME":
					result = _name;
					break;
				case "AGE":
					// #TODO : add age to UserModel
					//result = _age;
					break;
				case "GENDER":
					// #TODO : add gender to UserModel
					//result = _gender;
					break;
				case "LEVEL":
					result = String(_level);
					break;
				case "PHYSICAL_VALUES":
					if (!isNaN(id))
					{
						result = String(_attributes[id-1]);
					}
					else
					{
						throw ("Error when accessing text variable " + variableInText + ". The id (number after last _) should be a number !");
					}
					break;
				case "MENTAL_VALUES":
					if (!isNaN(id))
					{
						result = String(_attributes[10 + id - 1]);
					}
					else
					{
						throw ("Error when accessing text variable " + variableInText + ". The id (number after last _) should be a number !");
					}
					break;
					break;
			}
			
			return result;
		}
	}
}