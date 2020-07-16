class Tests extends haxe.unit.TestCase
{
	static function main(){
		var tr = new haxe.unit.TestRunner();
		tr.add(new Tests());
		// add other TestCases here

		// finally, run the tests
		tr.run();
	}

	var STATE_BEGINS:String = "state_begins";

	var STATE_LOADING:String = "state_loading";
	var STATE_LOADING_FAILED:String = "state_loading_failed";
	var STATE_LOADING_COMPLETE:String = "state_loading_complete";

	var STATE_PREPARE_MODEL:String = "state_prepare_model";
	var STATE_PREPARE_CONTROLLER:String = "state_prepare_controller";
	var STATE_PREPARE_VIEW:String = "state_prepare_view";
	var STATE_PREPARE_COMPLETE:String = "state_prepare_complete";
	var STATE_READY:String = "state_ready";

	var ACTION_LOADING_START:String = "action_start_loading";
	var ACTION_LOADING_FAILED:String = "action_loading_failed";
	var ACTION_LOADING_COMPLETE:String = "action_loading_failed";

	var haxeMachine:HaxeMachine;

	override public function setup() {
		haxeMachine = new HaxeMachine();

		haxeMachine.addState( STATE_BEGINS );

		haxeMachine.addState( STATE_LOADING );
		haxeMachine.addState( STATE_LOADING_COMPLETE );
		haxeMachine.addState( STATE_LOADING_FAILED );

		haxeMachine.addState( STATE_PREPARE_MODEL );
		haxeMachine.addState( STATE_PREPARE_CONTROLLER );
		haxeMachine.addState( STATE_PREPARE_VIEW );
		haxeMachine.addState( STATE_PREPARE_COMPLETE );
		haxeMachine.addState( STATE_READY );

		haxeMachine.addAction(
			STATE_BEGINS,
			STATE_LOADING,
			ACTION_LOADING_START,
			function() {
				trace("> STATE_BEGINS transition to: " + haxeMachine.currentState());

				haxeMachine.performAction(
					Math.random() > 0.5
					? ACTION_LOADING_COMPLETE
					: ACTION_LOADING_FAILED
					);
			}
		);

		haxeMachine.addAction( STATE_LOADING, STATE_LOADING_COMPLETE, ACTION_LOADING_COMPLETE, function() print("> STATE_LOADING transition to: " + haxeMachine.currentState()) );
		haxeMachine.addAction( STATE_LOADING, STATE_LOADING_FAILED, ACTION_LOADING_FAILED, function() print("> STATE_LOADING transition to: " + haxeMachine.currentState()) );
	}

	public function testSetup() {
		assertEquals(STATE_BEGINS, haxeMachine.currentState());

		haxeMachine.performAction( ACTION_LOADING_START );
	}

	public function new()
	{
//		test('1) Initial State:', () {
////		});
//
//		test('2) Trying to change state to STATE_LOADING:', () {
//			expect(haxeMachine.changeState( STATE_LOADING ), true);
//		});
//
//		test('3) Current State should be STATE_LOADING:', () {
//			expect( haxeMachine.currentState(), STATE_LOADING );
//		});
	}
}