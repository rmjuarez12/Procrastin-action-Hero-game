extends Label

@export var player_character: CharacterBody2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var curr_state = player_character.state_machine.current_state.name
	text = "State: " + curr_state
