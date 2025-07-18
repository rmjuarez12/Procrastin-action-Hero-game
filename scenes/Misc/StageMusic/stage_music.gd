extends AudioStreamPlayer

const level_music: AudioStream = preload("res://assets/summer nights.ogg")

func _play_music(music: AudioStream, volume: float = 1.0) -> void:
	if stream == music and playing:
		return

	stream = music
	volume_db = volume
	play()

func play_music_level() -> void:
	_play_music(level_music, -10.0)  # Adjust volume as needed

func stop_music() -> void:
	if playing:
		stop()