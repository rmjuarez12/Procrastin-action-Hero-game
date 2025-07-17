extends Area2D

@onready var character: CharacterBody2D = get_tree().get_root().get_node("Stage/PlayerCharacter")

@export var sprite: AnimatedSprite2D

var move_speed: float = 40.0

func _ready() -> void:
	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)

func _process(delta: float) -> void:
	position.x = move_toward(position.x, character.position.x, move_speed * delta)
	position.y = move_toward(position.y, character.position.y, move_speed * delta)

	if character.position.x < position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		var hit_recoil_x: float = 200
		var hit_recoil_y: float = -150

		if body.facing_right:
			hit_recoil_x = -hit_recoil_x

		GlobalState.decrease_motivation(100)
		GlobalState.toggle_production_mode(false)
		body.is_hit = true
		body.velocity = Vector2(hit_recoil_x, hit_recoil_y)
		body.display_damage(100)
		body.invincibility_timer.start()
		body.effects_animation.play("blinking_animation")
		body.change_mode_sfx.play()
		
		queue_free()

func _on_production_mode_changed(is_active: bool) -> void:
	if is_active:
		scale = Vector2(1, 1)
		move_speed = 20.0
	else:
		scale = Vector2(2.5, 2.5)
		move_speed = 40.0
