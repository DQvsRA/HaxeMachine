package model;

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

class Action {
	public function new() {
	}

	/**
	 * Creates a new action. The action method is optional.
	 * @param fromState State to move form.
	 * @param toState State to move to.
	 * @param name Action's name.
	 * @param action Method to call on performing action.
	 */
	public function Action(fromState:State, toState:State, name:String, action:Void->Void = null)
	{
		fromState = fromState;
		toState = toState;
		name = name;
		action = action;
	}

	private var action(get, default):Void->Void;
	private var fromState:State;
	private var name:String;
	private var toState:State;

	/**
	 * @return The methood to call on preforming the action.
	 */
	public function get_action():Void->Void
	{
		return action;
	}

	/**
	 * @return The state to move from.
	 */
	public function get_fromState():State
	{
		return fromState;
	}

	/**
	 * @return The action's name.
	 */
	public function get_name():String
	{
		return name;
	}

	/**
	 * @return  The state to move to.
	 */
	public function get_toState():State
	{
		return toState;
	}
}
