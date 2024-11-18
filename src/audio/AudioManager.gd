extends Node

@export var audio_stream_player_feet: AudioStreamPlayer3D
@export var audio_stream_player_perfect_stride: AudioStreamPlayer3D
@export var audio_stream_player_early_stride: AudioStreamPlayer3D
@export var audio_stream_player_thinking: AudioStreamPlayer

func play_audio(audio_name: String) -> void:
	if audio_name == "stomp":
		audio_stream_player_feet.play()
	elif audio_name == "perfect":
		audio_stream_player_perfect_stride.play()
	elif audio_name == "early":
		audio_stream_player_early_stride.play()
	elif audio_name == "thinking":
		audio_stream_player_thinking.play()

func stop_audio(audio_name: String) -> void:
	if audio_name == "thinking":
		audio_stream_player_thinking.stop()