extends CSGBox3D

@export var noise_texture: FastNoiseLite
@export var light: OmniLight3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	noise_texture.offset.x += delta * randf_range(0,1000)
	noise_texture.offset.y += delta * randf_range(0,1000)
	
	light.light_energy = randf_range(3,3.2)
