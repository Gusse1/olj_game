extends Area3D

func _on_area_entered(area:Area3D) -> void:
	if area.name == "PlayerArea":
		get_tree().change_scene_to_file("res://scenes/terminal.tscn")
