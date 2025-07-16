extends PlayerState

@export_range(0,1) var decelerate_on_jump_release : float = 0.5

@export var falling_state: PlayerState

# Called every frame. 'delta' is the elapsed time since the previous frame.
func state_process(_delta: float) -> void:
	if character.velocity.y > 0:
		playback.travel("falling")
		next_state = falling_state
		next_state.can_move = true

func state_input(event : InputEvent):
	if(event.is_action_released("jump")):
		_cancel_jump()

func _cancel_jump():
	print("Jump cancelled")
	character.velocity.y *= decelerate_on_jump_release
