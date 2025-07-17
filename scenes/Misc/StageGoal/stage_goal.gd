extends Area2D

@export var dialogue: DialogueResource
@export var new_scene: String
@export var transition_fade: PackedScene

func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_manager_dialogue_ended)

func _on_dialogue_manager_dialogue_ended(_dialogue: DialogueResource) -> void:
	if _dialogue == dialogue:
		var transition_instance = transition_fade.instantiate()
		get_tree().get_root().add_child(transition_instance)
		transition_instance.animation_player.play("fade_in")

		await transition_instance.animation_player.animation_finished

		GlobalState.freeze_game_time(false)

		transition_instance.animation_player.play("fade_out")
		get_tree().change_scene_to_file(new_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PlayerCharacter":
		if dialogue:
			GlobalState.toggle_production_mode(false)
			DialogueManager.show_dialogue_balloon(dialogue, "start")
		else:
			print("Dialogue resource is not set for this trigger.")
