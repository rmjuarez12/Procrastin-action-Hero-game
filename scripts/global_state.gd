extends Node

var production_mode: bool = false

func toggle_production_mode() -> void:
  production_mode = not production_mode
  print("Production mode is now: ", production_mode)
  
  # Notify other nodes if necessary
  emit_signal("production_mode_changed", production_mode)