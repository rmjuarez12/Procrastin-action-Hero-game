extends Node2D

@onready var moving_platform: StaticBody2D = $Platform
@onready var original_position: Marker2D = $OriginalPosition
@onready var destination: Marker2D = $Destination

var moving_to_point_a: bool = true

func _process(delta: float) -> void:
	var speed = 50 * delta

	var point_a = original_position
	var point_b = destination

	if GlobalState.production_mode:
		if moving_to_point_a:
			moving_platform.position = moving_platform.position.move_toward(point_a.position, speed)

			if moving_platform.position == point_a.position:
				moving_to_point_a = false
		else:
			moving_platform.position = moving_platform.position.move_toward(point_b.position, speed)
			if moving_platform.position == point_b.position:
				moving_to_point_a = true
