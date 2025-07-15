extends Area2D

@export var checkpoint: Marker2D
@export var fall_sfx: AudioStreamPlayer

func _on_body_entered(body:Node2D) -> void:
	if body.name == "PlayerCharacter":
		
		fall_sfx.play()
		GlobalState.freeze_game_time(true)
		GlobalState.decrease_motivation(20.0)  
		body.display_damage(20)  # Display damage taken

		await get_tree().create_timer(1.0).timeout

		body.position = checkpoint.position
		GlobalState.freeze_game_time(false)
