extends AudioStreamPlayer

const level_music: AudioStream = preload("res://assets/Sunlight Through Leaves.wav")

func _play_music(music: AudioStream, volume: float = 1.0) -> void:
	if stream == music:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level() -> void:
	_play_music(level_music)