import flash.events.MouseEvent;

stop();

ping8.gotoAndStop(2);

units_create_back_btn.addEventListener(MouseEvent.CLICK, return_to_unit_selector);
function return_to_unit_selector(event: MouseEvent){
	gotoAndStop(7);
}

var unitp_wheel_grip: int = 100;
var unitp_maximum_distance: int = 0;
var unitp_angle_restriction_out: int = 0;
var unitp_angle_restriction_in: int = 0;
var unitp_top_speed_restriction: int = 0;
var unitp_max_up_climb: int = 0;
var unitp_max_down_climb: int = 0;

function add8spaces(num: Number){
	var result: String = "";
	for(var i: int = 0; i < 8 - String(num).length; i++){
		result += " ";
	}
	return result + String(num);
}

function add32spaces(num: int){
	var result: String = "";
	for(var i: int = 0; i < 29 - String(num).length; i++){
		result += " ";
	}
	return result + String(num);
}

function update_unit_listing(){
	if (unit_maker.cars == null){
		return;
	}
	if (unit_listing.the_list == null){
		return;
	}
	unit_listing.the_list.text = "";
	var finalString: String = "";
	for (var i:int = 0; i < unit_maker.cars.length; i++){
		var currentCar = unit_maker.cars[i];
		var currentString: String = "";
		if (i < 9) {
			currentString += "0";
		}
		currentString += String(i + 1);
		currentString += ": ";
		if (currentCar[1] == "engine"){
			currentString += "ENGINE "; 
			currentString += add8spaces(currentCar[2]);
			currentString += "kW ";
			currentString += add8spaces(currentCar[3]);
			currentString += "N ";
			currentString += add8spaces(currentCar[0]);
			currentString += "KG";
		} else {
			currentString += "LOAD   ";
			currentString += add32spaces(currentCar[0]);
			currentString += "KG";
		}
		currentString += '\n';
		finalString += currentString;
	}
	unit_listing.the_list.text = finalString;
}

function loadedUnits(){
	readTrainFile();
	if (unit_maker.cars.length == 0){
		quick_add_new_car(0, 1, "engine", 1, 10);
	}
	updateUnitData();
}

function updateUnitData(){
	unit_car_count.text = String(unit_maker.cars.length) + "/24";
	update_unit_listing();
	unit_maker.updateCars();
	fillUnitDataPanel();
}

function quick_add_new_car(carIndex: int, carMass: int, carType: String, engineForce: Number, brakingForce: Number){
	if (unit_maker.cars == null){
		return;
	}
	unit_maker.addNewCar(carIndex, carMass, carType, engineForce, brakingForce);
}

function quick_remove_car(carIndex: int){
	if (unit_maker.cars == null){
		return;
	}
	unit_maker.removeCarByIndex(carIndex);
}

function compute_unit_car_length(){
	return 20;
}

function compute_unit_length(){
	if (unit_maker.cars == null){
		return;
	}
	return (unit_maker.cars.length * 20);
}

function compute_unit_length_spaced(){
	if (unit_maker.cars == null){
		return;
	}
	return (unit_maker.cars.length * 22);
}

function compute_load_count(){
	if (unit_maker.cars == null){
		return;
	}
	return unit_maker.loadCount;
}

function compute_engine_count(){
	if (unit_maker.cars == null){
		return;
	}
	return unit_maker.engineCount;
}

function compute_unit_mass(){
	if (unit_maker.cars == null){
		return;
	}
	var unitMass: int = 0;
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		unitMass += unit_maker.cars[i][0];
	}
	return unitMass;
}

function compute_tractive_power(){
	if (unit_maker.cars == null){
		return;
	}
	var unitPower: Number = 0;
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		unitPower += unit_maker.cars[i][2];
	}
	return unitPower;
}

function compute_braking_power(){
	if (unit_maker.cars == null){
		return;
	}
	var unitBrake: int = 0;
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		unitBrake += unit_maker.cars[i][3];
	}
	return unitBrake;
}

