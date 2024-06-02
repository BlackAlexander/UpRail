stop();

if (selectedUnit == "0" || selectedPlan == "0"){
	gotoAndStop(9);
}

inspect_back_btn.addEventListener(MouseEvent.CLICK, return_to_component_selector);
function return_to_component_selector(event: MouseEvent){
	gotoAndStop(9);
}

inspection_front_btn.visible = false;
inspection_btn_text.visible = false;

inspection_front_btn.addEventListener(MouseEvent.CLICK, inspection_proceed);
function inspection_proceed(event: MouseEvent){
	gotoAndStop(10);
}

inspection_status.text = "Loading...";

var t1_plan_length: Number = 0;			
var t1_max_length: Number = 0;			

var t2_mass_limit: int = 0;				
var t2_unit_mass: int = 0;				

var t3_steepest_up_climb: int = 0;		
var t3_max_climb_angle_up: int = 0;		

var t4_steepest_down_climb: int = 0;	
var t4_max_climb_angle_down: int = 0;	

var t5_narrow_angle_in: int = 0;		
var t5_max_angle_in: int = 0;			

var t6_narrow_angle_out: int = 0;		
var t6_max_angle_out: int = 0;			

var inspectionPlan: Array = new Array();
var inspectionUnit: Array = new Array();

var restrictionsGoodToGo: Boolean = true;

