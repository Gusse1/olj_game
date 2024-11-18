extends Node

@onready var audio_stream_player_feet: AudioStreamPlayer3D = $FeetAudio
@onready var audio_stream_player_perfect_stride: AudioStreamPlayer3D = $PerfectStrideAudio


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_audio(audio_name: String) -> void:
	if audio_name == "stomp":
		audio_stream_player_feet.play()
	elif audio_name == "perfect":
		audio_stream_player_perfect_stride.play()