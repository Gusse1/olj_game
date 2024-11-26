extends CSGBox3D

@export var noise_texture: FastNoiseLite
@export var light: OmniLight3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	noise_texture.offset.x += delta * randf_range(0,1000)
	noise_texture.offset.y += delta * randf_range(0,1000)
	#noise_texture.seed = randf_range(0,10000)
	
	light.light_energy = randf_range(3,3.2)
