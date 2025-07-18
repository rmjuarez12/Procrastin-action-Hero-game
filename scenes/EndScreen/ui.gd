extends Node

@export var motivation_lost_val: Label
@export var completion_time_val: Label
@export var win_label: Label

func _ready() -> void:
	StageMusic.stop_music()

	motivation_lost_val.text = str(GlobalState.game_stats["motivation_lost"])

	var time_mins = GlobalState.game_stats["time_mins"]
	var time_secs = GlobalState.game_stats["time_secs"]
	var formatted_time = "%02d:%02d" % [time_mins, time_secs]
	completion_time_val.text = formatted_time

	if GlobalState.motivation_meter <= 0:
		win_label.text = "Well... There's always a next time!"
	else:
		win_label.text = "Congrats, You Defeated Procrastination!"

func _on_start_pressed() -> void:
	GlobalState.reset_to_default()

func _on_quit_pressed() -> void:
	get_tree().quit()
