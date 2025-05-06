extends Control
class_name CardBase

@export var FLIP_SPEED : float = 0.2

@onready var BackFace : TextureRect = $BackFace
@onready var FrontFace : TextureRect = $FrontFace
@onready var Statemachine : StateMachine = $StateMachine

func _ready() -> void:
	BackFace = $BackFace
	FrontFace = $FrontFace
	BackFace.scale.x = 1.0
	FrontFace.scale.x = 0.0
	Statemachine = $StateMachine
	Statemachine.set_next_state("SelectableState")

var _flipped : bool = false
var _is_flipping : bool = false
var _tween : Tween = null
@onready var _Title : RichTextLabel = $FrontFace/Title
@onready var _Description : RichTextLabel = $FrontFace/Description

func is_face_down() -> bool:
	return _flipped == false

func is_face_up() -> bool:
	return _flipped == true

func quick_flip() -> bool:
	if _is_flipping: 
		_tween.pause()
		_tween.stop()
		_is_flipping = false
	
	_flipped = !_flipped
	
	if is_face_down():
		BackFace.scale.x = 1.0
		FrontFace.scale.x = 0.0
	elif is_face_up():
		BackFace.scale.x = 0.0
		FrontFace.scale.x = 1.0
	
	return true

# returns true on successful flip
func flip() -> bool:
	if _is_flipping: return false
	
	_is_flipping = true
	_tween = create_tween()
	
	if is_face_down():
		_tween.set_ease(Tween.EASE_OUT)
		_tween.tween_property(BackFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		_tween.set_ease(Tween.EASE_IN)
		_tween.tween_property(FrontFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	elif is_face_up():
		_tween.set_ease(Tween.EASE_OUT)
		_tween.tween_property(FrontFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		_tween.set_ease(Tween.EASE_IN)
		_tween.tween_property(BackFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	
	var end_flip := func() -> void: 
		_is_flipping = false
		_flipped = !_flipped
		_tween = null
	
	_tween.tween_callback(end_flip)
	
	return true

func set_title(str : String, color : Color = Color.BLACK) -> void:
	_Title.text = "[color=#" + color.to_html(false) + "]" + str

func set_description(str : String, color : Color = Color.BLACK) -> void:
	_Description.text = "[color=#" + color.to_html(false) + "]" + str
