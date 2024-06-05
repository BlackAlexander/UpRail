stop();

if (selectedUnit == "0" || selectedPlan == "0"){
	gotoAndStop(9);
}

var simulationPlan: Array = new Array();
var simulationUnit: Array = new Array();

var simulationData: Array = new Array();
// [position, AB, acceleration, speed]

var simCarLength: Number = 20;
var simCarCenter: Number = simCarLength/2;
var simCarSpace: Number = 2;
var simCarUnit: Number = simCarLength + simCarSpace;
var simCarWheelFront: Number = 3.7;
var simCarWheelRear: Number = 16.3;
var simCarHeight: Number = 10;

var auxiliaryData: Array = new Array();

var simMapUT: Array = new Array();
var simMapUF: Array = new Array();
var simMapMaxSpeed: Array = new Array();
var simMapMinSpeed: Array = new Array();

var currentSimulationState = "start";
// start
// during
// end

var unitChildren: Array = new Array();

var startTime: int = getTimer();

simulation_title.text = "running " + String(selectedUnit) + " on " + String(selectedPlan);

simulation_back_btn.addEventListener(MouseEvent.CLICK, simulation_back);
function simulation_back(event: MouseEvent){
	stopSimulation();
	gotoAndStop(9);
}

simulation_front_btn.addEventListener(MouseEvent.CLICK, simulation_proceed);
function simulation_proceed(event: MouseEvent){
	if (currentSimulationState == "start"){
		currentSimulationState = "during";
		startTime = getTimer();
		startSimulation();
		simulation_front_btn.visible = false;
	} else if (currentSimulationState == "during"){
		currentSimulationState = "end";
	} else if (currentSimulationState == "end"){
		stopSimulation();
		gotoAndStop(1);  // change to 12 when making results page
	}
}

function readSimulationUnit(){
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
	var fileCars: int = int(fileLines[8].slice(6));
	for (var i: int = 0; i < fileCars; i++){
		var nodeLine: Array = fileLines[9 + i].split(' ');
		var readCarMass = int(nodeLine[0]);
		var readCarType = String(nodeLine[1]);
		var readCarTraction = Number(nodeLine[2]);
		var readCarBrake = Number(nodeLine[3]);
		simulationUnit.push(readCarType);
	}
}

function readSimulationPlan(){
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
	var readNodesCount: int = 0;
	readNodesCount = int(fileLines[2].slice(7));
	for (var nodeIndexCount: int = 0; nodeIndexCount < readNodesCount; nodeIndexCount++){
		var nodeLine: Array = fileLines[3 + nodeIndexCount].split(' ');
		var readNodeX = int(nodeLine[0]);
		var readNodeY = int(nodeLine[1]);
		simulationPlan.push([readNodeX, readNodeY]);
	}
}

