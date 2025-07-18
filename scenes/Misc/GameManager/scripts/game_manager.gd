extends Node

@export var intro_dialogue: DialogueResource
@export var timer: Timer

@onready var character: CharacterBody2D = get_tree().get_root().get_node("Stage/PlayerCharacter")

func _ready() -> void:
	StageMusic.play_music_level()

	var global_state: Node = get_node(GlobalState.get_path())
	global_state.freeze_time_changed.connect(_on_freeze_time_changed)

	if intro_dialogue:
		await get_tree().create_timer(0.5).timeout

		DialogueManager.show_dialogue_balloon(intro_dialogue, "start")

func _on_freeze_time_changed(is_frozen: bool) -> void:
	if is_frozen:
		timer.stop()
	else:
		timer.start()

func _on_timer_timeout() -> void:
	var seconds: int = GlobalState.game_stats["time_secs"]
	var minutes: int = GlobalState.game_stats["time_mins"]

	seconds += 1
	
	if seconds >= 60:
		minutes += 1
		seconds = 0

	GlobalState.game_stats["time_secs"] = seconds
	GlobalState.game_stats["time_mins"] = minutes

	print(GlobalState.game_stats)