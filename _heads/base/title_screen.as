import flash.events.MouseEvent;
import flash.desktop.NativeApplication;

stop();
stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE; // REMOVE IN RELEASE

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

function return_to_title(event: MouseEvent){
	gotoAndStop(1);
}