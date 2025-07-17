extends Panel

@export var main_menu: VBoxContainer
@export var options_menu: VBoxContainer
@export var normal_difficulty: Label
@export var hard_difficulty: Label
@export var transition_fade: PackedScene

var master_audio_bus = AudioServer.get_bus_index("Master")
var music_audio_bus = AudioServer.get_bus_index("bgm")
var sfx_audio_bus = AudioServer.get_bus_index("sfx")

func _on_start_pressed() -> void:
	GlobalState.reset_to_default()

func _on_options_pressed() -> void:
	options_menu.visible = true
	main_menu.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_save_pressed() -> void:
	options_menu.visible = false
	main_menu.visible = true

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_audio_bus, linear_to_db(value))

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_audio_bus, linear_to_db(value))

func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			GlobalState.game_difficulty = "Normal"
			normal_difficulty.visible = true
			hard_difficulty.visible = false
		1:
			GlobalState.game_difficulty = "Hard"
			normal_difficulty.visible = false
			hard_difficulty.visible = true
