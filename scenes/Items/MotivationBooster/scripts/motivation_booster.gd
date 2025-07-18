extends Area2D

@export_enum("coffee", "energy_drink") var booster_type: String

@export var remove_on_hard: bool = false
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
		increase_value = 25
	elif booster_type == "energy_drink":
		increase_value = 35

	popup_text.text = "+ " + str(increase_value)

	if GlobalState.game_difficulty == "Hard" and remove_on_hard:
		queue_free()

func _on_body_entered(body:Node2D) -> void:
	if body.name == "PlayerCharacter" and not is_collected:
		collect_sfx.play()
		animation_player.play("collect")
		GlobalState.motivation_meter += increase_value
		is_collected = true

		if GlobalState.game_difficulty == "Hard" and GlobalState.motivation_meter > 100:
			GlobalState.motivation_meter = 100

func _on_sfx_collect_finished() -> void:
	queue_free()