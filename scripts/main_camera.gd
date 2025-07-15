extends Camera2D

@export var target: Node2D
@export var smoothing: float = 2

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)

func _process(delta: float) -> void:
	if target:
		position = lerp(position, target.position, smoothing * delta)

func _on_production_mode_changed(_is_active: bool) -> void:
	animation_player.play("small_shake")