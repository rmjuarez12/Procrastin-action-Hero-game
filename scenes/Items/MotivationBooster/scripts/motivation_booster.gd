extends Area2D

@export_enum("coffee", "energy_drink") var booster_type: String

@export var collect_sfx: AudioStreamPlayer

@onready var game_manager: Node = get_tree().get_root().get_node("Stage/GameManager")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var popup_text: Label = $PopupText

var is_collected: bool = false
var increase_value: int = 0

func _ready() -> void:
	sprite.animation = booster_type

	if booster_type == "coffee":
		increase_value = 20
	elif booster_type == "energy_drink":
		increase_value = 30

	popup_text.text = "+ " + str(increase_value)

func _on_body_entered(body:Node2D) -> void:
	if body.name == "PlayerCharacter" and not is_collected:
		collect_sfx.play()
		animation_player.play("collect")
		game_manager.add_motivation(increase_value)
		is_collected = true

func _on_sfx_collect_finished() -> void:
	queue_free()