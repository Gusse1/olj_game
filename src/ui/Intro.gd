extends ColorRect

var fade_out: bool

@onready var audio_manager: Node = $"../../AudioManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(audio_manager)
	audio_manager.play_audio("thinking")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade_out:
		modulate.a -= delta * 1
		if modulate.a <= 0:
			visible = false
			audio_manager.stop_audio("thinking")


func _on_shader_precompiler_all_shaders_compiled() -> void:
	await get_tree().create_timer(6.0).timeout
	fade_out = true
