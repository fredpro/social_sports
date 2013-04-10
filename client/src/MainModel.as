package
{
	import com.fourcade.app.starling.MasterClass;
	
	import models.ManagerModel;
	import models.vo.ManagerVO;
	
	import views.models.TeamBuildingViewModel;
	
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
		
		//------------------
		// PRIVATE METHODS
		//------------------
	}
}