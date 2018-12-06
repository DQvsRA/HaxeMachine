package ;

import model.Action;
import model.State;

//------------------------------------------------------------------------------
//
// Copyright (c) 2018 Vladimir Cores (Minkin) @ LOGICO Technologies (https://logico.tech)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
//------------------------------------------------------------------------------

class HaxeMachine implements IHaxeMachine {
	public function new() {
	}

	var _actions:Array<Action> = new Array<Action>();
	var _states:Array<State> = new Array<State>();
	var _currentState:State = null;

	/**
	 * Does an action exist in the state machine?
	 * @param action The action in question.
	 * @return True if the action exists, false if it does not.
	 */
	public function actionExists(checkAction:String):Bool {
		return (findAction(checkAction) != null);
	}

	/**
	 * Add a valid link between two states.
	 * The state machine can then move between
	 * @param fromState State you want to move from.
	 * @param toState State you want to move to.
	 * @param action Action that when performed will move from the from state to the to state.
	 * @param handler Optional method that gets called when moving between these two states.
	 * @return true if link was added, false if it was not.
	 */
	public function addAction(fromState:String, toState:String, action:String, handler:Void->Void = null):Bool {
		var from:State;
		var to:State;

		// can't have duplicate actions
		for (check in _actions) {
			if (check.fromState.name == fromState && check.name == action) {
				return false;
			}
		}

		from = findState(fromState);
		if (from == null) {
			addState(fromState);
			from = findState(fromState);
		}

		to = findState(toState);
		if (to == null) {
			addState(toState);
			to = findState(toState);
		}

		_actions.push(new Action(from, to, action, handler));

		return true;
	}


	/**
	 * Adds a new state to the state machine.
	 * @param newState The new state to add.
	 * @return Ture is teh state was added, false if it was not.
	 */
	public function addState(newState:String):Bool {
		// can't have duplicate states
		if (stateExists(newState)) {
			return false;
		}

		_states.push(new State(newState));

		// if no states exist set current state to first state
		if (_states.length == 1) {
			_currentState = _states[0];
		}

		return true;
	}

	/**
	 * Move from the current state to another state.
	 * @param toState New state to try and move to.
	 * @return True if the state machine has moved to this new state, false if it was unable to do so.
	 */
	public function changeState(toState:String):Bool {
		if (!stateExists(toState)) {
			return false;
		}

		for (action in _actions) {
			if (action.fromState == _currentState && action.toState.name == toState) {
				if (action.action != null) {
					action.action();
				}
				_currentState = action.toState;
				return true;
			}
		}

		return false;
	}

	/**
	 * What is the current state?
	 * @return The curent state.
	 */
	public function currentState():String {
		if (_currentState != null) {
			return _currentState.name;
		}
		else {
			return null;
		}
	}

	/**
	 * Change the current state by performing an action.
	 * @param action The action to perform.
	 * @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
	 */
	public function performAction(actionName:String):Bool {
		for (action in _actions) {
			if (action.fromState == _currentState && actionName == action.name) {
				if (action.action != null) {
					action.action();
				}
				_currentState = action.toState;
				return true;
			}
		}

		return false;
	}

	/**
	 * Go back to the initial starting state
	 */
	public function reset():Void {
		if (_states.length > 0) {
			_currentState = _states[0];
		}
		else {
			_currentState = null;
		}
	}

	/**
	 * Does a state exist?
	 * @param state The state in question.
	 * @return True if the state exists, false if it does not.
	 */
	public function stateExists(checkState:String):Bool {
		for (state in _states) {
			if (checkState == state.name) {
				return true;
			}
		}

		return false;
	}

	/**
		 * What are the valid actions you can perform from the current state?
		 * @return An array of actions.
		 */
	public function validActions():Array {
		var actions:Array<Action> = [];
		for (action in _actions) {
			if (action.fromState == _currentState) {
				actions.push(action);
			}
		}

		return actions;
	}

	/**
	 * What are the valid states you can get to from the current state?
	 * @return An array of states.
	 */
	public function validStates():Array {
		var states:Array<State> = [];
		for (action in _actions) {
			if (action.fromState == _currentState) {
				states.push(action.toState);
			}
		}

		return states;
	}

	private function findState(exists:String):State {
		var found:State = null;
		for (state in _states) {
			if (state.name == exists) {
				found = state;
				break;
			}
		}

		return found;
	}

	private function findAction(exists:String):Action {
		var found:Action = null;
		for (action in _actions) {
			if (action.name == exists) {
				found = action;
				break;
			}
		}

		return found;
	}
}

interface IHaxeMachine {

	/**
	 * What is the current state?
	 * @return The current state.
	 */
	function currentState():String;

	/**
	 * Does an action exist in the state machine?
	 * @param action The action in question.
	 * @return True if the action exists, false if it does not.
	 */
	function actionExists(checkAction:String):Bool;

	/**
	 * Add a valid link between two states.
	 * The state machine can then move between
	 * @param fromState State you want to move from.
	 * @param toState State you want to move to.
	 * @param action Action that when performed will move from the from state to the to state.
	 * @param handler Optional method that gets called when moving between these two states.
	 * @return true if link was added, false if it was not.
	 */
	function addAction(fromState:String, toState:String, action:String, handler:Void->Void = null):Bool;

	/**
	 * Adds a new state to the state machine.
	 * @param newState The new state to add.
	 * @return True is teh state was added, false if it was not.
	 */
	function addState(newState:String):Bool;

	/**
	 * Move from the current state to another state.
	 * @param toState New state to try and move to.
	 * @return True if the state machine has moved to this new state, false if it was unable to do so.
	 */
	function changeState(toState:String):Bool;

	/**
	 * Does a state exist?
	 * @param state The state in question.
	 * @return True if the state exists, false if it does not.
	 */
	function stateExists(checkState:String):Bool;

	/**
	 * Change the current state by performing an action.
	 * @param action The action to perform.
	 * @return True if the action was able to be performed and the state machine moved to a new state, false if the action was unable to be performed.
	 */
	function performAction(actionName:String):Bool;

	/**
	 * What are the valid actions you can perform from the current state?
	 * @return An array of actions.
	 */
	function validActions():Array;

	/**
	 * What are the valid states you can get to from the current state?
	 * @return An array of states.
	 */
	function validStates():Array;

	/**
	 * Go back to the initial starting state
	 */
	function reset():Void;
}
