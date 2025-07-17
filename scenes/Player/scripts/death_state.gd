extends PlayerState

@export var dialogue: DialogueResource

func on_enter():
	playback.travel("death")

	await get_tree().create_timer(1).timeout

	if dialogue:
		DialogueManager.show_dialogue_balloon(dialogue, "start")