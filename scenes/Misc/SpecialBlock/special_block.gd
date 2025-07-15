extends Node2D

@export var block_on_sprite: TileMapLayer 
@export var block_off_sprite: TileMapLayer

func _process(_delta: float) -> void:
	if GlobalState.production_mode:
		block_on_sprite.enabled = true
		block_off_sprite.enabled = false
	else:
		block_on_sprite.enabled = false
		block_off_sprite.enabled = true
