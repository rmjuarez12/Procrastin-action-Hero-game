extends PlayerState

@export var ground_state : PlayerState

func on_enter():
	playback.stop()
	playback.travel("landing")

func state_process(_delta):
	next_state = ground_state
# 	playback.stop()
# 	playback.travel("landing")