function readSimulationData(){
	try {
		var newFile:File = File.documentsDirectory.resolvePath("upRail/SIM.uprail");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		trace("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	var readKeyCount: int = 0;
	readKeyCount = int(fileLines[0]);
	for (var keyIndex: int = 0; keyIndex < readKeyCount; keyIndex++){
		var simLine: Array = fileLines[1 + keyIndex].split(' ');
		var simTime = int(simLine[0]);
		var simPosition = Number(simLine[1]);
		if (simPosition > 1000){
			simPosition = 1000;
		}
		var simAB = int(simLine[2]);
		var simAcceleration = Number(simLine[3]);
		var simSpeed = Number(simLine[4]);
		simulationData.push([simPosition, simAB, simAcceleration, simSpeed]);
	}
}

function readSimulationMap(){
	try {
		var newFile:File = File.documentsDirectory.resolvePath("upRail/MAP.uprail");
		var fileStream:FileStream = new FileStream();
		fileStream.open(newFile, FileMode.READ);
		var fileContent:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
		fileStream.close();
	} catch (error:Error){
		trace("Could not read file: " + error.message);
		return;
	}
	var fileLines: Array = fileContent.split(/\n/);
	var linesUT = fileLines[0].split(' ');
	var linesUF = fileLines[1].split(' ');
	var linesMaxSpeed = fileLines[2].split(' ');
	var linesMinSpeed = fileLines[3].split(' ');
	for (var i: int = 0; i <= 1000; i++){
		simMapUT.push(linesUT[i]);
		simMapUF.push(linesUF[i]);
		simMapMaxSpeed.push(linesMaxSpeed[i]);
		simMapMinSpeed.push(linesMinSpeed[i]);
	}
}

function clearSimulationUnit(){
	for (var i: int = 0; i < unitChildren.length; i++){
		simScreen.removeChild(unitChildren[i]);
	}
	unitChildren = [];
}

function paintSimulationUnit(trainHeadX){
	clearSimulationUnit();
	var trainHeadY: Number = auxiliaryData[int(trainHeadX)][1];
	var currentCarCenter = computeWalkOnTrack(simCarCenter, trainHeadX, trainHeadY);
	var carCenterX = currentCarCenter[0];
	var carCenterY = currentCarCenter[1];
	var i: int = 0;
	for (i = 0; i < simulationUnit.length; i++){
		var carType: String = simulationUnit[i];
		var newCar = new simulator_car;
		var newCarAngle = auxiliaryData[int(carCenterX)][4] * (180 / Math.PI);
		var newCarAngleR = auxiliaryData[int(carCenterX)][4];
		simScreen.addChild(newCar);
		unitChildren.push(newCar);
		newCar.scaleX = 0.2;
		newCar.scaleY = 0.2;
		newCar.x = carCenterX - Math.sin(Math.PI - newCarAngleR)*(simCarHeight/2);
		newCar.y = 550 - (carCenterY - Math.cos(Math.PI - newCarAngleR)*(simCarHeight/2));
		newCar.rotation = 360 - newCarAngle;
		if (carType == "engine"){
			newCar.gotoAndStop(1);
		} else {
			newCar.gotoAndStop(2);
		}
		if (i + 1 < simulationUnit.length){
			currentCarCenter = computeWalkOnTrack(simCarUnit, carCenterX, carCenterY);
			carCenterX = currentCarCenter[0];
			carCenterY = currentCarCenter[1];
		}
	}
}

function paintSimulationPlan(){
	var filling: Shape = new Shape();
	var matrix: Matrix = new Matrix();
	matrix.scale(0.1, 0.1);
	simScreen.addChild(filling);
	filling.graphics.beginBitmapFill(new TrackMap(), matrix, true, true);
	filling.graphics.moveTo(0, 550);
	for (var i: int = 0; i < simulationPlan.length; i++){
		filling.graphics.lineTo(simulationPlan[i][0], 550 - simulationPlan[i][1]);
	}
	filling.graphics.lineTo(1000, 550);
	filling.graphics.endFill();
	filling.alpha = 0.5;
	for (var j: int = 0; j < simulationPlan.length - 1; j++){
		var newSegment: MovieClip = new MovieClip();
		simScreen.addChild(newSegment);
		newSegment.graphics.lineStyle(1, 0x000000);
		newSegment.graphics.moveTo(simulationPlan[j][0], 550 - simulationPlan[j][1]);
		newSegment.graphics.lineTo(simulationPlan[j+1][0], 550 - simulationPlan[j+1][1]);
	}
}

function setAcceleration(acceleration: int){
	var currentForce: int = simulation_force.currentFrame - 101;
	var newForce: int = int((acceleration * 50 + currentForce * 50) / 100);
	if (newForce == 99){
		newForce = 100;
	}
	if (newForce == -99){
		newForce = -100;
	}
	simulation_force.gotoAndStop(newForce + 101);
}
simulation_force.gotoAndStop(101);

function setTimeSim(minutes: int, seconds: int){
	minutes = minutes % 100;
	var min_string: String = String(minutes);
	var sec_string: String = String(seconds);
	if (minutes < 10){
		min_string = "0" + min_string;
	}
	if (seconds < 10){
		sec_string = "0" + sec_string;
	}
	simulation_time_elapsed.text = min_string + ":" + sec_string; 
}

function setProgress(progress: int){
	if (progress == 0) {
		progress = 1;
	}
	simulation_progress.gotoAndStop(progress);
}
setProgress(1);

function setSimulationDistance(simulationDistance: Number){
	simulation_distance.text = String(int(simulationDistance)) + "m";
}

function setSimulationSpeed(simulationSpeed: Number){
	simulation_speed.text = String(simulationSpeed.toFixed(1)) + "m/s";
}

function setSimulationAcceleration(simulationAcceleration: Number){
	simulation_acceleration.text = String(simulationAcceleration.toFixed(1)) + "m/s²";
}

function setSimulationAngle(simulationAngle: int){
	simulation_angle.text = String(simulationAngle) + "°";
}

function setSimulationMap(ut: int, uf: int, maxspeed:int, minspeed: int){
	sim_field_traction.text = String(ut);
	sim_field_friction.text = String(uf);
	sim_field_min_speed.text = String(minspeed);
	sim_field_max_speed.text = String(maxspeed);
	if (maxspeed == 9999){
		sim_field_max_speed.text = "∞";
	}
}
setSimulationMap(0, 0, 9999, 0);

function computeAuxiliaryData(){
	// [isNode, y, leftNode[i,x,y], rightNode[i,x,y], angle]
	//     0    1       2                3              4
	var i: int = 0;
	
	// fill Array
	for (i = 0; i <= 1000; i++){
		auxiliaryData.push([false, 0, [0, 0], [0, 0], 0])
	}

	auxiliaryData[0][0] = true;
	auxiliaryData[0][1] = simulationPlan[0][1];
	auxiliaryData[0][2] = null;
	auxiliaryData[0][3] = [1, simulationPlan[1][0], simulationPlan[1][1]];
	auxiliaryData[0][4] = 0;

	auxiliaryData[1000][0] = true;
	auxiliaryData[1000][1] = simulationPlan[simulationPlan.length - 1][1];
	auxiliaryData[1000][2] = [simulationPlan.length - 2, simulationPlan[simulationPlan.length - 2][0], simulationPlan[simulationPlan.length - 2][1]];
	auxiliaryData[1000][3] = null;
	auxiliaryData[1000][4] = 0;

	// fill leftNode, rightNode and isNode
	var lastAuxNode: int = 0;
	var nextAuxNode: int = 1;
	for (i = 1; i <= 999; i++){
		var currentLeftNode: Array = [0, 0, 0];
		currentLeftNode[0] = lastAuxNode;
		currentLeftNode[1] = simulationPlan[lastAuxNode][0];
		currentLeftNode[2] = simulationPlan[lastAuxNode][1];
		auxiliaryData[i][2] = currentLeftNode;
		
		if (simulationPlan[nextAuxNode][0] == i){
			auxiliaryData[i][0] = true;
			auxiliaryData[i][1] = simulationPlan[nextAuxNode][1];
			lastAuxNode++;
			nextAuxNode++;
		} else {
			auxiliaryData[i][0] = false;
		}
		
		var currentRightNode: Array = [0, 0, 0];
		currentRightNode[0] = nextAuxNode;
		currentRightNode[1] = simulationPlan[nextAuxNode][0];
		currentRightNode[2] = simulationPlan[nextAuxNode][1];
		auxiliaryData[i][2] = currentLeftNode;
		auxiliaryData[i][3] = currentRightNode;
	}
	
	// fill y
	for (i = 1; i <= 999; i++){
		if (!auxiliaryData[i][0]){
			var aauxLeftX: Number = auxiliaryData[i][2][1];
			var aauxLeftY: Number = auxiliaryData[i][2][2];
			var aauxRightX: Number = auxiliaryData[i][3][1];
			var aauxRightY: Number = auxiliaryData[i][3][2];
			var aauxCurrentX: Number = i;
			var t: Number = (aauxCurrentX - aauxLeftX) / (aauxRightX - aauxLeftX);
			var aauxCurrentY:Number = aauxLeftY + t * (aauxRightY - aauxLeftY);
			auxiliaryData[i][1] = aauxCurrentY;
		}
	}

	// fill angle
	for (i = 1; i <= 999; i++){
		var auxLeftX: Number = i - 1;
		var auxLeftY: Number = auxiliaryData[i - 1][1];
		var auxRightX: Number = i + 1;
		var auxRightY: Number = auxiliaryData[i + 1][1];
		auxiliaryData[i][4] = Math.atan2((auxRightY - auxLeftY) , (auxRightX - auxLeftX));
	}
}

function computeDistanceProjection(D: Number, xA: Number, yA: Number, xB: Number, yB: Number){
    var distanceAB: Number = Math.sqrt(Math.pow(xB - xA, 2) + Math.pow(yB - yA, 2));
    var r: Number = D / distanceAB;
    var xN: Number = xA + r * (xB - xA);
    var yN: Number = yA + r * (yB - yA);
    return [xN, yN];
}

function computeDistanceTP(xA: Number, yA: Number, xB: Number, yB: Number){
	var distanceAB: Number = Math.sqrt(Math.pow(xB - xA, 2) + Math.pow(yB - yA, 2));
	return distanceAB;
}

function computeWalkOnTrack(Dist: Number, xA: Number, yA: Number){
	var leftNode: Array = auxiliaryData[int(xA)][2];
	var leftNodeX: Number = leftNode[1];
	var leftNodeY: Number = leftNode[2];
	var leftDistance: Number = Dist;
	while (leftDistance > 0){
		var toNode: Number = computeDistanceTP(xA, yA, leftNodeX, leftNodeY);
		if (leftDistance <= toNode){
			return computeDistanceProjection(leftDistance, xA, yA, leftNodeX, leftNodeY);
		} else {
			leftDistance -= toNode;
			xA = leftNodeX;
			yA = leftNodeY;
			leftNode = auxiliaryData[int(xA)][2];
			leftNodeX = leftNode[1];
			leftNodeY = leftNode[2];
			if (xA == 0){
				return [leftNodeX, leftNodeY];
			}
		}
	}
}

function extrapolateData(leftValue: Number, rightValue: Number, timems: int){
	var result: Number;
	timems = timems%1000;
	result = leftValue + (rightValue - leftValue) * (Number(timems) / 1000);
	return result;
}

function executeKey(){
	if (currentSimulationState != "during"){
		return;
	}
	
	var currentTime: int = getTimer();
	var timems: int = currentTime - startTime;
	var timeS: int = timems/1000;
	var nextS: int = timeS + 1;

	
	if (nextS >= simulationData.length){
		currentSimulationState = "end"
		simulation_front_btn.visible = true;
		stopSimulation();
		return;
	}

	if (nextS == simulationData.length){
		nextS = timeS;
	}

	var keyLine = simulationData[timeS];
	var keyLineN = simulationData[nextS];

	var simKDistance: Number;
	var simKAB: int;
	var simKSpeed: Number;
	var simKAcceleration: Number;
	var simKAngle: int;
	var simKProgress: int;
	var simKSeconds: int;
	var simKMinutes: int;
	var simKUt: int;
	var simKUf: int;
	var simKMaxSpeed: int;
	var simKMinSpeed: int;
	simKSeconds = timems / 1000;
	simKMinutes = simKSeconds / 60;
	simKSeconds = simKSeconds % 60;
	
	simKDistance = extrapolateData(keyLine[0], keyLineN[0], timems);
	simKAB = int(extrapolateData(keyLine[1], keyLineN[1], timems)); 
	simKAcceleration = extrapolateData(keyLine[2], keyLineN[2], timems); 
	simKSpeed = extrapolateData(keyLine[3], keyLineN[3], timems);
	simKProgress = int(Math.ceil((timeS / simulationData.length)*100));
	simKUt = simMapUT[int(keyLine[0])];
	simKUf = simMapUF[int(keyLine[0])];
	simKMaxSpeed = simMapMaxSpeed[int(keyLine[0])];
	simKMinSpeed = simMapMinSpeed[int(keyLine[0])];
	
	setAcceleration(simKAB);
	setSimulationDistance(simKDistance);
	setSimulationSpeed(simKSpeed);
	setSimulationAcceleration(simKAcceleration);
	setProgress(simKProgress);
	setTimeSim(simKMinutes, simKSeconds);

	var simKAngleL: Number = auxiliaryData[int(keyLine[0])][4] * (180 / Math.PI);
	var simKAngleR: Number = auxiliaryData[int(keyLineN[0])][4] * (180 / Math.PI);
	simKAngle = int(extrapolateData(simKAngleL, simKAngleR, timems));
	setSimulationAngle(simKAngle);
	
	setSimulationMap(simKUt, simKUf, simKMaxSpeed, simKMinSpeed);

	paintSimulationUnit(simKDistance);
}

readSimulationUnit();
readSimulationPlan();
readSimulationData();
readSimulationMap();
computeAuxiliaryData();
paintSimulationPlan();
paintSimulationUnit(simulationData[0][0]);

function runSimulation(e: Event) {
	executeKey();
}

function startSimulation() {
	stage.addEventListener(Event.ENTER_FRAME, runSimulation);
}

function stopSimulation(){
	stage.removeEventListener(Event.ENTER_FRAME, runSimulation);
}