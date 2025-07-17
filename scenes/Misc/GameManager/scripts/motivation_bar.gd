extends Panel

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var value_label: Label = $ValueLabel

func _ready() -> void:
	progress_bar.value = GlobalState.motivation_meter
	decrease_timer.start()

	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)
	global_state.freeze_time_changed.connect(_on_freeze_time_changed)
	global_state.motivation_changed.connect(_on_motivation_changed)

func update_value_label() -> void:
	value_label.text = str(int(GlobalState.motivation_meter)) + "/" + str(int(GlobalState.initial_motivation))
	decrease_timer.start()

func _on_decrease_timer_timeout() -> void:
	GlobalState.motivation_meter -= 1.0
	progress_bar.value = GlobalState.motivation_meter
	update_value_label()

	if GlobalState.motivation_meter <= 0:
		GlobalState.handle_death()
		decrease_timer.stop()

func _on_motivation_changed(new_value: float) -> void:
	progress_bar.value = new_value
	update_value_label()

func _on_freeze_time_changed(is_frozen: bool) -> void:
	if is_frozen:
		decrease_timer.stop()
	else:
		decrease_timer.start()

func _on_production_mode_changed(is_active: bool) -> void:

	var tint_progress_color: Color = Color(0.4803, 0.0026, 0.7936, 1.0)
	var tint_under_color: Color = Color(0.7686, 0.4275, 1.0, 1.0)
	var decrease_timer_countdown: float = 1.0

	if is_active:
		tint_progress_color = Color(1.0, 1.0, 1.0, 1.0)
		tint_under_color = Color(1.0, 1.0, 1.0, 1.0)

		if GlobalState.game_difficulty == "Hard":
			decrease_timer_countdown = 1
		else: 
			decrease_timer_countdown = 0.2
	else:
		if GlobalState.game_difficulty == "Hard":
			decrease_timer_countdown = 1.5
		else: 
			decrease_timer_countdown = 1.0

	decrease_timer.wait_time = decrease_timer_countdown

	progress_bar.tint_progress = tint_progress_color
	progress_bar.tint_under = tint_under_color
