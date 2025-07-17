extends RigidBody2D

@export var raycast_right: RayCast2D
@export var raycast_left: RayCast2D
@export var sprite: AnimatedSprite2D
@export var detect_sprite: Sprite2D
@export var collision_shape: CollisionShape2D
@export var hitbox: Area2D
@export var sfx_detected: AudioStreamPlayer

var is_detected: bool = false
var scale_factor: float = 1.5

func _ready() -> void:
	_adjust_enemy_scale(scale_factor)

	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)

func _physics_process(_delta: float) -> void:
	if raycast_right.is_colliding() and not is_detected:
		_on_raycast_enter_function(raycast_right, true)

	if raycast_left.is_colliding() and not is_detected:
		_on_raycast_enter_function(raycast_left, false)

func _on_raycast_enter_function(raycast: RayCast2D, is_right: bool) -> void:
	if raycast == null:
		return

	var collider = raycast.get_collider()

	if collider.name == "PlayerCharacter" and not is_detected:
		if collider.is_hit or GlobalState.production_mode:
			return

		is_detected = true
		detect_sprite.visible = true
		sfx_detected.play()
		sprite.pause()

		var impulse_force: Vector2 = Vector2(80, -100)

		if is_right:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
			impulse_force = Vector2(-80, -100)

		await get_tree().create_timer(1).timeout
	
		sprite.play("attack")
		detect_sprite.visible = false
		self.apply_impulse(impulse_force)

		await get_tree().create_timer(1.5).timeout

		sprite.play("idle")
		is_detected = false

func _on_production_mode_changed(is_active: bool) -> void:
	if is_active:
		scale_factor = 0.8
	else:
		scale_factor = 1.5

	_adjust_enemy_scale(scale_factor)

func _adjust_enemy_scale(scale_val: float) -> void:
	sprite.scale = Vector2(scale_val, scale_val)
	hitbox.scale = Vector2(scale_val, scale_val)
	collision_shape.scale = Vector2(scale_val, scale_val)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter" and body.is_hit == false:
		var hit_recoil_x: float = 200
		var hit_recoil_y: float = -150

		if body.facing_right:
			hit_recoil_x = -hit_recoil_x
		
		GlobalState.toggle_production_mode(false)
		body.is_hit = true
		body.change_mode_sfx.play()
		body.velocity = Vector2(hit_recoil_x, hit_recoil_y)
		body.invincibility_timer.start()
		body.effects_animation.play("blinking_animation")

		if GlobalState.game_difficulty == "Hard":
			GlobalState.decrease_motivation(20)
			body.display_damage(20)
		else:
			GlobalState.decrease_motivation(10)
			body.display_damage(10)

		self.queue_free()
