extends Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var jitter_x: float = randf_range(-5,5)*delta
	var jitter_y: float = randf_range(-5,5)*delta
	var jitter_z:float = randf_range(-5,5)*delta
	position += Vector3(jitter_x, jitter_y, jitter_z)
