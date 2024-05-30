import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

stop();

plans_crud_back_btn.addEventListener(MouseEvent.CLICK, return_to_title);

var chosenMap: String = "0";
var mapCount: int = 0;
plans_files_count.text = String(mapCount) + "/12";
var allPlans: Array = new Array();
var itemsInstantiated: Boolean = false;
var allMCs: Array = new Array();
plan_pick_status.text = "Click on a plan to access it, or [-] to delete it.";

function loadPlans(){
    var directory:File = File.documentsDirectory.resolvePath("upRail/plans");

    if (directory.exists && directory.isDirectory) {
        var filesList: Array = directory.getDirectoryListing();
        
		mapCount = filesList.length;
        for (var i: int = 0; i < filesList.length; i++) {
            var file:File = filesList[i];
			if (!file.isDirectory){
				var thisFileName:String = String(file.name);
				if (thisFileName.slice(-6) == ".upmap"){
					allPlans.push(thisFileName.slice(0, -6));
				}
			}
        }
    }
}

new_plan_btn.addEventListener(MouseEvent.CLICK, go_to_new_plan);
function go_to_new_plan(event: MouseEvent){
	if (mapCount >= 12){
		plan_pick_status.text = "Map Storage Full";
	}
	chosenMap = "0";
	gotoAndStop(6);
}

function clearThePlanList(){
	for (var i: int = 0; i < allMCs.length; i++){
		plans_holder.removeChild(allMCs[i]);
	}
	allMCs = [];
}

function updatePlansList(){
	loadPlans();
	clearThePlanList();
	if (mapCount == 0){
		plan_pick_status.text = "No Maps Created Yet";
	}
	plans_files_count.text = String(mapCount) + "/12";
	for (var newPlanItem: int = 0; newPlanItem < mapCount; newPlanItem++){
		var toPutMC = new plan_pick_element;
		plans_holder.addChild(toPutMC);
		allMCs.push(toPutMC);
		toPutMC.x = 960;
		toPutMC.y = 220 + (newPlanItem * 60);
		toPutMC.buttonMode = true;
		toPutMC.useHandCursor = true;
		toPutMC.index = newPlanItem;
		if (toPutMC.map_element_title.text != null){
			toPutMC.map_element_title.text = allPlans[newPlanItem];
		}
		var toPutBtn = new btn_minus_square;
		plans_holder.addChild(toPutBtn);
		allMCs.push(toPutBtn);
		toPutBtn.x = 1830;
		toPutBtn.y = 220 + (newPlanItem * 60);
		toPutBtn.index = newPlanItem;
	
		toPutMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMC);
		toPutMC.addEventListener(MouseEvent.CLICK, onClickMC);

		toPutBtn.addEventListener(MouseEvent.CLICK, onClickBtn);
		
		function onMouseOverMC(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(2);
		}
		function onMouseOutMC(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(1);
		}
		function onMouseDownMC(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(3);
		}
		function onClickMC(event: MouseEvent): void {
			chosenMap = allPlans[event.currentTarget.index];
			gotoAndStop(6);
		}
		function onClickBtn(event: MouseEvent): void {
			var fileToDelete:File = File.documentsDirectory.resolvePath("upRail/plans/" + allPlans[event.currentTarget.index] + ".upmap");
			if (fileToDelete.exists) {
				try {
					fileToDelete.deleteFile();
				} catch (error:Error) {
					trace("Failed to delete file: " + error.message);
				}
			} else {
				trace("Plan does not exist: " + fileToDelete.nativePath);
			}
			updatePlansList();
		}
	
	}
}

function beginRead(){
	updatePlansList();
}