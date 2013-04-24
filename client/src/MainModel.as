package
{
	import com.fourcade.app.starling.MasterClass;
	
	import models.ManagerModel;
	import models.vo.ManagerVO;
	
	import views.models.TeamBuildingViewModel;
	import models.PlayerModel;
	
	/**
	* @author Fred
	*/
	public class MainModel extends MasterClass
	{
		//------------------
		// CONSTANTS
		//------------------
				
		//------------------
		// VARIABLES
		//------------------
		private var _manager:ManagerModel;
		
		public function MainModel()
		{
			super();
			_manager = new ManagerModel();
		}		
		
		//------------------
		// GETTERS AND SETTERS
		//------------------
		public function get manager():ManagerModel
		{
			return _manager;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		public function updateManager(data:ManagerVO):void
		{
			_manager.update(data);
		}
		
		/**
		 * returns a TeamBuildingViewModel to be used in the TeamBuildingView
		 * @return A TeamBuildingViewModel instance created from data from ManagerModel
		 * 
		 */
		public function createTeamBuildingViewModel():views.models.TeamBuildingViewModel
		{
			var result:TeamBuildingViewModel = new TeamBuildingViewModel();
			
			result.exportFromManagerModel(_manager);
			
			return result;
		}
		
		/**
		 * returns the player model instance whose details are to be displayed in the PlayerDetailView.
		 * @param facebookId the id of the player to be displayed
		 * @return A PlayerModel instance
		 * 
		 */
		public function getPlayerDetails(facebookId:String):PlayerModel
		{
			var result:PlayerModel = _manager.getUnlockedPlayerById(facebookId);
			
			return result;
		}
		
		/**
		 * updates the given team of the current user
		 * @param teamId the id of the team to update
		 * @param team The new composition of the team (a list of facebookIds) 
		 * 
		 */
		public function updateUserTeam(teamId:int, team:Vector.<String>):void
		{
			_manager.updateTeam(teamId, team);
		}
		
		//------------------
		// PRIVATE METHODS
		//------------------
	}
}