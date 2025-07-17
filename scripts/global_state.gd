extends Node

var production_mode: bool = false
var momentum_high: bool = false
var freeze_time: bool = false
var motivation_meter: float = 100
var initial_motivation: float = 100

var game_difficulty: String = "Normal"

var transition_fade: PackedScene = preload("res://scenes/Misc/SceneTransition/scene_transition.tscn")

var stage_one_path: String = "res://scenes/Stages/stage_one.tscn"

var default_state: Dictionary = {
  "production_mode": false,
  "momentum_high": false,
  "freeze_time": false,
  "motivation_meter": 100,
  "initial_motivation": 100
}

signal production_mode_changed(is_active: bool)
signal freeze_time_changed(is_frozen: bool)
signal motivation_changed(new_value: float)

func decrease_motivation(value: float) -> void:
  motivation_meter -= value

  if motivation_meter < 0:
    motivation_meter = 1

  emit_signal("motivation_changed", motivation_meter)

func toggle_production_mode(state: bool = not production_mode) -> void:
  production_mode = state
  emit_signal("production_mode_changed", production_mode)

func freeze_game_time(freeze_now: bool) -> void:
  freeze_time = freeze_now
  emit_signal("freeze_time_changed", freeze_time)

func handle_death() -> void:
  motivation_meter = 0
  freeze_game_time(true)
  toggle_production_mode(false)

func reset_to_default() -> void:
  production_mode = default_state["production_mode"]
  momentum_high = default_state["momentum_high"]
  freeze_time = default_state["freeze_time"]
  motivation_meter = default_state["motivation_meter"]
  initial_motivation = default_state["initial_motivation"]

  var transition_instance = transition_fade.instantiate()
  get_tree().get_root().add_child(transition_instance)
  transition_instance.animation_player.play("fade_in")

  await transition_instance.animation_player.animation_finished

  transition_instance.animation_player.play("fade_out")
  get_tree().change_scene_to_file(stage_one_path)

func quit_game() -> void:
  get_tree().quit()