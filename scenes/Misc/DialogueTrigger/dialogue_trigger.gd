extends Area2D

@export var dialogue: DialogueResource

func _on_body_entered(body:Node2D) -> void:
	if body.name == "PlayerCharacter":
		if dialogue:
			DialogueManager.show_dialogue_balloon(dialogue, "start")
			queue_free()
		else:
			print("Dialogue resource is not set for this trigger.")
