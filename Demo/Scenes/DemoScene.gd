extends Node

@export var CardBaseScene : PackedScene

func _spawn_card() -> void:
	if CardBaseScene == null:
		printerr("Could not instance card")
		return
	
	var card := CardBaseScene.instantiate()
	add_child(card)

func _ready() -> void:
	for i in range(10):
		_spawn_card()
