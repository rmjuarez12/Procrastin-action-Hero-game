extends PlayerState

@export var jump_speed = -300.0
@export var high_jump_speed = -400.0
@export var jump_state: PlayerState
@export var falling_state: PlayerState
@export var sfx_jump: AudioStreamPlayer

func state_process(_delta):
	if not character.is_on_floor():
		next_state = falling_state

func state_input(event : InputEvent):
	if(event.is_action_pressed("jump") and can_move):
		jump(event)

func jump(_event : InputEvent):
	var jump_velocity = jump_speed

	if GlobalState.production_mode or GlobalState.momentum_high:
		jump_velocity = high_jump_speed
	else:
		can_move = false
		playback.travel("charge_jump")
		await get_tree().create_timer(0.6).timeout

	can_move = true

	character.velocity.y = jump_velocity
	next_state = jump_state
	next_state.can_move = true
	playback.travel("jump")
	sfx_jump.play()
