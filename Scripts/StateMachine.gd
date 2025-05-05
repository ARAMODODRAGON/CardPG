extends Node
class_name StateMachine

## returns the active state's name
func get_active_state() -> String:
	if _active_state: 
		return _active_state.name
	return ""

## sets the next state and returns true on success
func set_next_state(name_ : String) -> bool:
	_next_state = _states.get(name_)
	return _next_state != null

## gets the state by name
func get_state(name_ : String) -> State:
	return _states[name_]

var _next_state : State = null
var _active_state : State = null
var _states : Dictionary[String, State]

func _ready() -> void:
	for child in get_children():
		if child is State:
			if _active_state == null: 
				_active_state = child
			_states[child.name] = child
	
	if _active_state: _active_state._state_enter("")

func _update_state() -> void:
	if _next_state == null:
		return
	
	var first : State = _active_state
	var second : State = _next_state
	
	first._state_exit(second.name)
	first._is_active = false
	second._state_enter(first.name)
	second._is_active = true
	_active_state = second
	_next_state = null

func _process(delta: float) -> void:
	_update_state()
	if _active_state: 
		_active_state._state_process(delta)

func _physics_process(delta: float) -> void:
	_update_state()
	if _active_state: 
		_active_state._state_physics_process(delta)
