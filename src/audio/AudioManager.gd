extends Node

func play_audio(audio_name: String) -> void:
	get_node(audio_name).play()

func stop_audio(audio_name: String) -> void:
	get_node(audio_name).stop()
