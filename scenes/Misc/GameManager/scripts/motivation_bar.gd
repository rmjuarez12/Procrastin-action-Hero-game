extends Panel

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var value_label: Label = $ValueLabel

var initial_value: int = 100

func _ready() -> void:
	progress_bar.value = initial_value
	decrease_timer.start()

	var global_state: Node = get_node(GlobalState.get_path())
	global_state.production_mode_changed.connect(_on_production_mode_changed)
	global_state.freeze_time_changed.connect(_on_freeze_time_changed)

func update_value_label() -> void:
	value_label.text = str(int(progress_bar.value)) + "/" + str(initial_value)
	decrease_timer.start()

func _on_decrease_timer_timeout() -> void:
	progress_bar.value -= 1
	GlobalState.motivation_meter = progress_bar.value
	update_value_label()

func _on_freeze_time_changed(is_frozen: bool) -> void:
	if is_frozen:
		decrease_timer.stop()
	else:
		decrease_timer.start()

func _on_production_mode_changed(is_active: bool) -> void:

	var tint_progress_color: Color = Color(0.4803, 0.0026, 0.7936, 1.0)
	var tint_under_color: Color = Color(0.7686, 0.4275, 1.0, 1.0)

	if is_active:
		decrease_timer.wait_time = 0.2
		tint_progress_color = Color(1.0, 1.0, 1.0, 1.0)
		tint_under_color = Color(1.0, 1.0, 1.0, 1.0)
	else:
		decrease_timer.wait_time = 1.0

	progress_bar.tint_progress = tint_progress_color
	progress_bar.tint_under = tint_under_color
