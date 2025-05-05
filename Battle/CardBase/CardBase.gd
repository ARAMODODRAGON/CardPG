extends Control
class_name CardBase

@export var FLIP_SPEED : float = 0.2

@onready var BackFace : TextureRect = $BackFace
@onready var FrontFace : TextureRect = $FrontFace
@onready var Statemachine : StateMachine = $StateMachine

func _enter_tree() -> void:
	BackFace = $BackFace
	FrontFace = $FrontFace
	Statemachine = $StateMachine
	Statemachine.set_next_state("SelectableState")

#@export var FLIP_SPEED : float = 0.2
#var selectable : bool = true:
	#set(v): selectable = v
	#get: return selectable && !_is_flipping
#
#var _flipped : bool = false
#var _is_flipping : bool = false
#var _is_selected : bool = false
#var _mouse_offset : Vector2 = Vector2.ZERO
#var _double_click_timer : float = INF
#
#func is_face_down() -> bool:
	#return _flipped == false
#
#func is_face_up() -> bool:
	#return _flipped == true
#
## returns true on successful flip
#func flip() -> bool:
	#if _is_flipping || _is_selected: return false
	#
	#_is_flipping = true
	#var tween := create_tween()
	#
	#if is_face_down():
		#tween.set_ease(Tween.EASE_OUT)
		#tween.tween_property(BackFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		#tween.set_ease(Tween.EASE_IN)
		#tween.tween_property(FrontFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	#elif is_face_up():
		#tween.set_ease(Tween.EASE_OUT)
		#tween.tween_property(FrontFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		#tween.set_ease(Tween.EASE_IN)
		#tween.tween_property(BackFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	#
	#var end_flip := func() -> void: 
		#_is_flipping = false
		#_flipped = !_flipped
	#
	#tween.tween_callback(end_flip)
	#
	#return true
#
#func _ready() -> void:
	#BackFace.scale.x = 1.0
	#FrontFace.scale.x = 0.0
#
#func _process(delta: float) -> void:
	#if _is_selected:
		#var viewport := get_viewport()
		#var camera := viewport.get_camera_2d()
		#global_position = get_global_mouse_position() + _mouse_offset
	#
	#_double_click_timer += delta
#
#func _on_gui_input(event: InputEvent) -> void:
	#if (event is InputEventMouseButton):
		#if (event.button_index == MOUSE_BUTTON_LEFT) && event.is_pressed():
			#if _double_click_timer < 0.3:
				#_is_selected = false
				#flip()
			#else:
				#_double_click_timer = 0.0
		#
		#if (event.button_index == MOUSE_BUTTON_LEFT) && selectable:
			#if event.is_pressed(): 
				#_mouse_offset = global_position - get_global_mouse_position()
				#_is_selected = true
				#get_parent().move_child(self, -1)
			#else: 
				#_is_selected = false
