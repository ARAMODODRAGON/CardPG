extends Node

@export var CardBaseScene : PackedScene
@export var PickupStack : CardStack
@export var DropStack : CardStack

func _spawn_card() -> CardBase:
	if CardBaseScene == null || PickupStack == null:
		printerr("Could not instance card")
		return null
	
	var card := CardBaseScene.instantiate() as CardBase
	PickupStack.insert_card(card)
	
	return card

func _ready() -> void:
	for i in range(10):
		var card := _spawn_card()
		if card: 
			card.set_title("Card #" + str(i + 1), Color.from_hsv(randf_range(0.0, 1.0), 0.5, 1.0))
	
	DropStack.card_face_setting = DropStack.FacingSetting.FACE_UP


func _on_pickup_stack_stack_clicked() -> void:
	var card := PickupStack.remove_card()
	DropStack.insert_card(card)
