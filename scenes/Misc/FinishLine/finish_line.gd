extends Area2D

@export var new_scene: String
@export var transition_fade: PackedScene

func _on_body_entered(body:Node2D) -> void:
	if body.name == "PlayerCharacter":

		var transition_instance = transition_fade.instantiate()
		get_tree().get_root().add_child(transition_instance)
		transition_instance.animation_player.play("fade_in")

		await transition_instance.animation_player.animation_finished

		transition_instance.animation_player.play("fade_out")
		get_tree().change_scene_to_file(new_scene)
