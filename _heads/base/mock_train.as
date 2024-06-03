import flash.display.MovieClip;

var segments: Array = new Array();
var segmentInterval: Number = 5;
var segmentThickness: Number = 1;
var slopeDifussion: Number = 0.3;
var rigidWidth = 500;
var rigidHeight = 180;
var lastHeight: Number = rigidHeight;
var beforeLastHeight: Number = rigidHeight;
var segmentCount = int(rigidWidth/segmentInterval);

function getNewHeight(){
	var newValue: Number = (Math.random() * 2 * slopeDifussion) - slopeDifussion;
	var newHeight: Number = lastHeight*2 - beforeLastHeight + newValue;
	if (newHeight > rigidHeight - 5) {
		return lastHeight - slopeDifussion;
		}
	if (newHeight < 5) {
		return lastHeight + slopeDifussion;
		}
	return newHeight;
}

function baseSegments() {
	for (var i: int = 0; i < segmentCount; i++){
		var newLine: MovieClip = new MovieClip();
		newLine.graphics.lineStyle(segmentThickness, 0x000000);
		newLine.graphics.moveTo(i*segmentInterval, rigidHeight);
		newLine.graphics.lineTo((i+1)*segmentInterval, rigidHeight);
		addChild(newLine);
		var newSegment: Array = new Array();
		newSegment.push(newLine);
		newSegment.push(rigidHeight);
		newSegment.push(rigidHeight);
		segments.push(newSegment);
	}
}
baseSegments();

function addSegment(nextHeight: Number) {
	var leftHeight: Number = lastHeight;
	var rightHeight: Number = nextHeight;
	var newSegment: Array = new Array();
	var theNewLine: MovieClip = new MovieClip();
	theNewLine.graphics.lineStyle(segmentThickness, 0x000000);
	theNewLine.graphics.moveTo(rigidWidth - segmentInterval, leftHeight);
	theNewLine.graphics.lineTo(rigidWidth, rightHeight);
	//line.name = "";
	addChild(theNewLine);
	
	newSegment.push(theNewLine);
	newSegment.push(leftHeight);
	newSegment.push(rightHeight);
	segments[segmentCount - 1] = newSegment;
	
	beforeLastHeight = lastHeight;
	lastHeight = nextHeight;
}

function shiftSegments(){
	removeChild(segments[0][0]);
	for (var i: int = 0; i < segmentCount - 1; i++){
		segments[i] = segments[i + 1];
		segments[i][0].x -= segmentInterval;
	}
}

//for (var i: int = 0; i < segmentCount; i++){
//	trace(i, segments[i]);
//}

var carWheels: Array = [
    [21, 27],
    [31, 38],
    [42, 47],
    [52, 57],
    [62, 68],
    [72, 78]
];

function placeCars(){
	for (var i:int = 0; i < 6; i++){
		var car = getChildByName("mock_car" + String(i));
		var carLeftIndex = carWheels[i][0];
		var carRightIndex = carWheels[i][1];
		var left_x: Number;
		var left_y: Number;
		var right_x: Number;
		var right_y: Number;
		var verticalCenter: Number;
		left_x = carLeftIndex * segmentInterval;
		right_x = carRightIndex * segmentInterval;
		left_y = segments[carLeftIndex][1];
		right_y = segments[carRightIndex][2];
		verticalCenter = (left_y + right_y) / 2;
		car.y = verticalCenter - 10;
		var carSlope: Number = Math.atan2(right_y - left_y, right_x - left_x);
		//carSlope += Math.PI / 2;
		car.rotation = carSlope * 180 / Math.PI;
	}
}
placeCars();

function proceed() {
	shiftSegments();
	addSegment(getNewHeight());
	placeCars();
}

function runMockSimulation(e: Event) {
	proceed();
}

function runMock() {
	stage.addEventListener(Event.ENTER_FRAME, runMockSimulation);
}
runMock();

function stopMock(){
	stage.removeEventListener(Event.ENTER_FRAME, runMockSimulation);
}