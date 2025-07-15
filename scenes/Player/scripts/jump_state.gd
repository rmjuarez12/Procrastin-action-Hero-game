extends PlayerState

@export_range(0,1) var decelerate_on_jump_release : float = 0.5

@export var falling_state: PlayerState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# print(character.velocity.y)

	if character.velocity.y > 100:
		playback.travel("falling")
		next_state = falling_state
		next_state.can_move = true

func on_exit():
	print("Exiting Jump State")

# func state_input(event : InputEvent):
# 	if(event.is_action_released("jump")):
# 		_cancel_jump()

func _cancel_jump():
	character.velocity.y *= decelerate_on_jump_release
