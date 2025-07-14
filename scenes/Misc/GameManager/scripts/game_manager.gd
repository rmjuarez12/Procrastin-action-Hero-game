extends Node

@export var motivation_bar: Panel

@onready var character: CharacterBody2D = get_tree().get_root().get_node("Stage/PlayerCharacter")

func add_motivation(increase_value: int) -> void:
  motivation_bar.progress_bar.value += increase_value
  motivation_bar.update_value_label()