function compute_weight_center(){
	if (unit_maker.cars == null){
		return;
	}
	var momentSum: Number = 0;
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		var currentCarCenter: Number;
		var currentCarMoment: Number;
		currentCarCenter = i*22 + (20/2);
		currentCarMoment = currentCarCenter * unit_maker.cars[i][0];
		momentSum += currentCarMoment;
	}
	return momentSum/(compute_unit_mass());
}

function compute_weight_center_car_index(){
	if (unit_maker.cars == null){
		return;
	}
	var weight_center: Number = compute_weight_center();
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		var leftInt: Number = 22*i;
		var rightInt: Number = 22*i + 20;
		if (leftInt <= weight_center && weight_center <= rightInt){
			return i + 1;
		}
	}
	return 0;
}

function fillUnitDataPanel(){
	unit_data_panel.udata_car_length.text = String(compute_unit_car_length());
	unit_data_panel.udata_unit_length.text = String(compute_unit_length()) + "m|" + String(compute_unit_length_spaced()) + "m";
	unit_data_panel.udata_car_count.text = String(compute_engine_count()) + "E|" + String(compute_load_count()) + "L";
	unit_data_panel.udata_unit_mass.text = String(compute_unit_mass());
	unit_data_panel.udata_unit_tractive_power.text = String(compute_tractive_power()) + "kW";
	unit_data_panel.udata_unit_braking_power.text = String(compute_braking_power()) + "N";
	unit_data_panel.udata_unit_weight_center.text = String(compute_weight_center().toPrecision(3)) + "m | car_" + String(compute_weight_center_car_index());
	unit_data_panel.udata_wheel_grip.text = String(unitp_wheel_grip);
	unit_data_panel.udata_maximum_distance.text = String(unitp_maximum_distance) + "m";
	unit_data_panel.udata_angle_restriction_in.text = String(unitp_angle_restriction_in) + "°";
	unit_data_panel.udata_angle_restriction_out.text = String(unitp_angle_restriction_out) + "°";
	unit_data_panel.udata_top_speed_restriction.text = String(unitp_top_speed_restriction) + "m/s";
	unit_data_panel.udata_max_upwards_climb_angle.text = String(unitp_max_up_climb) + "%";
	unit_data_panel.udata_max_downwards_climb_angle.text = String(unitp_max_down_climb) + "%";
}

function showUnitInputError(theMessage: String){
	unit_input_panel.gotoAndStop(14);
	unit_input_panel.input_message_field.text = theMessage;
	unit_input_panel.play();
}

