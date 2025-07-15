extends PlayerState

@export var jump_speed = -300.0
@export var high_jump_speed = -400.0
@export var jump_state: PlayerState
@export var falling_state: PlayerState
@export var sfx_jump: AudioStreamPlayer
@export var coyote_timer: Timer

var coyote_time_started: bool = false

func state_process(_delta):
	if not character.is_on_floor():
		if not coyote_time_started and GlobalState.production_mode:
			print("Coyote time started")
			coyote_time_started = true
			coyote_timer.start()
		elif not coyote_time_started and not GlobalState.production_mode:
			print("Coyote Timer not available")
			next_state = falling_state
	else:
		if coyote_time_started:
			print("Coyote time ended")
			coyote_time_started = false
			coyote_timer.stop()

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


func _on_coyote_timer_timeout() -> void:
	print("Coyote timer timeout")
	next_state = falling_state
