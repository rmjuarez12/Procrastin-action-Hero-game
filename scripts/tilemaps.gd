extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)
	self.modulate = Color(0, 0.975, 0.867, 1)

func _on_production_mode_changed(is_active: bool) -> void:
	if is_active:
		self.modulate = Color(1.0, 1.0, 1.0, 1.0) 
	else:
		self.modulate = Color(0, 0.975, 0.867, 1)