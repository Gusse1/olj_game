extends ColorRect

var fade_out: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade_out:
		color.a -= delta * 0.5
		if color.a <= 0:
			visible = false


func _on_shader_precompiler_all_shaders_compiled() -> void:
	fade_out = true
