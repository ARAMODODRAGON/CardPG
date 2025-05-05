extends Node
class_name State

## state machine access
func get_statemachine() -> StateMachine:
	return _statemachine

## check if this state is active
func is_active() -> bool:
	return _is_active

## overrideable functions

func _state_enter(last : String) -> void: pass
func _state_exit(next : String) -> void: pass
func _state_process(delta : float) -> void: pass
func _state_physics_process(delta : float) -> void: pass

# private

var _statemachine : StateMachine = null
var _is_active : bool = false

func _ready() -> void:
	var parent := get_parent()
	if parent is StateMachine: _statemachine = parent
