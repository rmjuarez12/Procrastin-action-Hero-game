extends CanvasLayer

var transition_fade: PackedScene = preload("res://scenes/Misc/SceneTransition/scene_transition.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not get_tree().paused:
		get_tree().paused = true
		visible = true
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		get_tree().paused = false
		visible = false


func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_retry_pressed() -> void:
	get_tree().paused = false
	GlobalState.reset_to_default()


func _on_back_to_title_pressed() -> void:
	get_tree().paused = false
	var transition_instance = transition_fade.instantiate()
	get_tree().get_root().add_child(transition_instance)
	transition_instance.animation_player.play("fade_in")

	await transition_instance.animation_player.animation_finished

	transition_instance.animation_player.play("fade_out")
	get_tree().change_scene_to_file("res://scenes/MainMenu/main_menu.tscn")