function unit_input_add(uindex: int, umass: int, utype: String, utr: Number, ubr: Number){
	if (unit_maker.cars == null){
		return;
	}
	if (uindex < 0 || uindex > unit_maker.cars.length){
		showUnitInputError("Index Out of Bounds");
		return;
	}
	if (unit_maker.cars.length == 24){
		showUnitInputError("Unit Length Exceeded");
		return;
	}
	if (umass <= 0 || umass > 99999999){
		showUnitInputError("Mass Out of Bounds");
		return;
	}
	if (utr < 0 || String(utr).length > 8){
		showUnitInputError("Traction Power Put of Bounds");
		return;
	}
	if (ubr < 0 || String(ubr).length > 8){
		showUnitInputError("Braking Force Out of Bounds");
		return;
	}
	quick_add_new_car(uindex, umass, utype, utr, ubr);
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_modify(uindex: int, umass: int, utype: String, utr: Number, ubr: Number){
	if (unit_maker.cars == null){
		return;
	}
	uindex--;
	if (uindex < 0 || uindex >= unit_maker.cars.length){
		showUnitInputError("Index Out of Bounds");
		return;
	}
	if (umass <= 0 || umass > 99999999){
		showUnitInputError("Mass Out of Bounds");
		return;
	}
	if (utr < 0 || String(utr).length > 8){
		showUnitInputError("Traction Power out of Bounds");
		return;
	}
	if (ubr < 0 || String(ubr).length > 8){
		showUnitInputError("Braking Force Out of Bounds");
		return;
	}
	if (compute_engine_count() == 1){
		if (unit_maker.cars[uindex][1] == "engine" && utype != "engine"){
			showUnitInputError("Unit Must Have at Least One Engine");
			return;
		}
	}
	var oldLength = unit_maker.cars.length;
	quick_remove_car(uindex);
	quick_add_new_car(uindex, umass, utype, utr, ubr);
	if (unit_maker.cars.length > oldLength){
		quick_remove_car(uindex + 1);
	}
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_remove(uindex: int){
	if (unit_maker.cars == null){
		return;
	}
	uindex--;
	if (uindex < 0 || uindex >= unit_maker.cars.length){
		showUnitInputError("Index Out of Bounds");
		return;
	}
	if (compute_engine_count() == 1){
		if (unit_maker.cars[uindex][1] == "engine"){
			showUnitInputError("Unit Must Have at Least One Engine");
			return;
		}
	}
	quick_remove_car(uindex);
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_grip(newValue: int){
	if (newValue < 0 || newValue > 100){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_wheel_grip = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_max_distance(newValue: int){
	if (newValue < 0 || newValue > 9999999){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_maximum_distance = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_angle_restriction_in(newValue: int){
	if (newValue < 0 || newValue > 180){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_angle_restriction_in = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_angle_restriction_out(newValue: int){
	if (newValue < 0 || newValue > 180){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_angle_restriction_out = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_top_speed(newValue: int){
	if (newValue < 0 || newValue > 99999999){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_top_speed_restriction = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_max_up_climb(newValue: int){
	if (newValue < 0 || newValue > 99999){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_max_up_climb = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

function unit_input_max_down_climb(newValue: int){
	if (newValue < 0 || newValue > 99999){
		showUnitInputError("Value Out of Bounds");
		return;
	}
	unitp_max_down_climb = newValue;
	updateUnitData();
	showUnitInputError("OK");
}

unit_add.addEventListener(MouseEvent.CLICK, unitAddCarBtn);
function unitAddCarBtn(event: MouseEvent){
	unit_input_panel.gotoAndStop(2)
}

unit_edit.addEventListener(MouseEvent.CLICK, unitEditCarBtn);
function unitEditCarBtn(event: MouseEvent){
	unit_input_panel.gotoAndStop(4)
}

unit_remove.addEventListener(MouseEvent.CLICK, unitRemoveCarBtn);
function unitRemoveCarBtn(event: MouseEvent){
	unit_input_panel.gotoAndStop(6)
}

unit_edit_grip.addEventListener(MouseEvent.CLICK, unitEditGrip);
function unitEditGrip(event: MouseEvent){
	unit_input_panel.gotoAndStop(7)
}

unit_edit_max_distance.addEventListener(MouseEvent.CLICK, unitEditMaxD);
function unitEditMaxD(event: MouseEvent){
	unit_input_panel.gotoAndStop(8)
}

unit_edit_angle_restriction_in.addEventListener(MouseEvent.CLICK, unitEditAngleIn);
function unitEditAngleIn(event: MouseEvent){
	unit_input_panel.gotoAndStop(9)
}

unit_edit_angle_restriction_out.addEventListener(MouseEvent.CLICK, unitEditAngleOut);
function unitEditAngleOut(event: MouseEvent){
	unit_input_panel.gotoAndStop(10)
}

unit_edit_top_speed.addEventListener(MouseEvent.CLICK, unitEditTop);
function unitEditTop(event: MouseEvent){
	unit_input_panel.gotoAndStop(11)
}

unit_edit_max_up_climb.addEventListener(MouseEvent.CLICK, unitEditMaxUp);
function unitEditMaxUp(event: MouseEvent){
	unit_input_panel.gotoAndStop(12)
}

unit_edit_max_down_climb.addEventListener(MouseEvent.CLICK, unitEditMaxDown);
function unitEditMaxDown(event: MouseEvent){
	unit_input_panel.gotoAndStop(13)
}


unit_save_btn.addEventListener(MouseEvent.CLICK, unitSaveFile);
function unitSaveFile(event: MouseEvent){
	saveTheUnit();
}

function saveTheUnit(){
	if (unit_maker.cars == null){
		showUnitInputError("Could Not Save File");
		return;
	}
	var fileText: String = "";
	fileText += "TITLE: ";
	fileText += unit_title.text;
	fileText += "\n";
	fileText += "WHEEL_GRIP: ";
	fileText += String(unitp_wheel_grip);
	fileText += "\n";
	fileText += "MAXIMUM_DISTANCE_RESTRICTION: ";
	fileText += String(unitp_maximum_distance);
	fileText += "\n";
	fileText += "ANGLE_RESTRICTION_IN: ";
	fileText += String(unitp_angle_restriction_in);
	fileText += "\n";
	fileText += "ANGLE_RESTRICTION_OUT: ";
	fileText += String(unitp_angle_restriction_out);
	fileText += "\n";
	fileText += "TOP_SPEED_RESTRICTION: ";
	fileText += String(unitp_top_speed_restriction);
	fileText += "\n";
	fileText += "MAX_UPWARDS_CLIMB_ANGLE: ";
	fileText += String(unitp_max_up_climb);
	fileText += "\n";
	fileText += "MAX_DOWNWARDS_CLIMB_ANGLE: ";
	fileText += String(unitp_max_down_climb);
	fileText += "\n";
	fileText += "CARS: ";
	fileText += String(unit_maker.cars.length);
	fileText += "\n";
	for (var i: int = 0; i < unit_maker.cars.length; i++){
		fileText += String(unit_maker.cars[i][0]) + " ";
		fileText += String(unit_maker.cars[i][1]) + " ";
		fileText += String(unit_maker.cars[i][2]) + " ";
		fileText += String(unit_maker.cars[i][3]) + "\n";
	}

	var pattern:RegExp = /[^a-zA-Z ]+/g;
	var unitTitle: String;
	unitTitle = String(unit_title.text).replace(pattern, "");


	var currentDir:File = File.documentsDirectory.resolvePath("upRail/units");
	if (!currentDir.exists) {
		currentDir.createDirectory();
	}

	var file:File = currentDir.resolvePath(unitTitle + ".uptrain");
	var fileStream:FileStream = new FileStream();
	try {
		fileStream.open(file, FileMode.WRITE);
		fileStream.writeUTFBytes(fileText);
		fileStream.close();
	
		showUnitInputError("Unit Saved");
	} catch (error:Error) {
		showUnitInputError("Could not save file: " + error.message);
	}
}


function readTrainFile(){
	if (unit_maker.cars == null || chosenTrain == null){
		showUnitInputError("Could not load file.");
		return;
	}
	if (chosenTrain == "0"){
		return;
	}

	try {
		var newUnitFile:File = File.documentsDirectory.resolvePath("upRail/units/" + chosenTrain + ".uptrain");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newUnitFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		showPlanInputError("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	unit_title.text = fileLines[0].slice(7);
	unitp_wheel_grip = int(fileLines[1].slice(12));
	unitp_maximum_distance = int(fileLines[2].slice(30));
	unitp_angle_restriction_in = int(fileLines[3].slice(22));
	unitp_angle_restriction_out = int(fileLines[4].slice(23));
	unitp_top_speed_restriction = int(fileLines[5].slice(23));
	unitp_max_up_climb = int(fileLines[6].slice(25));
	unitp_max_down_climb = int(fileLines[7].slice(27));
	var fileCars: int = 0;
	fileCars = int(fileLines[8].slice(6));
	for (var i: int = 0; i < fileCars; i++){
		var nodeLine: Array = fileLines[9 + i].split(' ');
		var readCarMass = int(nodeLine[0]);
		var readCarType = String(nodeLine[1]);
		var readCarTraction = Number(nodeLine[2]);
		var readCarBrake = Number(nodeLine[3]);
		quick_add_new_car(i, readCarMass, readCarType, readCarTraction, readCarBrake);
	}
}