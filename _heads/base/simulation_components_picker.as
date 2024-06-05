import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

stop();

ping9.gotoAndStop(2);

select_back_btn.addEventListener(MouseEvent.CLICK, return_to_title);
selection_front_btn.visible = false;

var selectedUnit: String = "0";
var selectedPlan: String = "0";

selection_chosen_unit.text = "";
selection_chosen_plan.text = "";

var allUnitsSelect: Array = new Array();
var allPlansSelect: Array = new Array();

var selectedPlansMC: Array = new Array();
var selectedUnitsMC: Array = new Array();

selection_front_btn.addEventListener(MouseEvent.CLICK, selection_proceed);
function selection_proceed(event: MouseEvent){
	gotoAndStop(10);
}

function loadSelectUnits(){
    var directory:File = File.documentsDirectory.resolvePath("upRail/units");

    if (directory.exists && directory.isDirectory) {
        var filesList: Array = directory.getDirectoryListing();
        
		trainCount = filesList.length;
        for (var i: int = 0; i < filesList.length; i++) {
            var file:File = filesList[i];
			if (!file.isDirectory){
				var thisFileName:String = String(file.name);
				if (thisFileName.slice(-8) == ".uptrain"){
					allUnitsSelect.push(thisFileName.slice(0, -8));
				}
			}
        }
    }
}

function loadSelectPlans(){
    var directory:File = File.documentsDirectory.resolvePath("upRail/plans");

    if (directory.exists && directory.isDirectory) {
        var filesList: Array = directory.getDirectoryListing();
        
		mapCount = filesList.length;
        for (var i: int = 0; i < filesList.length; i++) {
            var file:File = filesList[i];
			if (!file.isDirectory){
				var thisFileName:String = String(file.name);
				if (thisFileName.slice(-6) == ".upmap"){
					allPlansSelect.push(thisFileName.slice(0, -6));
				}
			}
        }
    }
}

function clearSelectPlanList(){
	for (var i: int = 0; i < selectedPlansMC.length; i++){
		select_plans_holder.removeChild(selectedPlansMC[i]);
	}
	selectedPlansMC = [];
}

function updateSelectionPlansList(){
	loadSelectPlans();
	clearSelectPlanList();
	if (allPlansSelect.length == 0){
		selection_chosen_plan.text = "No plans designed yet."
	}
	for (var newPlanItem: int = 0; newPlanItem < allPlansSelect.length; newPlanItem++){
		var toPutMC = new selection_element;
		select_plans_holder.addChild(toPutMC);
		selectedPlansMC.push(toPutMC);
		toPutMC.x = 0;
		toPutMC.y = 40 + (newPlanItem * 40);
		toPutMC.buttonMode = true;
		toPutMC.useHandCursor = true;
		toPutMC.index = newPlanItem;
		if (toPutMC.component_title.text != null){
			toPutMC.component_title.text = allPlansSelect[newPlanItem];
		}
	
		toPutMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMC);
		toPutMC.addEventListener(MouseEvent.CLICK, onClickMC);
		
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
			selectedPlan = allPlansSelect[event.currentTarget.index];
			selection_chosen_plan.text = "Selected: " + selectedPlan;
			selectProceeding();
		}
	
	}
}

function clearSelectUnitList(){
	for (var i: int = 0; i < selectedUnitsMC.length; i++){
		select_units_holder.removeChild(selectedUnitsMC[i]);
	}
	selectedUnitsMC = [];
}

function updateSelectionUnitsList(){
	loadSelectUnits();
	clearSelectUnitList();
	if (allUnitsSelect.length == 0){
		selection_chosen_unit.text = "No units designed yet."
	}
	for (var newUnitItem: int = 0; newUnitItem < allUnitsSelect.length; newUnitItem++){
		var toPutMC = new selection_element;
		select_units_holder.addChild(toPutMC);
		selectedUnitsMC.push(toPutMC);
		toPutMC.x = 0;
		toPutMC.y = 40 + (newUnitItem * 40);
		toPutMC.buttonMode = true;
		toPutMC.useHandCursor = true;
		toPutMC.index = newUnitItem;
		if (toPutMC.component_title.text != null){
			toPutMC.component_title.text = allUnitsSelect[newUnitItem];
		}
	
		toPutMC.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutMC);
		toPutMC.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMC);
		toPutMC.addEventListener(MouseEvent.CLICK, onClickMC);
		
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
			selectedUnit = allUnitsSelect[event.currentTarget.index];
			selection_chosen_unit.text = "Selected: " + selectedUnit;
			selectProceeding();
		}
	
	}
}
   

function selectionLoadedUnits(){
	updateSelectionUnitsList();
}

function selectionLoadedPlans(){
	updateSelectionPlansList()
}

function selectProceeding(){
	if (selectedUnit != "0" && selectedPlan != "0"){
		selection_front_btn.visible = true;
	}
}