extends CharacterBody2D

# Walking vars
@export var walk_speed = 100.0
@export var run_speed = 200.0
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
@onready var decrease_momentum_timer: Timer = $ProgressBar/DecreaseMeter
@onready var decrease_momentum_buffer_timer: Timer = $ProgressBar/DecreaseMeterBuffer

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
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
	
	# Set animation to running when moving
	animation_tree.set("parameters/Move/blend_position", toggle_run_anim * direction)

	# Handle momentum bar
	if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		increase_momentum_timer.start()
		decrease_momentum_timer.stop()
		decrease_momentum_buffer_timer.stop()
	elif Input.is_action_just_released("left") or Input.is_action_just_released("right"):
		decrease_momentum_buffer_timer.start()
		increase_momentum_timer.stop()

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

func _on_decrease_meter_timeout() -> void:
	print("Decreasing momentum")
	momentum_bar.value -= 2

	if momentum_bar.value == 0:
		decrease_momentum_timer.stop()

func _on_decrease_meter_buffer_timeout() -> void:
	print("Preparing to decrease momentum")
	decrease_momentum_buffer_timer.stop()
	decrease_momentum_timer.start()
