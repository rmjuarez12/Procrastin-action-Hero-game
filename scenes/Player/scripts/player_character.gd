extends CharacterBody2D

# Walking vars
@export var walk_speed = 100.0
@export var run_speed = 150.0
@export_range(0,1) var deceleration = 0.1
@export_range(0,1) var acceleartion = 0.08

# Jumping vars
@export var jump_speed = -250.0
@export var high_jump_speed = -350.0

@export var change_mode_sfx: AudioStreamPlayer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine: PlayerStateMachine = $StateMachine

@onready var momentum_bar: ProgressBar = $ProgressBar
@onready var increase_momentum_timer: Timer = $ProgressBar/IncreaseMeter
@onready var decrease_momentum_buffer_timer: Timer = $ProgressBar/DecreaseMeterBuffer

var is_momentum_increasing: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	_toggle_production_mode()
	_handle_char_movement()
	_handle_char_flip()

	move_and_slide()

# Handle when switching to "productive" mode
func _toggle_production_mode():
	if Input.is_action_just_pressed("change_mode"):
		change_mode_sfx.play()
		GlobalState.toggle_production_mode()

		if not GlobalState.production_mode:
			momentum_bar.value = 0
			GlobalState.momentum_high = false

# Handle main character movement on ground
func _handle_char_movement():
	var direction := Input.get_axis("left", "right")
	var speed = walk_speed
	var toggle_run_anim = 1

	if GlobalState.production_mode or GlobalState.momentum_high:
		speed = run_speed
		toggle_run_anim = 2
	
	# Get the input direction and handle the movement/deceleration.
	if direction and state_machine.current_state.can_move:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleartion)

		# if not is_momentum_increasing:
		# 	increase_momentum_timer.start()
		# 	decrease_momentum_buffer_timer.stop()
		# 	is_momentum_increasing = true
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
		toggle_run_anim = 0

		# if is_momentum_increasing:
		# 	decrease_momentum_buffer_timer.start()
		# 	increase_momentum_timer.stop()
		# 	is_momentum_increasing = false
	
	# Set animation to running when moving
	animation_tree.set("parameters/Move/blend_position", toggle_run_anim * direction)

# Handle flipping sprite depending on direction
func _handle_char_flip():
	if velocity.x < 0:
		sprite_2d.flip_h = true
	elif velocity.x > 0:
		sprite_2d.flip_h = false

func _on_increase_meter_timeout() -> void:
	momentum_bar.value += 1
	if momentum_bar.value == 5:
		GlobalState.momentum_high = true

func _on_decrease_meter_buffer_timeout() -> void:
	decrease_momentum_buffer_timer.stop()
	momentum_bar.value = 0
	GlobalState.momentum_high = false
