import flash.events.MouseEvent;
import flash.desktop.NativeApplication;

stop();
stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

ping1.gotoAndStop(2);

var mainDirectory:File = File.documentsDirectory.resolvePath("upRail");
if (!mainDirectory.exists) {
    mainDirectory.createDirectory();
}
var unitsDirectory:File = mainDirectory.resolvePath("units");
var plansDirectory:File = mainDirectory.resolvePath("plans");
if (!unitsDirectory.exists) {
    unitsDirectory.createDirectory();
}
if (!plansDirectory.exists) {
    plansDirectory.createDirectory();
}

function runMock() {
	stage.addEventListener(Event.ENTER_FRAME, title_mock_sim.runMockSimulation);
}
runMock();

function stopMock(){
	stage.removeEventListener(Event.ENTER_FRAME, title_mock_sim.runMockSimulation);
}

title_quit_btn.addEventListener(MouseEvent.CLICK, title_quit);
function title_quit(event: MouseEvent){
	NativeApplication.nativeApplication.exit();
}

title_about_btn.addEventListener(MouseEvent.CLICK, title_go_about);
function title_go_about(event: MouseEvent){
	gotoAndStop(2);
}

title_help_btn.addEventListener(MouseEvent.CLICK, title_go_help);
function title_go_help(event: MouseEvent){
	gotoAndStop(3);
}

title_settings_btn.addEventListener(MouseEvent.CLICK, title_go_settings);
function title_go_settings(event: MouseEvent){
	gotoAndStop(4);
}

title_plans_btn.addEventListener(MouseEvent.CLICK, title_go_plans);
function title_go_plans(event: MouseEvent){
	gotoAndStop(5);
}

title_units_btn.addEventListener(MouseEvent.CLICK, title_go_units);
function title_go_units(event: MouseEvent){
	gotoAndStop(7);
}

title_runsim_btn.addEventListener(MouseEvent.CLICK, title_go_sim);
function title_go_sim(event: MouseEvent){
	gotoAndStop(9);
}

function return_to_title(event: MouseEvent){
	gotoAndStop(1);
}