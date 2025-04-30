extends Control
class_name CardBase

@export var FLIP_SPEED : float = 0.2

@onready var BackFace : TextureRect = $BackFace
@onready var FrontFace : TextureRect = $FrontFace

var m_flipped : bool = false
var m_isFlipping : bool = false

func is_face_down() -> bool:
	return m_flipped == false

func is_face_up() -> bool:
	return m_flipped == true

# returns true on successful 
func flip() -> bool:
	if m_isFlipping: return false
	
	m_isFlipping = true
	var tween := create_tween()
	
	if is_face_down():
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(BackFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(FrontFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	elif is_face_up():
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(FrontFace, ":scale:x", 0.0, FLIP_SPEED * 0.5)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(BackFace, ":scale:x", 1.0, FLIP_SPEED * 0.5)
	
	var end_flip = func() -> void: 
		m_isFlipping = false
		m_flipped = !m_flipped
	
	tween.tween_callback(end_flip)
	
	return true

func _ready() -> void:
	BackFace.scale.x = 1.0
	FrontFace.scale.x = 0.0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		flip()
