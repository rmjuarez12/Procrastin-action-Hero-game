extends Node

class_name CharacterState

@export var can_move: bool = true

var character : CharacterBody2D
var next_state : CharacterState
var playback : AnimationNodeStateMachinePlayback

func state_process(_delta):
	pass

func state_input(_event : InputEvent):
	pass

func on_enter():
	pass
	
func on_exit():
	pass