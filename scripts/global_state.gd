extends Node

var production_mode: bool = false
var momentum_high: bool = false
var freeze_time: bool = false
var motivation_meter: float = 100

signal production_mode_changed(is_active: bool)
signal freeze_time_changed(is_frozen: bool)
signal motivation_changed(new_value: float)

func decrease_motivation(value: float) -> void:
  motivation_meter -= value
  emit_signal("motivation_changed", motivation_meter)

func toggle_production_mode() -> void:
  production_mode = not production_mode
  emit_signal("production_mode_changed", production_mode)

func freeze_game_time(freeze_now: bool) -> void:
  freeze_time = freeze_now
  emit_signal("freeze_time_changed", freeze_time)