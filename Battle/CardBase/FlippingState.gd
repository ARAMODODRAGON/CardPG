extends State

func is_face_down() -> bool:
	return _flipped == false

func is_face_up() -> bool:
	return _flipped == true

@onready var Card : CardBase = owner as CardBase

var _flipped : bool = false
var _tween : Tween = null

func _ready() -> void:
	super._ready()
	# some initial set up
	Card.BackFace.scale.x = 1.0
	Card.FrontFace.scale.x = 0.0

func _state_enter(last : String) -> void: 
	_tween = create_tween()
	
	if is_face_down():
		_tween.set_ease(Tween.EASE_OUT)
		_tween.tween_property(Card.BackFace, ":scale:x", 0.0, Card.FLIP_SPEED * 0.5)
		_tween.set_ease(Tween.EASE_IN)
		_tween.tween_property(Card.FrontFace, ":scale:x", 1.0, Card.FLIP_SPEED * 0.5)
	elif is_face_up():
		_tween.set_ease(Tween.EASE_OUT)
		_tween.tween_property(Card.FrontFace, ":scale:x", 0.0, Card.FLIP_SPEED * 0.5)
		_tween.set_ease(Tween.EASE_IN)
		_tween.tween_property(Card.BackFace, ":scale:x", 1.0, Card.FLIP_SPEED * 0.5)
	
	var end_flip := func() -> void: 
		_flipped = !_flipped
		if last != self.name:
			get_statemachine().set_next_state(last)
		else:
			get_statemachine().set_next_state("SelectableState")
	
	_tween.tween_callback(end_flip)
	

func _state_exit(next : String) -> void: 
	if _tween && _tween.is_running():
		_tween.pause()
		_tween.custom_step(Card.FLIP_SPEED)
	_tween = null
