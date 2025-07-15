extends Node2D

@export var counter_label: Label

func _ready() -> void:
  await get_tree().create_timer(1.0).timeout
  queue_free()  

func update_value(value: int) -> void:
  counter_label.text = "- " + str(value)
