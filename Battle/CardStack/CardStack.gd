extends Node2D
class_name CardStack

signal stack_clicked()

enum FacingSetting  {
	## cards will face down upon being inserted
	FACE_DOWN,
	## cards will face up upon being inserted
	FACE_UP,
	## cards will maintain the facing state they were originally in
	KEEP,
}

## what should inserted cards default their facing direction to
@export var card_face_setting : FacingSetting = FacingSetting.FACE_DOWN

## the number of cards in this stack
func card_count() -> int:
	return _Stack.get_child_count()

## the number of cards but negative for use when accessing cards from the bottom
func reversed_card_count() -> int:
	return -(_Stack.get_child_count() + 1)

## get a card from the stack. does not remove the card
## if pos is 0+ then it will pick a card from the top
## if pos is less than 0 then it will pick a card from the bottom
func get_card(pos : int = 0) -> CardBase:
	return _Stack.get_child(_reversed_order(pos))

## removes the given card at position
func remove_card(pos : int = 0) -> CardBase:
	var card := _Stack.get_child(_reversed_order(pos)) as CardBase
	_Stack.remove_child(card)
	_reevaluate_subscription()
	return card

## inserts a card at position
## if pos is 0+ then it will pick a card from the top
## if pos is less than 0 then it will pick a card from the bottom
## will always insert *before* pos in the negative direction
func insert_card(card : CardBase, pos : int = 0, center_card : bool = false) -> void:
	if card == null: return
	
	if card.get_parent():
		card.get_parent().remove_child(card)
	_Stack.add_child(card)
	
	_Stack.move_child(card, _reversed_order(pos))
	if center_card: 
		card.position = Vector2.ZERO
	
	# flip card accordingly
	if card_face_setting == FacingSetting.KEEP: return
	
	if card_face_setting == FacingSetting.FACE_UP: 
		if card.is_face_down(): card.quick_flip()
	
	if card_face_setting == FacingSetting.FACE_DOWN: 
		if card.is_face_up(): card.quick_flip()
	
	_reevaluate_subscription() 

@onready var _Stack : Node2D = $Stack
var _subscribed_card : CardBase = null

func _on_card_gui_input(event : InputEvent) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == MOUSE_BUTTON_LEFT):
			stack_clicked.emit()

func _reevaluate_subscription() -> void:
	if card_count() > 0 && _subscribed_card == get_card(0): return
	
	if _subscribed_card && (_subscribed_card.get_parent() != _Stack || _subscribed_card != get_card(0)):
		_subscribed_card.gui_input.disconnect(_on_card_gui_input)
		_subscribed_card = null
	
	if card_count() > 0:
		_subscribed_card = get_card(0)
		_subscribed_card.gui_input.connect(_on_card_gui_input)

func _reversed_order(pos : int) -> int:
	return (-pos) - 1
