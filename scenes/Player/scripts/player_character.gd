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
@export var invincibility_timer: Timer

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var effects_animation: AnimationPlayer = $Effects
@onready var state_machine: PlayerStateMachine = $StateMachine

@onready var damage_taken: PackedScene = preload("res://scenes/Misc/DamageCounter/damage_counter.tscn")

var facing_right: bool = true
var is_hit: bool = false

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
		toggle_run_anim = 0
	
	# Set animation to running when moving
	animation_tree.set("parameters/Move/blend_position", toggle_run_anim * direction)

# Handle flipping sprite depending on direction
func _handle_char_flip():
	if velocity.x < 0:
		sprite_2d.flip_h = true
		facing_right = false
	elif velocity.x > 0:
		sprite_2d.flip_h = false
		facing_right = true

func display_damage(damage_value: int) -> void:
	var damage_counter: Node2D = damage_taken.instantiate()
	damage_counter.position = Vector2(position.x, position.y - 50)
	damage_counter.update_value(damage_value)
	get_tree().get_root().get_node("Stage").add_child(damage_counter)


func _on_invincibility_timeout() -> void:
	invincibility_timer.stop()
	effects_animation.stop()
	is_hit = false
