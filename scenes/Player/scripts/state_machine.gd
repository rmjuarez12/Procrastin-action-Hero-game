extends Node

class_name PlayerStateMachine

@export var player_character: Node
@export var current_state : PlayerState
@export var animation_tree : AnimationTree

var states : Array[PlayerState]

func _ready() -> void:

	var global_state: Node = get_node(GlobalState.get_path())
	global_state.freeze_time_changed.connect(_on_freeze_time_changed)

	for child in get_children():
		if child is PlayerState:
			states.append(child)

			child.character = player_character
			child.playback = animation_tree["parameters/playback"]
		else:
			push_error("Child node is not a PlayerState: " + child.name)

func _input(event : InputEvent):
	current_state.state_input(event)

func _physics_process(delta: float) -> void:
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

	if GlobalState.freeze_time:
		current_state.can_move = false

func switch_states(new_state : PlayerState):
	if(current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	
	current_state = new_state
	
	current_state.on_enter()

func _on_freeze_time_changed(is_frozen: bool) -> void:
	if not is_frozen:
		current_state.can_move = true
