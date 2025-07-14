extends Panel

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var decrease_timer: Timer = $DecreaseTimer
@onready var value_label: Label = $ValueLabel
var initial_value: int = 100

func _ready() -> void:
	progress_bar.value = initial_value
	decrease_timer.start()

func update_value_label() -> void:
	value_label.text = str(int(progress_bar.value)) + "/" + str(initial_value)
	decrease_timer.start()

func _on_decrease_timer_timeout() -> void:
	progress_bar.value -= 1
	update_value_label()
