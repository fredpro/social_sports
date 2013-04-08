package
{
	import com.mxp4.app.starling.MasterClass;
	
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
		private var _user:ManagerModel;
		
		public function MainModel()
		{
			super();
			_user = new ManagerModel();
		}		
		
		//------------------
		// GETTERS AND SETTERS
		//------------------
		public function get user():ManagerModel
		{
			return _user;
		}
		
		//------------------
		// PUBLIC METHODS
		//------------------
		public function updateUser(data:ManagerVO):void
		{
			_user.update(data);
		}
		
		/**
		 * returns a TeamBuildingViewModel to be used in the TeamBuildingView
		 * @return A TeamBuildingViewModel instance created from data from ManagerModel
		 * 
		 */
		public function createTeamBuildingViewModel():views.models.TeamBuildingViewModel
		{
			var result:TeamBuildingViewModel = _user.exportTeamBuildingViewModel();
			
			result.
			
			return result;
		}
		
		//------------------
		// PRIVATE METHODS
		//------------------
	}
}