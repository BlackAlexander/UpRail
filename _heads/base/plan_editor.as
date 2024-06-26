import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

stop();

ping6.gotoAndStop(2);

plans_create_back_btn.addEventListener(MouseEvent.CLICK, return_to_plan_selector);
function return_to_plan_selector(event: MouseEvent){
	gotoAndStop(5);
}

new_node_coordinates.visible = false;
var plan_mass_limit: int = 0;
var speedRestrictions: Array = new Array();
var gripRestrictions: Array = new Array();
var impedimentRestrictions: Array = new Array();
plan_title.text = "untitled";

function compute_track_length(){
	if (plan_maker.track == null){
		return 0;
	}
	var fullTrack = plan_maker.track;
	var finalSum: Number = 0;
	for (var i: int = 0; i < fullTrack.length - 1; i++){
		var segmentLength: Number;
		var xa: Number = fullTrack[i][0];
		var xb: Number = fullTrack[i + 1][0];
		var ya: Number = fullTrack[i][1];
		var yb: Number = fullTrack[i + 1][1];
		segmentLength = Math.sqrt((xb-xa)*(xb-xa)+(yb-ya)*(yb-ya));
		finalSum += segmentLength;
	}
	return finalSum;
}

function compute_track_start(){
	if (plan_maker.track == null){
		return 0;
	}
	return plan_maker.track[0][1];
}
function compute_track_finish(){
	if (plan_maker.track == null){
		return 0;
	}
	return plan_maker.track[plan_maker.track.length - 1][1];
}
function compute_highest_elevation(){
	if (plan_maker.track == null){
		return 0;
	}
	var fullTrack = plan_maker.track;
	var highest: int = 0;
	for (var i: int = 0; i < fullTrack.length; i++){
		if (fullTrack[i][1] > highest){
			highest = fullTrack[i][1];
		}
	}
	return highest;
}
function compute_lowest_elevation(){
	if (plan_maker.track == null){
		return 0;
	}
	var fullTrack = plan_maker.track;
	var lowest: int = 500;
	for (var i: int = 0; i < fullTrack.length; i++){
		if (fullTrack[i][1] < lowest){
			lowest = fullTrack[i][1];
		}
	}
	return lowest;
}
function compute_elevation_change(){
	return compute_highest_elevation() - compute_lowest_elevation();
}
function compute_nodes_count(){
	if (plan_maker.track == null){
		return 0;
	}
	return plan_maker.track.length;
}
function compute_steepest_climb(){
	if (plan_maker.track == null){
		return 0;
	}
	var fullTrack = plan_maker.track;
	var highest: Number = -50000; //lowest possible slope
	for (var i: int = 0; i < fullTrack.length - 1; i++){
		var segmentClimb: Number;
		var xa: Number = fullTrack[i][0];
		var xb: Number = fullTrack[i + 1][0];
		var ya: Number = fullTrack[i][1];
		var yb: Number = fullTrack[i + 1][1];
		segmentClimb = (yb-ya)/(xb-xa)*100;
		if (segmentClimb > highest){
			highest = segmentClimb;
		}
	}
	return highest;
}

