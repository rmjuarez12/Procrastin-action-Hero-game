extends Node

var production_mode: bool = false
var motivation_meter: int = 100

signal production_mode_changed(is_active: bool)

func toggle_production_mode() -> void:
  production_mode = not production_mode
  emit_signal("production_mode_changed", production_mode)