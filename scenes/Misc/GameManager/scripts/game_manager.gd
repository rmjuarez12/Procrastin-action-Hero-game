extends Node

@export var motivation_bar: Panel

@export var intro_dialogue: DialogueResource

@onready var character: CharacterBody2D = get_tree().get_root().get_node("Stage/PlayerCharacter")

func _ready() -> void:
	if intro_dialogue:
		await get_tree().create_timer(0.5).timeout

		DialogueManager.show_dialogue_balloon(intro_dialogue, "start")

func add_motivation(increase_value: int) -> void:
	motivation_bar.progress_bar.value += increase_value
	motivation_bar.update_value_label()