function compute_narrowest_angle_out(){
	if (plan_maker.track == null){
		return 0;
	}
	if (plan_maker.track.length <= 2){
		return 180;
	}
	var fullTrack = plan_maker.track;
	var narrowest: Number = -180;
	for (var i: int = 1; i < fullTrack.length - 1; i++){
		var currentAngle: Number;
		var xa: Number = fullTrack[i-1][0];
		var xb: Number = fullTrack[i][0];
		var xc: Number = fullTrack[i+1][0];
		var ya: Number = fullTrack[i-1][1];
		var yb: Number = fullTrack[i][1];
		var yc: Number = fullTrack[i+1][1];
		
		var abx: Number = xb - xa;
		var aby: Number = yb - ya;
		var bcx: Number = xc - xb;
		var bcy: Number = yc - yb;
		var dotProduct: Number = abx * bcx + aby * bcy;
		var magnitudeAB: Number = Math.sqrt(abx * abx + aby * aby);
		var magnitudeBC: Number = Math.sqrt(bcx * bcx + bcy * bcy);
		var cosTheta: Number = dotProduct / (magnitudeAB * magnitudeBC);
		if (cosTheta < -1) {
			cosTheta = -1;
		} else if (cosTheta > 1) {
			cosTheta = 1;
		}
		var theta: Number = Math.acos(cosTheta);
		var thetaDegrees: Number = theta * (180 / Math.PI);
		var crossProduct: Number = abx * bcy - aby * bcx;
		if (crossProduct < 0) {
			thetaDegrees = 360 - thetaDegrees;
		}
		currentAngle = (180 - thetaDegrees);
		if (currentAngle < 0){
			if (currentAngle > narrowest){
				narrowest = currentAngle;
			}
		}
	}
	return int(Math.abs(narrowest));
}

function compute_narrowest_angle_in(){
	if (plan_maker.track == null){
		return 0;
	}
	if (plan_maker.track.length <= 2){
		return 180;
	}
	var fullTrack = plan_maker.track;
	var narrowest: Number = 180;
	for (var i: int = 1; i < fullTrack.length - 1; i++){
		var currentAngle: Number;
		var xa: Number = fullTrack[i-1][0];
		var xb: Number = fullTrack[i][0];
		var xc: Number = fullTrack[i+1][0];
		var ya: Number = fullTrack[i-1][1];
		var yb: Number = fullTrack[i][1];
		var yc: Number = fullTrack[i+1][1];
		
		var abx: Number = xb - xa;
		var aby: Number = yb - ya;
		var bcx: Number = xc - xb;
		var bcy: Number = yc - yb;
		var dotProduct: Number = abx * bcx + aby * bcy;
		var magnitudeAB: Number = Math.sqrt(abx * abx + aby * aby);
		var magnitudeBC: Number = Math.sqrt(bcx * bcx + bcy * bcy);
		var cosTheta: Number = dotProduct / (magnitudeAB * magnitudeBC);
		var theta: Number = Math.acos(cosTheta);
		var thetaDegrees: Number = theta * (180 / Math.PI);
		var crossProduct: Number = abx * bcy - aby * bcx;
		if (crossProduct < 0) {
			thetaDegrees = 360 - thetaDegrees;
		}
		currentAngle = (180 - thetaDegrees);
		if (currentAngle > 0){
			if (currentAngle < narrowest){
				narrowest = currentAngle;
			}
		}
	}
	return int(narrowest);
}

function update_data(){
	if(data_panel.currentFrame != 1){
		return;
	}
	data_panel.data_track_length.text = String(compute_track_length());
	data_panel.data_start_elevation.text = String(compute_track_start());
	data_panel.data_finish_elevation.text = String(compute_track_finish());
	data_panel.data_mass_limit.text = String(plan_mass_limit);
	data_panel.data_nodes_count.text = String(compute_nodes_count());
	data_panel.data_speed_restrictions.text = String(speedRestrictions.length);
	data_panel.data_grip_segments.text = String(gripRestrictions.length);
	data_panel.data_impediment_segments.text = String(impedimentRestrictions.length);
	data_panel.data_highest_elevation.text = String(compute_highest_elevation());
	data_panel.data_lowest_elevation.text = String(compute_lowest_elevation());
	data_panel.data_steepest_climb.text = String(int(compute_steepest_climb())) + "%";
	data_panel.data_elevation_change.text = String(compute_elevation_change());
	data_panel.data_narrowest_angle_in.text = String(compute_narrowest_angle_in()) + "°";
	data_panel.data_narrowest_angle_out.text = String(compute_narrowest_angle_out()) + "°";
}

