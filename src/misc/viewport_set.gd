extends MeshInstance3D

@export var viewport: SubViewport

# This script is a workaround to a Godot bug where it loses the path of the viewport on project reloads randomly
func _ready():
	get_active_material(1).set_texture(StandardMaterial3D.TEXTURE_ALBEDO, viewport.get_texture())
