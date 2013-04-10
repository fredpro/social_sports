package models.vo
{
	public class PlayerVO extends UserVO
	{
		/**
		 * The list of attributes of the player (the order is important as each index is associated to a specific attribute)
		 */
		public var attributes:Vector.<int>;
		
		public function PlayerVO(data:Object)
		{
			super(data.people);
			attributes = Vector.<int>(data.attributes);
		}
	}
}