function quick_add(nodeX: int, nodeY: int){
	if (nodeX < 0 || nodeX > 1000) {
		showPlanInputError("X out of bounds.");
		return;
	}
	if (nodeY < 0 || nodeY >= 500) {
		showPlanInputError("Y out of bounds.");
		return;
	}
	plan_maker.add_node(nodeX, nodeY);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function quick_remove(nodeX: int){
	if (nodeX < 0 || nodeX > 1000) {
		showPlanInputError("X out of bounds.");
		return;
	}
	plan_maker.remove_node(nodeX);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function interval_remove(leftIndex: int, rightIndex: int){
	for (var i: int = leftIndex; i <= rightIndex; i++){
		plan_maker.remove_node(i);
	}
	plan_maker.update_plan();
	update_data();
}

function maker(){
	plan_maker.add_node(0, 50);
	plan_maker.add_node(1000, 50);
	
	readMapFile();
	
	plan_maker.update_plan();
	update_data();
}

function showPlanInputError(theMessage: String){
	input_panel.gotoAndStop(15);
	input_panel.input_status_message.text = theMessage;
	input_panel.play();
}

function quick_set_start_height(nodeY: int){
	if (nodeY < 0 || nodeY >= 500) {
		showPlanInputError("Height out of bounds.");
		return;
	}
	plan_maker.set_start_height(nodeY);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function quick_set_end_height(nodeY: int){
	if (nodeY < 0 || nodeY >= 500) {
		showPlanInputError("Height out of bounds.");
		return;
	}
	plan_maker.set_end_height(nodeY);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function set_mass_limit(newMass: int){
	if (newMass < 0 || newMass > 99999999) {
		showPlanInputError("Mass out of bounds.");
		return;
	}
	plan_mass_limit = newMass;
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function add_speed_limit(value: int, left: int, right: int, limitType: String){
	if (value <= 0 || value >= 1000){
		showPlanInputError("Value out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (left < 0 || left > 1000){
		showPlanInputError("Left limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (right < 0 || right > 1000){
		showPlanInputError("Right limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (!((limitType == "min") || (limitType == "max"))){
		showPlanInputError("Limit type not supported.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (speedRestrictions.length == 12){
		showPlanInputError("Too many speed restrictions.");
		data_panel.gotoAndStop(1);
		return;
	}

    for (var i: int = 0; i < speedRestrictions.length; i++) {
        var existingValue: int = speedRestrictions[i][0];
        var existingLeft: int = speedRestrictions[i][1];
        var existingRight: int = speedRestrictions[i][2];
        var existingLimitType: String = speedRestrictions[i][3];
        if (!(right < existingLeft || left > existingRight)) {
            if (limitType == "min" && existingLimitType == "max" && value > existingValue) {
                showPlanInputError("Contradicting restrictions.");
				data_panel.gotoAndStop(1);
                return;
            }
            if (limitType == "max" && existingLimitType == "min" && value < existingValue) {
                showPlanInputError("Contradicting restrictions.");
				data_panel.gotoAndStop(1);
                return;
            }
        }
    }

	var newSpeedLimit: Array = new Array();
	newSpeedLimit = [value, left, right, limitType];
	speedRestrictions.push(newSpeedLimit);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function remove_speed_limit(indexToRemove: int){
	if (indexToRemove <= 0 || indexToRemove > speedRestrictions.length){
		showPlanInputError("Index out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	speedRestrictions.removeAt(indexToRemove - 1);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function add_grip_limit(value: int, left: int, right: int){
	if (value < 0 || value > 100){
		showPlanInputError("Value out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (left < 0 || left > 1000){
		showPlanInputError("Left limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (right < 0 || right > 1000){
		showPlanInputError("Right limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (gripRestrictions.length == 12){
		showPlanInputError("Too many grip restrictions.");
		data_panel.gotoAndStop(1);
		return;
	}
	var newGripLimit: Array = new Array();
	newGripLimit = [value, left, right];
	gripRestrictions.push(newGripLimit);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function remove_grip_limit(indexToRemove: int){
	if (indexToRemove <= 0 || indexToRemove > gripRestrictions.length){
		showPlanInputError("Index out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	gripRestrictions.removeAt(indexToRemove - 1);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function add_impediment_limit(value: int, left: int, right: int){
	if (value < 0 || value > 100){
		showPlanInputError("Value out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (left < 0 || left > 1000){
		showPlanInputError("Left limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (right < 0 || right > 1000){
		showPlanInputError("Right limit out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	if (impedimentRestrictions.length == 12){
		showPlanInputError("Too many impediment restrictions.");
		data_panel.gotoAndStop(1);
		return;
	}
	var newImpedimentLimit: Array = new Array();
	newImpedimentLimit = [value, left, right];
	impedimentRestrictions.push(newImpedimentLimit);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

function remove_impediment_limit(indexToRemove: int){
	if (indexToRemove <= 0 || indexToRemove > impedimentRestrictions.length){
		showPlanInputError("Index out of bounds.");
		data_panel.gotoAndStop(1);
		return;
	}
	impedimentRestrictions.removeAt(indexToRemove - 1);
	data_panel.gotoAndStop(1);
	plan_maker.update_plan();
	update_data();
	showPlanInputError("OK");
}

plan_add_square.addEventListener(MouseEvent.CLICK, planAddSquare);
function planAddSquare(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(2);
	plan_maker.show_node_buttons();
}

plan_remove_square.addEventListener(MouseEvent.CLICK, planRemoveSquare);
function planRemoveSquare(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(3);
	plan_maker.show_node_buttons();
}


plan_add_round.addEventListener(MouseEvent.CLICK, planAddRound);
function planAddRound(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(4);
	plan_maker.show_node_buttons();
	new_node_coordinates.visible = true;
	new_node_coordinates.text = "0, 0";
	var newNode = new plan_node;
	newNode.name = "guide-node";
	this.addChild(newNode);
	newNode.buttonMode = true;
	newNode.useHandCursor = true;
	var firstClick: Boolean = true;
	stage.addEventListener(MouseEvent.MOUSE_MOVE, followCursor);
	function followCursor(event:MouseEvent):void {
		newNode.x = Math.min(Math.max(event.stageX, 100), 1350);
		newNode.y = Math.min(Math.max(event.stageY, 200), 825);
		if (!(mouseX <= 100 || mouseX >= 1350 || mouseY <= 200 || mouseY >= 825)){
			var newNodeMouseXPos: int;
			var newNodeMouseYPos: int;
			newNodeMouseXPos = int((mouseX - 100)/1.25);
			newNodeMouseYPos = 500 - int((mouseY - 200)/1.25);
			new_node_coordinates.text = String(newNodeMouseXPos) + ", " + String(newNodeMouseYPos);
		}
	}
	stage.addEventListener(MouseEvent.CLICK, followClicked);
	function followClicked(event:MouseEvent):void {
		if (mouseX <= 100 || mouseX >= 1350 || mouseY <= 200 || mouseY >= 825){
			if (firstClick){
				firstClick = false;
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, followCursor);
				stage.removeEventListener(MouseEvent.CLICK, followClicked);
				finish_circle_add();
			}
		} else {
			var newNodeMouseX: int;
			var newNodeMouseY: int;
			newNodeMouseX = int((mouseX - 100)/1.25);
			newNodeMouseY = 500 - int((mouseY - 200)/1.25);
			plan_maker.add_node(newNodeMouseX, newNodeMouseY);
			plan_maker.update_plan();
			update_data();
			plan_maker.show_node_buttons();
		}
	}
	//on click, if mouse inside screen, add node, else finish circle add
}

function finish_circle_add(){
	new_node_coordinates.visible = false;
	if (this.getChildByName("guide-node") != null){
		this.removeChild(this.getChildByName("guide-node"));
	}
	plan_maker.update_plan();
	update_data();
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(1);
}

plan_remove_round.addEventListener(MouseEvent.CLICK, planRemoveRound);
function planRemoveRound(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(5);
	planRemoveRoundSingle();
}

function planRemoveRoundSingle(){
	plan_maker.show_node_buttons();
	for (var i: int = 0; i < plan_maker.paintedNodes.length; i++) {
	(function(index: int): void {
		plan_maker.paintedNodes[index].buttonMode = true;
		plan_maker.paintedNodes[index].useHandCursor = true;
		plan_maker.paintedNodes[index].addEventListener(MouseEvent.CLICK, function(event: MouseEvent): void {
			if ((index == 0) || (index == plan_maker.track.length - 1)) {
				return;
			}
			plan_maker.remove_node(plan_maker.track[index][0]);
			plan_maker.update_plan();
			update_data();
			planRemoveRoundSingle();
		});
	})(i);
	}
}

function finish_circle_remove(){
	plan_maker.hide_node_buttons();
	plan_maker.update_plan();
	update_data();
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(1);
}

plan_edit_start_elevation.addEventListener(MouseEvent.CLICK, planEditStartElevation);
function planEditStartElevation(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(6);
}

plan_edit_finish_elevation.addEventListener(MouseEvent.CLICK, planEditFinishElevation);
function planEditFinishElevation(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(7);
}

plan_edit_mass.addEventListener(MouseEvent.CLICK, planEditMass);
function planEditMass(event: MouseEvent){
	data_panel.gotoAndStop(1);
	input_panel.gotoAndStop(8);
}

plan_add_speed.addEventListener(MouseEvent.CLICK, planAddSpeed);
function planAddSpeed(event: MouseEvent){
	data_panel.gotoAndStop(2);
	input_panel.gotoAndStop(9);
}

plan_add_grip.addEventListener(MouseEvent.CLICK, planAddGrip);
function planAddGrip(event: MouseEvent){
	data_panel.gotoAndStop(3);
	input_panel.gotoAndStop(11);
}

plan_add_impediment.addEventListener(MouseEvent.CLICK, planAddImpediment);
function planAddImpediment(event: MouseEvent){
	data_panel.gotoAndStop(4);
	input_panel.gotoAndStop(13);
}

plan_remove_speed.addEventListener(MouseEvent.CLICK, planRemoveSpeed);
function planRemoveSpeed(event: MouseEvent){
	data_panel.gotoAndStop(2);
	input_panel.gotoAndStop(10);
}

plan_remove_grip.addEventListener(MouseEvent.CLICK, planRemoveGrip);
function planRemoveGrip(event: MouseEvent){
	data_panel.gotoAndStop(3);
	input_panel.gotoAndStop(12);
}

plan_remove_impediment.addEventListener(MouseEvent.CLICK, planRemoveImpediment);
function planRemoveImpediment(event: MouseEvent){
	data_panel.gotoAndStop(4);
	input_panel.gotoAndStop(14);
}

plan_save_btn.addEventListener(MouseEvent.CLICK, planSaveFile);
function planSaveFile(event: MouseEvent){
	saveThePlan();
}


function saveThePlan(){
	if (plan_maker.track == null){
		showPlanInputError("Could not save file.");
		return;
	}
	var fileText: String = "";
	fileText += "TITLE: ";
	fileText += plan_title.text;
	fileText += "\n";
	fileText += "MASS: ";
	fileText += String(plan_mass_limit);
	fileText += "\n";
	fileText += "NODES: ";
	fileText += String(plan_maker.track.length);
	fileText += "\n";
	for (var i: int = 0; i < plan_maker.track.length; i++){
		fileText += String(plan_maker.track[i][0]);
		fileText += " ";
		fileText += String(plan_maker.track[i][1]);
		fileText += "\n";
	}
	fileText += "SPEED: ";
	fileText += String(speedRestrictions.length);
	fileText += "\n";
	for (var isf: int = 0; isf < speedRestrictions.length; isf++){
		fileText += String(speedRestrictions[isf][0]);
		fileText += " ";
		fileText += String(speedRestrictions[isf][1]);
		fileText += " ";
		fileText += String(speedRestrictions[isf][2]);
		fileText += " ";
		fileText += speedRestrictions[isf][3];
		fileText += "\n";
	}
	fileText += "GRIP: ";
	fileText += String(gripRestrictions.length);
	fileText += "\n";
	for (var igf: int = 0; igf < gripRestrictions.length; igf++){
		fileText += String(gripRestrictions[igf][0]);
		fileText += " ";
		fileText += String(gripRestrictions[igf][1]);
		fileText += " ";
		fileText += String(gripRestrictions[igf][2]);
		fileText += "\n";
	}
	fileText += "IMPEDIMENT: ";
	fileText += String(impedimentRestrictions.length);
	fileText += "\n";
	for (var irf: int = 0; irf < impedimentRestrictions.length; irf++){
		fileText += String(impedimentRestrictions[irf][0]);
		fileText += " ";
		fileText += String(impedimentRestrictions[irf][1]);
		fileText += " ";
		fileText += String(impedimentRestrictions[irf][2]);
		fileText += "\n";
	}

	var pattern:RegExp = /[^a-zA-Z ]+/g;
	var planTitle: String;
	planTitle = String(plan_title.text).replace(pattern, "");


	var currentDir:File = File.documentsDirectory.resolvePath("upRail/plans");
	if (!currentDir.exists) {
		currentDir.createDirectory();
	}

	var file:File = currentDir.resolvePath(planTitle + ".upmap");
	var fileStream:FileStream = new FileStream();
	try {
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(fileText);
		fileStream.close();
	
		showPlanInputError("Plan Saved");
	} catch (error:Error) {
		showPlanInputError("Could not save file: " + error.message);
	}
}

function readMapFile(){
	if (plan_maker.track == null || chosenMap == null){
		showPlanInputError("Could not load file.");
		return;
	}
	if (chosenMap == "0"){
		return;
	}

	try {
		var newPlanFile:File = File.documentsDirectory.resolvePath("upRail/plans/" + chosenMap + ".upmap");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newPlanFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		showPlanInputError("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	plan_title.text = fileLines[0].slice(7);
	plan_mass_limit = int(fileLines[1].slice(6));
	var readNodesCount: int = 0;
	readNodesCount = int(fileLines[2].slice(7));
	speedRestrictions = [];
	gripRestrictions = [];
	impedimentRestrictions = [];
	for (var nodeIndexCount: int = 0; nodeIndexCount < readNodesCount; nodeIndexCount++){
		var nodeLine: Array = fileLines[3 + nodeIndexCount].split(' ');
		var readNodeX = int(nodeLine[0]);
		var readNodeY = int(nodeLine[1]);
		quick_add(readNodeX, readNodeY);
	}
	var speedLimitsCount = int(fileLines[readNodesCount + 3].slice(7));
	for (var speedIndexCount: int = 0; speedIndexCount < speedLimitsCount; speedIndexCount++){
		var nodeLineS: Array = fileLines[4 + readNodesCount + speedIndexCount].split(' ');
		add_speed_limit(nodeLineS[0], nodeLineS[1], nodeLineS[2], nodeLineS[3]);
	}
	var gripLimitsCount = int(fileLines[4 + readNodesCount + speedLimitsCount].slice(6));
	for (var gripIndexCount: int = 0; gripIndexCount < gripLimitsCount; gripIndexCount++){
		var nodeLineG: Array = fileLines[5 + readNodesCount + speedLimitsCount + gripIndexCount].split(' ');
		add_grip_limit(nodeLineG[0], nodeLineG[1], nodeLineG[2]);
	}
	var impedimentLimitsCount = int(fileLines[5 + readNodesCount + speedLimitsCount + gripLimitsCount].slice(12));
	for (var impedimentIndexCount: int = 0; impedimentIndexCount < impedimentLimitsCount; impedimentIndexCount++){
		var nodeLineI: Array = fileLines[6 + readNodesCount + speedLimitsCount + gripLimitsCount + impedimentIndexCount].split(' ');
		add_impediment_limit(nodeLineI[0], nodeLineI[1], nodeLineI[2]);
	}
}