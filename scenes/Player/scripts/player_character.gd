extends CharacterBody2D

# Walking vars
@export var walk_speed = 150.0
@export var run_speed = 250.0
@export_range(0,1) var deceleration = 0.1
@export_range(0,1) var acceleartion = 0.08

# Jumping vars
@export var jump_speed = -250.0
@export var high_jump_speed = -350.0

@export var change_mode_sfx: AudioStreamPlayer

@export var state_machine: Node

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		var jump_velocity = jump_speed

		if GlobalState.production_mode:
			jump_velocity = high_jump_speed

		velocity.y = jump_velocity

	_toggle_production_mode()
	_handle_char_movement()

	move_and_slide()

# Handle when switching to "productive" mode
func _toggle_production_mode():
	if Input.is_action_just_pressed("change_mode"):
		change_mode_sfx.play()
		GlobalState.toggle_production_mode()

# Handle main character movement on ground
func _handle_char_movement():
	var direction := Input.get_axis("left", "right")
	var speed = walk_speed

	if GlobalState.production_mode:
		speed = run_speed
	
	# Get the input direction and handle the movement/deceleration.
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, speed * acceleartion)
	else:
		velocity.x = move_toward(velocity.x, 0, walk_speed * deceleration)
	
	# Set animation to running when moving
	# animation_tree.set("parameters/Move/blend_position", velocity.x)
