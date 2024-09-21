class_name SmoothCamera extends Camera3D

@export var speed := 44.0
@export var normal_fov: float = 80
@export var stride_fov_max: float = 22
var fov_target: float = 80
var fov_transition_strength: float = 7

func _physics_process(delta: float) -> void:
	var weight: float = clamp(speed * delta, 0.0, 1.0)
	
	global_transform = global_transform.interpolate_with(
		get_parent().global_transform, weight
	)
	
	global_position = get_parent().global_position
	
	fov = lerp(fov, fov_target, delta*fov_transition_strength)


func _on_stride_striding(stride_speed: float, stride_max_speed: float) -> void:
	var fov_addition = (stride_fov_max * (stride_speed/stride_max_speed))
	fov_target = fov_addition + normal_fov
