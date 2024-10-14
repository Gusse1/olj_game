extends Node

var looked_at_area: Area3D
var can_interact: bool

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
			print_debug("Interacting...")
			if looked_at_area:
				looked_at_area.interact()


func _on_area_3d_area_entered(area: Area3D) -> void:
	looked_at_area = area

func _on_area_3d_area_exited(area: Area3D) -> void:
	looked_at_area = null
