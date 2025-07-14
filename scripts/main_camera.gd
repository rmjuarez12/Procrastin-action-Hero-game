extends Camera2D

@export var target: Node2D
@export var smoothing: float = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		position = lerp(position, target.position, smoothing * delta)
