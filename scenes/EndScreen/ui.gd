extends Node

@export var motivation_lost_val: Label
@export var completion_time_val: Label
@export var win_label: Label

var transition_fade: PackedScene = preload("res://scenes/Misc/SceneTransition/scene_transition.tscn")

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

func _on_main_menu_btn_pressed() -> void:
	var transition_instance = transition_fade.instantiate()
	get_tree().get_root().add_child(transition_instance)
	transition_instance.animation_player.play("fade_in")

	await transition_instance.animation_player.animation_finished

	transition_instance.animation_player.play("fade_out")
	get_tree().change_scene_to_file("res://scenes/MainMenu/main_menu.tscn")
