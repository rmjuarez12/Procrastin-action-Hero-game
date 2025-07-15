extends Node

@export var intro_dialogue: DialogueResource

@onready var character: CharacterBody2D = get_tree().get_root().get_node("Stage/PlayerCharacter")

func _ready() -> void:
	StageMusic.play_music_level()

	if intro_dialogue:
		await get_tree().create_timer(0.5).timeout

		DialogueManager.show_dialogue_balloon(intro_dialogue, "start")