extends Node2D

@onready var moving_platform: StaticBody2D = $Platform
@onready var original_position: Marker2D = $OriginalPosition
@onready var destination: Marker2D = $Destination

func _process(delta: float) -> void:
	var speed = 150 * delta

	var point_a = original_position
	var point_b = destination

	if not GlobalState.production_mode:
		moving_platform.position = moving_platform.position.move_toward(point_a.position, speed)
	else:
		moving_platform.position = moving_platform.position.move_toward(point_b.position, speed)
