import flash.display.MovieClip;
import flash.display.Shape;

stop();

var segmentThickness: Number = 1;

var track: Array = new Array();
var paintedSegments: Array = new Array();
var paintedNodes: Array = new Array();
var paintedFill: Array = new Array();

function add_node(nodeX: int, nodeY: int){
	if (nodeX < 0 || nodeX > 1000){
		return;
	}
	if (nodeY < 0 || nodeY >= 500){
		return;
	}
    var newNode: Array = [nodeX, nodeY];
    var low: int = 0;
    var high: int = track.length - 1;
    var mid: int;

    while (low <= high) {
        mid = Math.floor((low + high) / 2);
        
        if (track[mid][0] == nodeX) {
            track[mid][1] = nodeY;
            return;
        } else if (track[mid][0] < nodeX) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
	track.insertAt(low, newNode);
}

function remove_node(nodeX: int): void {
    var low: int = 0;
    var high: int = track.length - 1;
    var mid: int;
	
    while (low <= high) {
        mid = Math.floor((low + high) / 2);
        
        if (track[mid][0] == nodeX) {
            track.splice(mid, 1);
            return;
        } else if (track[mid][0] < nodeX) {
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }
}

add_node(0, 0);
add_node(1000, 0);

function set_start_height(nodeY: int){
	add_node(0, nodeY);
}

function set_end_height(nodeY: int){
	add_node(1000, nodeY);
}

function trace_track_values(){
	for (var i: int = 0; i < track.length; i++) {
		trace(track[i][0] + ", " + track[i][1]);
	}
}

function paint_fill(){
	var filling: Shape = new Shape();
	var matrix:Matrix = new Matrix();
	matrix.scale(0.1, 0.1);
	filling.graphics.beginBitmapFill(new TrackMap(), matrix, true, true);
	filling.graphics.moveTo(0, 500);
	for (var i: int = 0; i < track.length; i++){
		filling.graphics.lineTo(track[i][0], 500 - track[i][1]);
	}
	filling.graphics.lineTo(1000, 500);
	filling.graphics.endFill();
	filling.alpha = 0.5;
	addChild(filling);
	paintedFill.push(filling);
}

function paint_segments(){
	paint_fill();
	for (var i: int = 0; i < track.length - 1; i++){
		var newSegment: MovieClip = new MovieClip();
		newSegment.graphics.lineStyle(segmentThickness, 0x000000);
		newSegment.graphics.moveTo(track[i][0], 500 - track[i][1]);
		newSegment.graphics.lineTo(track[i+1][0], 500 - track[i+1][1]);
		addChild(newSegment);
		paintedSegments.push(newSegment);
	}
}

function clear_paint(){
	if (paintedFill.length > 0){
		removeChild(paintedFill[0]);
	}
	paintedFill = [];
	for (var i: int = 0; i < paintedSegments.length; i++){
		removeChild(paintedSegments[i]);
	}
	paintedSegments = [];
}

function show_node_buttons(){
	for (var i: int = 0; i < track.length; i++){
		var newNode = new plan_node;
		this.addChild(newNode);
		newNode.x = track[i][0];
		newNode.y = 500 - track[i][1];
		paintedNodes.push(newNode);
	}
}

function hide_node_buttons(){
	for (var i: int = 0; i < paintedNodes.length; i++){
		removeChild(paintedNodes[i]);
	}
	paintedNodes = [];
}


function update_plan(){
	hide_node_buttons();
	clear_paint();
	paint_segments();
}

set_start_height(50);
set_end_height(50);
update_plan();

MovieClip(root).maker();