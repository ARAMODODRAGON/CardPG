extends State

@onready var Card : CardBase = owner as CardBase

var _mouse_offset : Vector2 = Vector2.ZERO
var _is_selected : bool = false
var _double_click_timer : float = INF

func _state_enter(last : String) -> void: 
	_mouse_offset = Vector2.ZERO
	_is_selected = false
	_double_click_timer = INF
func _state_exit(next : String) -> void: 
	_mouse_offset = Vector2.ZERO
	_is_selected = false

func _state_process(delta : float) -> void: 
	if _is_selected:
		#var viewport := get_viewport()
		#var camera := viewport.get_camera_2d()
		Card.global_position = Card.get_global_mouse_position() + _mouse_offset
	_double_click_timer += delta

func _on_card_base_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT) && event.is_pressed():
			if _double_click_timer < 0.3:
				_is_selected = false
				get_statemachine().set_next_state("FlippingState")
			else:
				_double_click_timer = 0.0#
		
		if (event.button_index == MOUSE_BUTTON_LEFT):
			if event.is_pressed(): 
				_mouse_offset = Card.global_position - Card.get_global_mouse_position()
				_is_selected = true
				get_parent().move_child(self, -1)
			else: 
				_is_selected = false
