import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

stop();

units_crud_back_btn.addEventListener(MouseEvent.CLICK, return_to_title);

var chosenTrain = "CFR BWABA";
var trainCount: int = 0;
units_files_count.text = String(trainCount) + "/12";
var allUnits: Array = new Array();
var itemsInstantiatedUnit: Boolean = false;
var allMCsUnits: Array = new Array();
unit_pick_status.text = "Click on an unit to access it, or [-] to delete it.";

function loadUnits(){
    var directory:File = File.documentsDirectory.resolvePath("upRail/units");

    if (directory.exists && directory.isDirectory) {
        var filesList: Array = directory.getDirectoryListing();
        
		trainCount = filesList.length;
        for (var i: int = 0; i < filesList.length; i++) {
            var file:File = filesList[i];
			if (!file.isDirectory){
				var thisFileName:String = String(file.name);
				if (thisFileName.slice(-8) == ".uptrain"){
					allUnits.push(thisFileName.slice(0, -8));
				}
			}
        }
    }
}

new_unit_btn.addEventListener(MouseEvent.CLICK, go_to_new_unit);
function go_to_new_unit(event: MouseEvent){
	if (trainCount >= 12){
		unit_pick_status.text = "Train Storage Full";
	}
	chosenTrain = "0";
	gotoAndStop(8);
}

function clearTheUnitList(){
	for (var i: int = 0; i < allMCsUnits.length; i++){
		units_holder.removeChild(allMCs[i]);
	}
	allMCsUnits = [];
}

function updateUnitsList(){
	loadUnits();
	clearTheUnitList();
	if (trainCount == 0){
		unit_pick_status.text = "No Units Designed Yet";
	}
	units_files_count.text = String(trainCount) + "/12";
	for (var newUnitItem: int = 0; newUnitItem < trainCount; newUnitItem++){
		var toPutMCUnit = new unit_pick_element;
		units_holder.addChild(toPutMCUnit);
		allMCsUnits.push(toPutMCUnit);
		toPutMCUnit.x = 960;
		toPutMCUnit.y = 220 + (newUnitItem * 60);
		toPutMCUnit.buttonMode = true;
		toPutMCUnit.useHandCursor = true;
		toPutMCUnit.index = newUnitItem;
		if (toPutMCUnit.train_element_title.text != null){
			toPutMCUnit.train_element_title.text = allUnits[newUnitItem];
		}
		var toPutBtnUnit = new btn_minus_square;
		units_holder.addChild(toPutBtnUnit);
		allMCsUnits.push(toPutBtnUnit);
		toPutBtnUnit.x = 1830;
		toPutBtnUnit.y = 220 + (newUnitItem * 60);
		toPutBtnUnit.index = newUnitItem;
	
		toPutMCUnit.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverMCU);
		toPutMCUnit.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutMCU);
		toPutMCUnit.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMCU);
		toPutMCUnit.addEventListener(MouseEvent.CLICK, onClickMCU);

		toPutBtnUnit.addEventListener(MouseEvent.CLICK, onClickBtnU);
		
		function onMouseOverMCU(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(2);
		}
		function onMouseOutMCU(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(1);
		}
		function onMouseDownMCU(event: MouseEvent): void {
			event.currentTarget.gotoAndStop(3);
		}
		function onClickMCU(event: MouseEvent): void {
			chosenTrain = allUnits[event.currentTarget.index];
			gotoAndStop(8);
		}
		function onClickBtnU(event: MouseEvent): void {
			var fileToDelete:File = File.documentsDirectory.resolvePath("upRail/units/" + allUnits[event.currentTarget.index] + ".uptrain");
			if (fileToDelete.exists) {
				try {
					fileToDelete.deleteFile();
				} catch (error:Error) {
					trace("Failed to delete file: " + error.message);
				}
			} else {
				trace("Unit does not exist: " + fileToDelete.nativePath);
			}
			updateUnitsList();
		}
	
	}
}

function beginReadUnit(){
	updateUnitsList();
}