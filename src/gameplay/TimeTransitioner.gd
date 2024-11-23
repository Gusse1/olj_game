extends Area3D

var active: bool = false

@export var settings: Node

@export var world_environment: WorldEnvironment
@export var original_atmosphere: Environment
@export var new_atmosphere: Environment

@export var original_light: DirectionalLight3D
@export var new_light: DirectionalLight3D

@export var spirits: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	

func _on_area_entered(area:Area3D) -> void:
	world_environment.environment = new_atmosphere
	original_light.visible = false
	new_light.visible = true
	spirits.visible = false
	settings.load_settings_from_file()