function read_inspection_plan(){
	if (selectedPlan == "0"){
		return;
	}
	try {
		var newPlanFile:File = File.documentsDirectory.resolvePath("upRail/plans/" + selectedPlan + ".upmap");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newPlanFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		trace("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	inspection_plan_title.text = fileLines[0].slice(7);
	t2_mass_limit = int(fileLines[1].slice(6));
	var readNodesCount: int = 0;
	readNodesCount = int(fileLines[2].slice(7));
	for (var nodeIndexCount: int = 0; nodeIndexCount < readNodesCount; nodeIndexCount++){
		var nodeLine: Array = fileLines[3 + nodeIndexCount].split(' ');
		var readNodeX = int(nodeLine[0]);
		var readNodeY = int(nodeLine[1]);
		inspectionPlan.push([readNodeX, readNodeY]);
	}
}

function read_inspection_unit(){
	if (selectedUnit == "0"){
		return;
	}

	try {
		var newUnitFile:File = File.documentsDirectory.resolvePath("upRail/units/" + selectedUnit + ".uptrain");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newUnitFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		trace("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	inspection_unit_title.text = fileLines[0].slice(7);
	t1_max_length = int(fileLines[2].slice(30));
	t5_max_angle_in = int(fileLines[3].slice(22));
	t6_max_angle_out = int(fileLines[4].slice(23));
	t3_max_climb_angle_up = int(fileLines[6].slice(25));
	t4_max_climb_angle_down = int(fileLines[7].slice(27));
	var fileCars: int = 0;
	fileCars = int(fileLines[8].slice(6));
	var totalMass: int = 0;
	for (var i: int = 0; i < fileCars; i++){
		var nodeLine: Array = fileLines[9 + i].split(' ');
		var readCarMass = int(nodeLine[0]);
		var readCarType = String(nodeLine[1]);
		var readCarTraction = Number(nodeLine[2]);
		var readCarBrake = Number(nodeLine[3]);
		inspectionUnit.push([readCarMass, readCarType, readCarTraction, readCarBrake]);
		totalMass += readCarMass;
	}
	t2_unit_mass = totalMass;
}

function compute_inspection_plan_length(){
	var fullTrack = inspectionPlan;
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
	t1_plan_length = finalSum;
}

function compute_inspection_steepest_up_climb(){
	var fullTrack = inspectionPlan;
	var highest: Number = -50000;
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
	if (highest < 0){
		highest = 0;
	}
	t3_steepest_up_climb = highest;
}

function compute_inspection_steepest_down_climb(){
	var fullTrack = inspectionPlan;
	var highest: Number = 50000;
	for (var i: int = 0; i < fullTrack.length - 1; i++){
		var segmentClimb: Number;
		var xa: Number = fullTrack[i][0];
		var xb: Number = fullTrack[i + 1][0];
		var ya: Number = fullTrack[i][1];
		var yb: Number = fullTrack[i + 1][1];
		segmentClimb = (yb-ya)/(xb-xa)*100;
		if (segmentClimb < highest){
			highest = segmentClimb;
		}
	}
	if (highest > 0){
		highest = 0;
	}
	t4_steepest_down_climb = Math.abs(highest);
}

function compute_inspection_narrowest_angle_in(){
	var fullTrack = inspectionPlan;
	if (fullTrack.length <= 2){
		t5_narrow_angle_in = 180;
		return;
	}
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
	t5_narrow_angle_in = int(narrowest);
}

function compute_inspection_narrowest_angle_out(){
	var fullTrack = inspectionPlan;
	if (fullTrack.length <= 2){
		t6_narrow_angle_out = 180;
		return;
	}
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
	t6_narrow_angle_out = int(Math.abs(narrowest));
}

function fill_text(){
	plan_t1.text = String(t1_plan_length) + "m";
	unit_t1.text = String(t1_max_length) + "m";
	plan_t2.text = String(t2_mass_limit) + "kg";
	unit_t2.text = String(t2_unit_mass) + "kg";
	plan_t3.text = String(t3_steepest_up_climb) + "%";
	unit_t3.text = String(t3_max_climb_angle_up) + "%";
	plan_t4.text = String(t4_steepest_down_climb) + "%";
	unit_t4.text = String(t4_max_climb_angle_down) + "%";
	plan_t5.text = String(t5_narrow_angle_in) + "°";
	unit_t5.text = String(t5_max_angle_in) + "°";
	plan_t6.text = String(t6_narrow_angle_out) + "°";
	unit_t6.text = String(t6_max_angle_out) + "°";
	if (t1_max_length == 0){
		unit_t1.text = "∞";
	}
	if (t2_mass_limit == 0){
		plan_t2.text = "∞";
	}
	if (t3_max_climb_angle_up == 0){
		unit_t3.text = "∞";
	}
	if (t4_max_climb_angle_down == 0){
		unit_t4.text = "∞";
	}
	if (t5_max_angle_in == 0){
		unit_t5.text = "∞";
	}
	if (t6_max_angle_out == 0){
		unit_t6.text = "∞";
	}
	if (t1_plan_length > t1_max_length && t1_max_length != 0){
		restrictionsGoodToGo = false;
		plan_t1.textColor = 0xFF0000; 
		unit_t1.textColor = 0xFF0000; 
	} else {
		plan_t1.textColor = 0x00A000; 
		unit_t1.textColor = 0x00A000; 
	}
	if (t2_unit_mass > t2_mass_limit && t2_mass_limit != 0){
		restrictionsGoodToGo = false;
		plan_t2.textColor = 0xFF0000; 
		unit_t2.textColor = 0xFF0000; 
	} else {
		plan_t2.textColor = 0x00A000; 
		unit_t2.textColor = 0x00A000; 
	}
	if (t3_steepest_up_climb > t3_max_climb_angle_up && t3_max_climb_angle_up != 0){
		restrictionsGoodToGo = false;
		plan_t3.textColor = 0xFF0000; 
		unit_t3.textColor = 0xFF0000; 
	} else {
		plan_t3.textColor = 0x00A000; 
		unit_t3.textColor = 0x00A000; 
	}
	if (t4_steepest_down_climb > t4_max_climb_angle_down && t4_max_climb_angle_down != 0){
		restrictionsGoodToGo = false;
		plan_t4.textColor = 0xFF0000; 
		unit_t4.textColor = 0xFF0000; 
	} else {
		plan_t4.textColor = 0x00A000; 
		unit_t4.textColor = 0x00A000; 
	}
	if (t5_narrow_angle_in < t5_max_angle_in && t5_max_angle_in != 0){
		restrictionsGoodToGo = false;
		plan_t5.textColor = 0xFF0000; 
		unit_t5.textColor = 0xFF0000; 
	} else {
		plan_t5.textColor = 0x00A000; 
		unit_t5.textColor = 0x00A000; 
	}
	if (t6_narrow_angle_out < t6_max_angle_out && t6_max_angle_out != 0){
		restrictionsGoodToGo = false;
		plan_t6.textColor = 0xFF0000; 
		unit_t6.textColor = 0xFF0000; 
	} else {
		plan_t6.textColor = 0x00A000; 
		unit_t6.textColor = 0x00A000; 
	}
	if (restrictionsGoodToGo){
		inspection_status.text = "Simulation components are compatible";
		inspection_front_btn.visible = true;
		inspection_btn_text.visible = true;
	} else {
		inspection_status.text = "Simulation components are not compatible";
		inspection_front_btn.visible = false;
		inspection_btn_text.visible = false;
	}
}

function runInspection(){
	read_inspection_plan();
	read_inspection_unit();
	compute_inspection_plan_length();
	compute_inspection_steepest_up_climb();
	compute_inspection_steepest_down_climb();
	compute_inspection_narrowest_angle_in();
	compute_inspection_narrowest_angle_out();
	fill_text();
}

runInspection();